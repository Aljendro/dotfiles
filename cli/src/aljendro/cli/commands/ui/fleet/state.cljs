(ns aljendro.cli.commands.ui.fleet.state
  (:require ["child_process" :as cp]
            ["fs" :as fs]
            ["os" :as os]
            ["path" :as path]
            [reagent.core :as r]))

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
        wt-base (path/join (path/dirname root) ".worktrees" (path/basename root))]
    (reset! runtime {:tmux-session      session
                     :tmux-session-root root
                     :worktree-base     wt-base})))

;; ── App State ────────────────────────────────────────────────────────────────

(defonce app-state
  (r/atom {:agents   []
           :selected 0
           :view     :list   ; :list :create :detail :confirm-delete
           :error    nil
           :log      []}))

(defonce create-state
  (r/atom {:step             :branch  ; :branch :env :lima-name :digitalocean-name :confirm
           :branch           ""
           :env              :local
           :env-idx          0
           :lima-name        "dev"
           :digitalocean-name "fleet-agent"}))

;; ── Persistence ──────────────────────────────────────────────────────────────

(defn- state-dir []
  (path/join (os/homedir) ".local" "state" "fleet"))

(defn- state-file []
  (path/join (state-dir) (str (tmux-session) ".json")))

(defn- safe-parse [s]
  (try (js->clj (js/JSON.parse s) :keywordize-keys true)
       (catch :default _ nil)))

(defn- coerce-agent [a]
  (-> a
      (update :env keyword)
      (update :status (fn [s] (if (keyword? s) s (keyword (or s "stopped")))))))

(defn load-agents! []
  (let [f (state-file)]
    (when (.existsSync fs f)
      (when-let [data (safe-parse (.toString (.readFileSync fs f)))]
        (let [agents (mapv coerce-agent (:agents data))]
          (swap! app-state assoc :agents agents))))))

(defn save-agents! []
  (try
    (let [dir (state-dir)]
      (when-not (.existsSync fs dir)
        (.mkdirSync fs dir #js {:recursive true}))
      (.writeFileSync fs (state-file)
                      (js/JSON.stringify
                       (clj->js {:agents (:agents @app-state)})
                       nil 2)))
    (catch :default _ nil)))

(defn init-persistence! []
  (load-agents!)
  (add-watch app-state ::persist
             (fn [_ _ old new]
               (when (not= (:agents old) (:agents new))
                 (save-agents!)))))

;; ── Shell Utilities ──────────────────────────────────────────────────────────

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
