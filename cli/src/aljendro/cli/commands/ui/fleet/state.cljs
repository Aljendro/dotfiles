(ns aljendro.cli.commands.ui.fleet.state
  (:require
   ["child_process" :as child-process]
   ["fs" :as fs]
   ["os" :as os]
   ["path" :as path]
   [reagent.core :as r]
   ;
   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; Runtime Constants ;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Initialized in fleet/run after tmux check
(defonce runtime
  (r/atom {:tmux-session      nil
           :tmux-session-root nil
           :worktree-base     nil}))

(defn tmux-session []      (:tmux-session @runtime))
(defn tmux-session-root [] (:tmux-session-root @runtime))
(defn worktree-base []     (:worktree-base @runtime))

(defn init-runtime! []
  (let [session (.trim (.toString (.execSync child-process "tmux display-message -p '#S'")))
        root    (.trim (.toString (.execSync child-process "tmux display-message -p '#{session_path}'")))
        wt-base (path/join root ".worktrees")]
    (reset! runtime {:tmux-session      session
                     :tmux-session-root root
                     :worktree-base     wt-base})))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;; App State ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defonce app-state
  (r/atom {:remotes  []
           :selected 0
           :view     :list   ; :list :create :detail :confirm-delete
           :error    nil
           :log      []}))

(defonce create-state
  (r/atom {:step            :branch  ; :branch :remote-type :remote-name :confirm
           :branch          ""
           :remote-type     :local
           :remote-type-idx 0
           :remote-name     "dev"}))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Persistence ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn- state-dir []
  (path/join (os/homedir) ".local" "state" "fleet"))

(defn- state-file []
  (path/join (state-dir) (str (tmux-session) ".json")))

(defn- safe-parse [s]
  (try (js->clj (js/JSON.parse s) :keywordize-keys true)
       (catch :default _ nil)))

(defn load-remotes! [create-remote]
  (let [f (state-file)]
    (when (.existsSync fs f)
      (when-let [data (safe-parse (.toString (.readFileSync fs f)))]
        (let [remotes (mapv create-remote (:remotes data))]
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

(defn init-persistence! [create-remote]
  (load-remotes! create-remote)
  (add-watch app-state ::persist
             (fn [_ _ old new]
               (when (not= (:remotes old) (:remotes new))
                 (save-remotes!)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; Shell Utilities ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn log! [msg]
  (swap! app-state update :log conj {:ts (.toISOString (js/Date.)) :msg msg}))

(defn set-error! [msg]
  (swap! app-state assoc :error msg))

(defn clear-error! []
  (swap! app-state assoc :error nil))

