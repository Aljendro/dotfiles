(ns aljendro.cli.commands.ui.fleet
  (:require ["ink" :as ink]
            ["child_process" :as cp]
            ["path" :as path]
            [reagent.core :as r]))

;; ── Constants ─────────────────────────────────────────────────────────────────

;; Detect the tmux session this TUI is running inside; error if not in tmux
(def tmux-session (.trim (.toString (.execSync cp "tmux display-message -p '#S'"))))

;; Use the tmux session's root directory so worktrees stay relative to the repo
;; regardless of which directory the script was launched from
(def tmux-session-root (.trim (.toString (.execSync cp "tmux display-message -p '#{session_path}'"))))
(def worktree-base (path/join tmux-session-root ".worktrees"))

;; ── State ─────────────────────────────────────────────────────────────────────

(defonce app-state
  (r/atom {:agents   []
           :selected 0
           :view     :list   ; :list :create :detail
           :error    nil
           :log      []}))

(defonce create-state
  (r/atom {:step      :branch  ; :branch :env :lima-name :ec2-host :confirm
           :branch    ""
           :env       :local
           :env-idx   0
           :lima-name "dev"
           :ec2-host  ""}))

;; ── Shell Utilities ───────────────────────────────────────────────────────────

(defn exec! [cmd]
  (js/Promise.
   (fn [resolve reject]
     (.exec cp cmd
            (fn [err stdout stderr]
              (if err
                (reject (str (or (.-message err) "") " " (or stderr "")))
                (resolve (.trim (str stdout)))))))))

(defn log! [msg]
  (swap! app-state update :log conj {:ts (.toISOString (js/Date.)) :msg msg}))

(defn set-error! [msg]
  (swap! app-state assoc :error msg))

(defn clear-error! []
  (swap! app-state assoc :error nil))

;; ── tmux ──────────────────────────────────────────────────────────────────────

(defn ensure-session! []
  (exec! (str "tmux has-session -t " tmux-session
              " 2>/dev/null || tmux new-session -d -s " tmux-session)))

(defn new-window! [window-name]
  (exec! (str "tmux new-window -t " tmux-session " -n " (js/JSON.stringify window-name))))

(defn send-keys! [window-name cmd]
  (exec! (str "tmux send-keys -t " tmux-session ":" (js/JSON.stringify window-name)
              " " (js/JSON.stringify cmd) " Enter")))

(defn kill-window! [window-name]
  (exec! (str "tmux kill-window -t " tmux-session ":" (js/JSON.stringify window-name)
              " 2>/dev/null || true")))

;; switch-client works inside tmux; fall back to attach for non-tmux terminals
(defn switch-to-window! [window-name]
  (exec! (str "tmux switch-client -t " tmux-session ":" (js/JSON.stringify window-name)
              " 2>/dev/null || tmux attach-session -t " tmux-session
              " -t " (js/JSON.stringify window-name))))

;; ── Git Worktrees ─────────────────────────────────────────────────────────────

