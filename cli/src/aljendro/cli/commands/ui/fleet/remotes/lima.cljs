(ns aljendro.cli.commands.ui.fleet.remotes.lima
  (:require
   ["os" :as os]
   [aljendro.cli.commands.ui.fleet.common :as common]
   [aljendro.cli.commands.ui.fleet.protocols.remote :as protocols-remote]
   [aljendro.cli.commands.ui.fleet.remotes.common :as remotes-common]
   [aljendro.cli.commands.ui.fleet.tmux :as tmux]
   [aljendro.cli.commands.ui.fleet.worktree :as worktree]
   [clojure.string :as str]
   ;
   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;; Record ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrecord LimaRemote [id branch remote-type remote-name status last-sync]
  protocols-remote/Remote
  (start! [_this]
    (let [ca-certs (.. js/process -env -FLEET_LIMA_CA_CERTS)
          ca-flag  (when (seq ca-certs)
                     (str " --set '.caCerts.files += [\"" ca-certs "\"]'"))]
      (common/exec! (str "limactl start --name='" remote-name "' --mount-none"
                         ca-flag " -y template:fedora 2>/dev/null || true"))))
  (provision! [_this]
    (let [copy-dirs-files (.. js/process -env -FLEET_COPY_DIRS_FILES)
          home            (os/homedir)
          ssh-host        (str "lima-" remote-name)
          scp-cmds        (when (seq copy-dirs-files)
                            (->> (.split copy-dirs-files ":")
                                 (map (fn [p]
                                        (let [rel (.replace p (str home "/") "")]
                                          (str "ssh " ssh-host
                                               " 'mkdir -p $(dirname ~/" rel ")'"
                                               " && scp -r " (js/JSON.stringify p)
                                               " " ssh-host ":~/" rel))))
                                 (str/join " && ")))]
      (common/exec! (str (when scp-cmds (str scp-cmds " && "))
                         "ssh " ssh-host
                         " " remotes-common/dotfiles-install-command-str
                         " && limactl restart " remote-name))))
  (enter! [_this]
    (tmux/send-keys! id (str "kitten ssh lima-" remote-name)))
  (delete! [_this]
    (-> (common/exec! (str "limactl stop " remote-name " 2>/dev/null || true"))
        (.then #(common/exec! (str "limactl delete " remote-name " 2>/dev/null || true")))))
  (rsync-to! [_this]
    (remotes-common/rsync-push! (str "lima-" remote-name) (worktree/worktree-path branch)))
  (rsync-from! [_this]
    (remotes-common/rsync-pull! (str "lima-" remote-name) (worktree/worktree-path branch))))

