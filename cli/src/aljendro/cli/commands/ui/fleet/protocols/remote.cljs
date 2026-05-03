(ns aljendro.cli.commands.ui.fleet.protocols.remote)

(defprotocol Remote
  "The actions that can be taken on a Remotes"
  (start! [this])
  (provision! [this])
  (enter! [this])
  (delete! [this])
  (rsync-to! [this])
  (rsync-from! [this]))