(defn worktree-path [branch]
  (path/join worktree-base (.. branch (replace #"/" "-"))))

(defn create-worktree! [branch]
  (let [wt-path (worktree-path branch)]
    (exec! (str "mkdir -p " (js/JSON.stringify worktree-base) " && ("
                "git worktree add " (js/JSON.stringify wt-path)
                " " (js/JSON.stringify branch)
                " 2>/dev/null || git worktree add -b " (js/JSON.stringify branch)
                " " (js/JSON.stringify wt-path) " HEAD)"))))

(defn remove-worktree! [branch]
  (exec! (str "git worktree remove --force "
              (js/JSON.stringify (worktree-path branch)) " 2>/dev/null || true")))

;; ── Lima ──────────────────────────────────────────────────────────────────────

(defn lima-start! [vm-name wt-path]
  ;; --mount-only restricts the VM to only the worktree directory with write access
  (exec! (str "limactl start --name " (js/JSON.stringify vm-name)
              " -y template:fedora --mount-only " (js/JSON.stringify (str wt-path ":w"))
              " 2>/dev/null || true")))

(defn lima-stop! [vm-name]
  (exec! (str "limactl stop " (js/JSON.stringify vm-name) " 2>/dev/null || true")))

;; Lima mounts only the worktree directory (.:w), so changes in the VM are
;; immediately visible on the host at the same path — no rsync needed.
(defn lima-sync-note [] "Lima mounts the worktree dir — changes are immediately visible locally.")

;; ── EC2 ───────────────────────────────────────────────────────────────────────

(defn rsync-to-ec2! [ec2-host branch]
  (let [wt-path (worktree-path branch)]
    (exec! (str "rsync -avz --delete --exclude='.git' "
                (js/JSON.stringify (str wt-path "/"))
                " " (js/JSON.stringify ec2-host) ":" (js/JSON.stringify (str wt-path "/"))))))

(defn rsync-from-ec2! [ec2-host branch]
  (let [wt-path (worktree-path branch)]
    (exec! (str "rsync -avz --delete --exclude='.git' "
                (js/JSON.stringify ec2-host) ":" (js/JSON.stringify (str wt-path "/"))
                " " (js/JSON.stringify (str wt-path "/"))))))

;; ── Agent Lifecycle ───────────────────────────────────────────────────────────

(defn gen-id [] (str "a" (mod (.now js/Date) 99999)))

(defn update-agent! [id f]
  (swap! app-state update :agents (fn [agents] (mapv #(if (= (:id %) id) (f %) %) agents))))

(defn start-agent! [agent]
  (let [{:keys [id branch env lima-name ec2-host]} agent
        wt-path (worktree-path branch)]
    (-> (ensure-session!)
        (.then #(create-worktree! branch))
        (.then (fn [_]
                 (case env
                   :lima (lima-start! lima-name wt-path)
                   :ec2  (rsync-to-ec2! ec2-host branch)
                   (js/Promise.resolve nil))))
        (.then #(new-window! id))
        (.then (fn [_]
                 (case env
                   :local (send-keys! id (str "cd " wt-path " && claude"))
                   :lima  (send-keys! id (str "limactl shell " lima-name
                                              " -- bash -c 'cd " wt-path " && claude'"))
                   :ec2   (send-keys! id (str "ssh -t " ec2-host
                                              " 'cd " wt-path " && claude'")))))
        (.then (fn [_]
                 (update-agent! id #(assoc % :status :running))
                 (log! (str "Started agent " id " [" branch "] on " (name env)))))
        (.catch (fn [err]
                  (update-agent! id #(assoc % :status :error))
                  (set-error! (str "Start failed: " err)))))))

(defn sync-agent! [agent]
  (let [{:keys [id env ec2-host branch]} agent]
    (case env
      :local nil
      :lima  (log! (lima-sync-note))
      :ec2   (do
               (update-agent! id #(assoc % :status :syncing))
               (-> (rsync-from-ec2! ec2-host branch)
                   (.then (fn [_]
                            (update-agent! id #(assoc % :status :running
                                                      :last-sync (.toISOString (js/Date.))))
                            (log! (str "Synced " id " from EC2"))))
                   (.catch (fn [err]
                             (update-agent! id #(assoc % :status :error))
                             (set-error! (str "Sync failed: " err)))))))))

(defn delete-agent! [agent]
  (let [{:keys [id branch env lima-name]} agent]
    (-> (kill-window! id)
        (.then (fn [_]
                 (when (= env :lima) (lima-stop! lima-name))
                 (remove-worktree! branch)))
        (.then (fn [_]
                 (swap! app-state update :agents #(filterv (fn [a] (not= (:id a) id)) %))
                 (swap! app-state update :selected #(max 0 (dec %)))
                 (log! (str "Deleted agent " id))))
        (.catch (fn [err] (set-error! (str "Delete failed: " err)))))))

(defn attach-agent! [agent]
  (-> (switch-to-window! (:id agent))
      (.catch (fn [err] (set-error! (str "Attach failed: " err))))))

;; ── UI Helpers ────────────────────────────────────────────────────────────────

(defn pad-right [s n]
  (let [s   (str s)
        len (count s)]
    (if (>= len n) (subs s 0 n) (str s (apply str (repeat (- n len) " "))))))

(defn status-color [status]
  (case status
    :running  "green"
    :starting "yellow"
    :syncing  "cyan"
    :error    "red"
    "gray"))

(defn status-label [status]
  (case status
    :running  "RUNNING "
    :starting "STARTING"
    :syncing  "SYNCING "
    :error    "ERROR   "
    "IDLE    "))

(defn env-color [env]
  (case env :local "white" :lima "cyan" :ec2 "magenta" "gray"))

(defn time-ago [iso-str]
  (when iso-str
    (let [diff (- (.now js/Date) (.getTime (js/Date. iso-str)))
          secs (js/Math.floor (/ diff 1000))
          mins (js/Math.floor (/ secs 60))]
      (cond (< mins 1)  (str secs "s ago")
            (< mins 60) (str mins "m ago")
            :else       (str (js/Math.floor (/ mins 60)) "h ago")))))

;; ── TextInput ─────────────────────────────────────────────────────────────────

(defn TextInput [{:keys [value placeholder]}]
  (if (seq value)
    [:> ink/Text {:color "white"} (str value "▌")]
    [:> ink/Text {:color "gray"} (str (or placeholder "") "▌")]))

;; ── AgentRow ──────────────────────────────────────────────────────────────────

(defn AgentRow [agent selected?]
  (let [{:keys [branch env status last-sync]} agent]
    [:> ink/Box {:flexDirection "row"}
     [:> ink/Text {:color (if selected? "cyan" "gray")}
      (if selected? "▶ " "  ")]
     [:> ink/Text {:color "white"}
      (pad-right branch 22)]
     [:> ink/Text {:color (env-color env)}
      (pad-right (str " " (name env)) 8)]
     [:> ink/Text {:color (status-color status) :bold selected?}
      (str " " (status-label status) " ")]
     [:> ink/Text {:color "gray"}
      (str "  " (or (time-ago last-sync) "—"))]]))

;; ── Create Wizard ─────────────────────────────────────────────────────────────

(def envs [:local :lima :ec2])

(defn CreateWizard []
  (let [{:keys [step branch env lima-name ec2-host]} @create-state]
    [:> ink/Box {:flexDirection "column" :borderStyle "round" :borderColor "cyan"
                 :paddingX 2 :paddingY 1 :width 60}
     [:> ink/Text {:bold true :color "cyan"} "New Agent"]

     [:> ink/Box {:marginTop 1 :flexDirection "column"}
      ;; Branch
      [:> ink/Box {:flexDirection "row" :marginBottom 1}
       [:> ink/Text {:color (if (= step :branch) "cyan" "gray")} "Branch:      "]
       (if (= step :branch)
         [TextInput {:value branch :placeholder "feature/my-branch"}]
         [:> ink/Text {:color "white"} branch])]

      ;; Environment
      [:> ink/Box {:flexDirection "row" :marginBottom 1}
       [:> ink/Text {:color (if (= step :env) "cyan" "gray")} "Environment: "]
       (into [:> ink/Box {:flexDirection "row"}]
             (map (fn [e]
                    [:> ink/Box {:key (name e) :marginRight 2}
                     [:> ink/Text {:color (if (= e env) (env-color e) "gray")}
                      (str (if (= e env) "◉ " "○ ") (name e))]])
                  envs))]

      ;; Lima VM name (only for :lima)
      (when (and (= env :lima) (not= step :branch))
        [:> ink/Box {:flexDirection "row" :marginBottom 1}
         [:> ink/Text {:color (if (= step :lima-name) "cyan" "gray")} "VM name:     "]
         (if (= step :lima-name)
           [TextInput {:value lima-name :placeholder "dev"}]
           [:> ink/Text {:color "white"} lima-name])])

      ;; EC2 host (only for :ec2)
      (when (and (= env :ec2) (not= step :branch))
        [:> ink/Box {:flexDirection "row" :marginBottom 1}
         [:> ink/Text {:color (if (= step :ec2-host) "cyan" "gray")} "EC2 host:    "]
         (if (= step :ec2-host)
           [TextInput {:value ec2-host :placeholder "ec2-user@1.2.3.4"}]
           [:> ink/Text {:color "white"} ec2-host])])]

     [:> ink/Box {:marginTop 1}
      [:> ink/Text {:color "gray"}
       (case step
         :branch    "Type branch name · Enter to continue · Esc cancel"
         :env       "← → select env · Enter continue · Esc cancel"
         :lima-name "Type VM name · Enter continue · Esc cancel"
         :ec2-host  "Type host · Enter continue · Esc cancel"
         :confirm   "Enter to create · Esc cancel"
         "")]]]))

;; ── Detail View ───────────────────────────────────────────────────────────────

(defn DetailView [agent cols]
  (let [{:keys [branch env status last-sync lima-name ec2-host]} agent
        sep (apply str (repeat (- cols 2) "─"))]
    [:> ink/Box {:flexDirection "column" :paddingX 1}
     [:> ink/Box {:marginBottom 1}
      [:> ink/Text {:bold true :color "cyan"} "Agent Detail"]]
     [:> ink/Box {:flexDirection "column" :marginBottom 1}
      [:> ink/Box {:flexDirection "row"}
       [:> ink/Text {:color "gray"} (pad-right "Branch"  10)]
       [:> ink/Text {:color "white"} branch]]
      [:> ink/Box {:flexDirection "row"}
       [:> ink/Text {:color "gray"} (pad-right "Env"     10)]
       [:> ink/Text {:color (env-color env)} (name env)]]
      [:> ink/Box {:flexDirection "row"}
       [:> ink/Text {:color "gray"} (pad-right "Status"  10)]
       [:> ink/Text {:color (status-color status)} (name status)]]
      [:> ink/Box {:flexDirection "row"}
       [:> ink/Text {:color "gray"} (pad-right "Worktree" 10)]
       [:> ink/Text {:color "gray"} (worktree-path branch)]]
      (when lima-name
        [:> ink/Box {:flexDirection "row"}
         [:> ink/Text {:color "gray"} (pad-right "VM name" 10)]
         [:> ink/Text {:color "white"} lima-name]])
      (when ec2-host
        [:> ink/Box {:flexDirection "row"}
         [:> ink/Text {:color "gray"} (pad-right "EC2 host" 10)]
         [:> ink/Text {:color "white"} ec2-host]])
      [:> ink/Box {:flexDirection "row"}
       [:> ink/Text {:color "gray"} (pad-right "Synced" 10)]
       [:> ink/Text {:color "white"} (or (time-ago last-sync) "never")]]]
     [:> ink/Box {}
      [:> ink/Text {:color "gray"} sep]]
     [:> ink/Box {:marginTop 1}
      (case env
        :local [:> ink/Text {:color "gray"} "Local worktree — changes are on disk immediately."]
        :lima  [:> ink/Text {:color "cyan"} "Lima mounts the worktree dir — no manual sync needed."]
        :ec2   [:> ink/Text {:color "magenta"} "EC2 remote — press 's' to rsync changes back."]
        nil)]
     [:> ink/Box {:marginTop 1}
      [:> ink/Text {:color "gray"} "a attach  s sync  d delete  Esc back"]]]))

;; ── App (list view) ───────────────────────────────────────────────────────────

(defn App [rows cols]
  (let [{:keys [agents selected view error]} @app-state
        total   (count agents)
        running (count (filter #(= :running (:status %)) agents))
        sep     (apply str (repeat cols "─"))]
    [:> ink/Box {:height rows :width cols :flexDirection "column"}

     ;; Title bar
     [:> ink/Box {:paddingX 1}
      [:> ink/Text {:bold true :color "cyan"} "Fleet Manager"]
      [:> ink/Text {:color "gray"} (str "   agents:" total)]
      [:> ink/Spacer]
      [:> ink/Text {:color "green"} (str "● " running " running")]
      (when error
        [:> ink/Text {:color "red"} (str "   ✗ " error)])]

     [:> ink/Box {}
      [:> ink/Text {:color "gray"} sep]]

     ;; Content
     (case view
       :list
       [:> ink/Box {:flexDirection "column" :flexGrow 1}
        [:> ink/Box {:paddingX 1}
         [:> ink/Text {:bold true :color "gray"}
          (str "  " (pad-right "BRANCH" 22) (pad-right " ENV" 8)
               " STATUS     LAST SYNC")]]
        [:> ink/Box {}
         [:> ink/Text {:color "gray"} sep]]
        (if (empty? agents)
          [:> ink/Box {:paddingX 3 :marginTop 1}
           [:> ink/Text {:color "gray"} "No agents. Press 'n' to create one."]]
          (into [:> ink/Box {:flexDirection "column"}]
                (map-indexed
                 (fn [i a] ^{:key (:id a)} [AgentRow a (= i selected)])
                 agents)))
        [:> ink/Spacer]
        [:> ink/Box {:borderStyle "single" :borderColor "gray" :paddingX 1}
         [:> ink/Text {:color "gray"}
          "n new   a attach   s sync   d delete   ↑↓ navigate   Enter detail   q quit"]]]

       :create
       [:> ink/Box {:flexDirection "column" :flexGrow 1 :paddingX 2 :paddingTop 1}
        [CreateWizard]]

       :detail
       (when-let [agent (nth agents selected nil)]
         [:> ink/Box {:flexDirection "column" :flexGrow 1}
          [DetailView agent cols]])

       [:> ink/Text {:color "red"} "Unknown view"])]))

;; ── Input Handling ────────────────────────────────────────────────────────────

(defn handle-create-input [input key]
  (let [{:keys [step branch env env-idx lima-name ec2-host]} @create-state]
    (cond
      (.-escape key)
      (swap! app-state assoc :view :list :error nil)

      (.-return key)
      (case step
        :branch
        (when (seq branch)
          (swap! create-state assoc :step :env))

        :env
        (case env
          :lima (swap! create-state assoc :step :lima-name)
          :ec2  (swap! create-state assoc :step :ec2-host)
          (swap! create-state assoc :step :confirm))

        :lima-name
        (when (seq lima-name)
          (swap! create-state assoc :step :confirm))

        :ec2-host
        (when (seq ec2-host)
          (swap! create-state assoc :step :confirm))

        :confirm
        (let [{:keys [branch env lima-name ec2-host]} @create-state
              new-agent {:id        (gen-id)
                         :branch    branch
                         :env       env
                         :lima-name (when (= env :lima) lima-name)
                         :ec2-host  (when (= env :ec2) ec2-host)
                         :status    :starting
                         :last-sync nil}]
          (swap! app-state (fn [s]
                             (-> s
                                 (update :agents conj new-agent)
                                 (assoc :view :list :error nil))))
          (reset! create-state {:step :branch :branch "" :env :local
                                :env-idx 0 :lima-name "dev" :ec2-host ""})
          (start-agent! new-agent))
        nil)

      ;; Env selection with ←→
      (and (= step :env) (.-leftArrow key))
      (let [i (mod (dec env-idx) (count envs))]
        (swap! create-state assoc :env (nth envs i) :env-idx i))

      (and (= step :env) (.-rightArrow key))
      (let [i (mod (inc env-idx) (count envs))]
        (swap! create-state assoc :env (nth envs i) :env-idx i))

      ;; Backspace
      (or (.-backspace key) (.-delete key))
      (case step
        :branch    (swap! create-state update :branch    #(subs % 0 (max 0 (dec (count %)))))
        :lima-name (swap! create-state update :lima-name #(subs % 0 (max 0 (dec (count %)))))
        :ec2-host  (swap! create-state update :ec2-host  #(subs % 0 (max 0 (dec (count %)))))
        nil)

      ;; Printable chars
      (and (seq input) (not (.-ctrl key)) (not (.-meta key)))
      (case step
        :branch    (swap! create-state update :branch    str input)
        :lima-name (swap! create-state update :lima-name str input)
        :ec2-host  (swap! create-state update :ec2-host  str input)
        nil))))

(defn handle-list-input [input key]
  (let [{:keys [agents selected]} @app-state
        total (count agents)]
    (cond
      (= input "q") (js/process.exit 0)

      (= input "n")
      (do (reset! create-state {:step :branch :branch "" :env :local
                                :env-idx 0 :lima-name "dev" :ec2-host ""})
          (swap! app-state assoc :view :create :error nil))

      (.-upArrow key)
      (swap! app-state update :selected #(max 0 (dec %)))

      (.-downArrow key)
      (when (pos? total)
        (swap! app-state update :selected #(min (dec total) (inc %))))

      (.-return key)
      (when (pos? total)
        (swap! app-state assoc :view :detail))

      (= input "a")
      (when-let [agent (nth agents selected nil)]
        (clear-error!)
        (attach-agent! agent))

      (= input "s")
      (when-let [agent (nth agents selected nil)]
        (clear-error!)
        (sync-agent! agent))

      (= input "d")
      (when-let [agent (nth agents selected nil)]
        (clear-error!)
        (delete-agent! agent)))))

(defn handle-detail-input [input key]
  (let [{:keys [agents selected]} @app-state
        agent (nth agents selected nil)]
    (cond
      (or (.-escape key) (= input "q"))
      (swap! app-state assoc :view :list)

      (and agent (= input "a"))
      (do (clear-error!) (attach-agent! agent))

      (and agent (= input "s"))
      (do (clear-error!) (sync-agent! agent))

      (and agent (= input "d"))
      (do (clear-error!)
          (delete-agent! agent)
          (swap! app-state assoc :view :list)))))

;; ── Root ──────────────────────────────────────────────────────────────────────

(defn Base []
  (let [stdout (.-stdout (ink/useStdout))
        rows   (.-rows stdout)
        cols   (.-columns stdout)
        _      (ink/useInput
                (fn [input key]
                  #_(js/console.log "Input:" input "Key:" key)
                  (case (:view @app-state)
                    :create (handle-create-input input key)
                    :detail (handle-detail-input input key)
                    (handle-list-input input key))))]
    [:f> App rows cols]))

(defn root []
  [:f> Base])

(defn run []
  (when-not (.-TMUX js/process.env)
    (js/console.error "Error: fleet must be run inside a tmux session")
    (js/process.exit 1))
  (.write js/process.stdout "\u001b[?1049h\u001b[2J\u001b[H")
  (ink/render (r/as-element [root])))
