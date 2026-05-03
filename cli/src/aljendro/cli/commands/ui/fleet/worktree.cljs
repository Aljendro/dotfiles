(ns aljendro.cli.commands.ui.fleet.worktree
  (:require
   ["path" :as path]
   [aljendro.cli.commands.ui.fleet.common :as common]
   [aljendro.cli.commands.ui.fleet.state :as state]
   ;
   ))

(defn worktree-path [branch]
  (path/join (state/worktree-base) (.replaceAll branch "/" "-")))

(defn create-worktree! [branch]
  (let [wt-path (worktree-path branch)]
    (common/exec! (str "mkdir -p " (js/JSON.stringify (state/worktree-base))
                       " && cd " (js/JSON.stringify (state/tmux-session-root))
                       " && (git worktree add " (js/JSON.stringify wt-path)
                       " " (js/JSON.stringify branch)
                       " 2>/dev/null || git worktree add -b " (js/JSON.stringify branch)
                       " " (js/JSON.stringify wt-path) " HEAD)"))))

(defn remove-worktree! [branch]
  (common/exec! (str "cd " (js/JSON.stringify (state/tmux-session-root))
                     " && git worktree remove --force "
                     (js/JSON.stringify (worktree-path branch)) " 2>/dev/null || true")))
