(ns aljendro.cli.commands.ui.fleet.state
  (:require ["child_process" :as cp]
            ["fs" :as fs]
            ["os" :as os]
            ["path" :as path]
            ["util" :as util]
            [reagent.core :as r]))

(def exec-promise (.promisify util (.-exec cp)))

;; ── Runtime Constants ────────────────────────────────────────────────────────

;; Initialized in fleet/run after tmux check
(defonce runtime
  (r/atom {:tmux-session      nil
           :tmux-session-root nil
           :worktree-base     nil}))

(defn tmux-session []      (:tmux-session @runtime))
(defn tmux-session-root [] (:tmux-session-root @runtime))
(defn worktree-base []     (:worktree-base @runtime))

(defn init-runtime! []
  (let [session (.trim (.toString (.execSync cp "tmux display-message -p '#S'")))
        root    (.trim (.toString (.execSync cp "tmux display-message -p '#{session_path}'")))
        wt-base (path/join root ".worktrees")]
    (reset! runtime {:tmux-session      session
                     :tmux-session-root root
                     :worktree-base     wt-base})))

;; ── App State ────────────────────────────────────────────────────────────────

(defonce app-state
  (r/atom {:remotes  []
           :selected 0
           :view     :list   ; :list :create :detail :confirm-delete
           :error    nil
           :log      []}))

(defonce create-state
  (r/atom {:step              :branch  ; :branch :remote-type :lima-name :digitalocean-name :confirm
           :branch            ""
           :remote-type       :local
           :remote-type-idx   0
           :lima-name         "dev"
           :digitalocean-name "dev"}))

;; ── Persistence ──────────────────────────────────────────────────────────────

(defn- state-dir []
  (path/join (os/homedir) ".local" "state" "fleet"))

(defn- state-file []
  (path/join (state-dir) (str (tmux-session) ".json")))

(defn- safe-parse [s]
  (try (js->clj (js/JSON.parse s) :keywordize-keys true)
       (catch :default _ nil)))

(defn- coerce-remote [a]
  (-> a
      (update :remote-type keyword)
      (update :status (fn [s] (if (keyword? s) s (keyword (or s "stopped")))))))

(defn load-remotes! []
  (let [f (state-file)]
    (when (.existsSync fs f)
      (when-let [data (safe-parse (.toString (.readFileSync fs f)))]
        (let [remotes (mapv coerce-remote (:remotes data))]
          (swap! app-state assoc :remotes remotes))))))

(defn save-remotes! []
  (try
    (let [dir (state-dir)]
      (when-not (.existsSync fs dir)
        (.mkdirSync fs dir #js {:recursive true}))
      (.writeFileSync fs (state-file)
                      (js/JSON.stringify
                       (clj->js {:remotes (:remotes @app-state)})
                       nil 2)))
    (catch :default _ nil)))

(defn init-persistence! []
  (load-remotes!)
  (add-watch app-state ::persist
             (fn [_ _ old new]
               (when (not= (:remotes old) (:remotes new))
                 (save-remotes!)))))

;; ── Shell Utilities ──────────────────────────────────────────────────────────

(defn- sleep [ms]
  (js/Promise. (fn [resolve] (js/setTimeout resolve ms))))

(defn exec!
  ([cmd] (exec! cmd nil))
  ([cmd {:keys [retries delay-ms on-retry]
         :or   {retries 0 delay-ms 0}}]
   (-> (exec-promise cmd)
       (.then #(.trim (str (.-stdout %))))
       (.catch (fn [err]
                 (if (pos? retries)
                   (do
                     (when on-retry (on-retry err retries))
                     (-> (sleep delay-ms)
                         (.then #(exec! cmd {:retries  (dec retries)
                                             :delay-ms delay-ms
                                             :on-retry on-retry}))))
                   (js/Promise.reject
                    (str (or (.-message err) "") " "
                         (or (.-stderr err) "")))))))))

(defn log! [msg]
  (swap! app-state update :log conj {:ts (.toISOString (js/Date.)) :msg msg}))

(defn set-error! [msg]
  (swap! app-state assoc :error msg))

(defn clear-error! []
  (swap! app-state assoc :error nil))
