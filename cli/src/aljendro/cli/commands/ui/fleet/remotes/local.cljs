(ns aljendro.cli.commands.ui.fleet.remotes.local
  (:require
   [aljendro.cli.commands.ui.fleet.protocols.remote :as protocols-remote]
   [aljendro.cli.commands.ui.fleet.tmux :as tmux]
   [aljendro.cli.commands.ui.fleet.worktree :as worktree]
   ;
   ))

(defrecord LocalRemote [id branch remote-type remote-name status last-sync]
  protocols-remote/Remote
  (start!         [_this] (js/Promise.resolve))
  (provision!     [_this] (js/Promise.resolve))
  (enter!         [_this] (tmux/send-keys! id (str "cd " (worktree/worktree-path branch))))
  (delete!        [_this] (js/Promise.resolve))
  (rsync-to!      [_this] (js/Promise.resolve))
  (rsync-from!    [_this] (js/Promise.resolve)))


