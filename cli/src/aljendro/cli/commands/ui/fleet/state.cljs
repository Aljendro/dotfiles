(ns aljendro.cli.commands.ui.fleet.state
  (:require ["child_process" :as cp]
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
  (r/atom {:step      :branch  ; :branch :env :lima-name :ec2-host :confirm
           :branch    ""
           :env       :local
           :env-idx   0
           :lima-name "dev"
           :ec2-host  ""}))

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
