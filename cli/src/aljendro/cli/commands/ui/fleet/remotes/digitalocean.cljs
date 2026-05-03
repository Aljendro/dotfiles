(ns aljendro.cli.commands.ui.fleet.remotes.digitalocean
  (:require
   ["fs" :as fs]
   ["os" :as os]
   ["path" :as path]
   [aljendro.cli.commands.ui.fleet.common :as common]
   [aljendro.cli.commands.ui.fleet.protocols.remote :as protocols-remote]
   [aljendro.cli.commands.ui.fleet.remotes.common :as remotes-common]
   [aljendro.cli.commands.ui.fleet.tmux :as tmux]
   [aljendro.cli.commands.ui.fleet.worktree :as worktree]
   ;
   ))

(declare write-ssh-config! delete-ssh-config!)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;; Record ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrecord DigitalOceanRemote [id branch remote-type remote-name status last-sync]
  protocols-remote/Remote
  (start! [_this]
    (let [droplet-id (atom nil)
          droplet-ipv4 (atom nil)]
      (-> (common/exec!
           (str "doctl compute droplet create " (js/JSON.stringify remote-name)
                " --image fedora-43-x64"
                " --size s-2vcpu-4gb"
                " --region sfo3"
                " --ssh-keys \"$(doctl compute ssh-key list --no-header | grep \"ephemeral\" | cut -d \" \" -f1)\""
                " --user-data-file \"" (.-DOTFILES_DIR js/process.env) "/files/digitalocean/setup\""
                " --wait"
                " --format ID,PublicIPv4"
                " --no-header"))
          (.then (fn [out]
                   (let [[id-str ipv4] (-> out .trim (.split #"\s+"))]
                     (reset! droplet-id id-str)
                     (reset! droplet-ipv4 ipv4))))
          (.then #(write-ssh-config! id remote-name @droplet-ipv4 "root"))
          (.then #(common/exec! (str "ssh " remote-name " " (js/JSON.stringify "cloud-init status --wait")
                                     " && doctl compute droplet-action reboot " @droplet-id " --wait")
                                {:retries  1
                                 :delay-ms 1000})))))
  (provision! [_this]
    (-> (common/exec! (str "ssh " remote-name " " remotes-common/dotfiles-install-command-str))
        (.then #(common/exec! (str "doctl compute droplet get " remote-name " --format ID --no-header")))
        (.then #(common/exec! (str "doctl compute droplet-action reboot " (.trim %) " --wait")))))
  (enter! [_this]
    (tmux/send-keys! id (str "kitten ssh -t " remote-name)))
  (delete! [_this]
    (delete-ssh-config! id)
    (common/exec!
     (str "doctl compute droplet delete " (js/JSON.stringify remote-name)
          " --force"
          " 2>/dev/null || true")))
  (rsync-to! [_this]
    (remotes-common/rsync-push! remote-name (worktree/worktree-path branch)))
  (rsync-from! [_this]
    (remotes-common/rsync-pull! remote-name (worktree/worktree-path branch))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Utilities ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn- fleet-dir [remote-id]
  (path/join (os/homedir) ".fleet" remote-id))

(defn- ssh-config-path [remote-id]
  (path/join (fleet-dir remote-id) "ssh.config"))

(defn write-ssh-config! [remote-id host-alias hostname user]
  (let [dir     (fleet-dir remote-id)
        key     (path/join (os/homedir) ".ssh" "ephemeral")
        entry   (str "Host " host-alias "\n"
                     "  HostName " hostname "\n"
                     "  User " user "\n"
                     "  IdentityFile " key "\n"
                     "  IdentitiesOnly yes\n"
                     "  StrictHostKeyChecking accept-new\n"
                     "  UserKnownHostsFile " (path/join dir "known_hosts") "\n")]
    (.mkdirSync fs dir #js {:recursive true})
    (.writeFileSync fs (ssh-config-path remote-id) entry)))

(defn delete-ssh-config! [remote-id]
  (let [dir (fleet-dir remote-id)]
    (when (.existsSync fs dir)
      (.rmSync fs dir #js {:recursive true :force true}))))

