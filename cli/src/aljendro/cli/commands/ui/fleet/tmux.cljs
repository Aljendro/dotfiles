(ns aljendro.cli.commands.ui.fleet.tmux
  (:require
   [aljendro.cli.commands.ui.fleet.common :as common]
   [aljendro.cli.commands.ui.fleet.state :as state]
   ;
   ))

(defn ensure-session! []
  (common/exec! (str "tmux has-session -t " (state/tmux-session)
                     " 2>/dev/null || tmux new-session -d -s " (state/tmux-session))))

(defn new-window! [window-name]
  (common/exec! (str "tmux new-window -t " (state/tmux-session) " -n " (js/JSON.stringify window-name))))

(defn send-keys! [window-name cmd]
  (common/exec! (str "tmux send-keys -t " (state/tmux-session) ":" (js/JSON.stringify window-name)
                     " " (js/JSON.stringify cmd) " Enter")))

(defn kill-window! [window-name]
  (common/exec! (str "tmux kill-window -t " (state/tmux-session) ":" (js/JSON.stringify window-name)
                     " 2>/dev/null || true")))

;; switch-client works inside tmux; fall back to attach for non-tmux terminals
(defn switch-to-window! [window-name]
  (common/exec! (str "tmux switch-client -t " (state/tmux-session) ":" (js/JSON.stringify window-name)
                     " 2>/dev/null || tmux attach-session -t " (state/tmux-session)
                     " -t " (js/JSON.stringify window-name))))
