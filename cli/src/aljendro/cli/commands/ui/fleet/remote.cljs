(ns aljendro.cli.commands.ui.fleet.remote
  (:require ["fs" :as fs]
            ["os" :as os]
            ["path" :as path]
            [clojure.string :as str]
            [aljendro.cli.commands.ui.fleet.state :as state]
            [aljendro.cli.commands.ui.fleet.worktree :as worktree]))

(def dotfiles-install-str
  (js/JSON.stringify
   (str "cd ~ && git clone https://github.com/aljendro/dotfiles-vm.git dotfiles && "
        "cd ~/dotfiles && ansible-playbook install.yml")))

;; ── SSH config helpers ───────────────────────────────────────────────────────
;; The user's ~/.ssh/config includes `Include ~/.fleet/*/ssh.config`, so each
;; agent gets its own directory under ~/.fleet with a single ssh.config entry
;; pointing at the ephemeral key.

(defn- fleet-dir [agent-id]
  (path/join (os/homedir) ".fleet" agent-id))

(defn- ssh-config-path [agent-id]
  (path/join (fleet-dir agent-id) "ssh.config"))

(defn write-ssh-config! [agent-id host-alias hostname user]
  (let [dir     (fleet-dir agent-id)
        key     (path/join (os/homedir) ".ssh" "ephemeral")
        entry   (str "Host " host-alias "\n"
                     "  HostName " hostname "\n"
                     "  User " user "\n"
                     "  IdentityFile " key "\n"
                     "  IdentitiesOnly yes\n"
                     "  StrictHostKeyChecking accept-new\n"
                     "  UserKnownHostsFile " (path/join dir "known_hosts") "\n")]
    (.mkdirSync fs dir #js {:recursive true})
    (.writeFileSync fs (ssh-config-path agent-id) entry)))

(defn delete-ssh-config! [agent-id]
  (let [dir (fleet-dir agent-id)]
    (when (.existsSync fs dir)
      (.rmSync fs dir #js {:recursive true :force true}))))

;; ── rsync helpers ────────────────────────────────────────────────────────────

(defn- rsync-push! [ssh-host wt-path]
  (state/exec! (str "ssh " (js/JSON.stringify ssh-host)
                    " '" "sudo mkdir -p " wt-path
                    " && sudo chown -R $USER " (path/dirname wt-path) "'"
                    " && rsync -avz --delete --exclude='.git' "
                    (js/JSON.stringify (str wt-path "/"))
                    " " (js/JSON.stringify ssh-host) ":" (js/JSON.stringify (str wt-path "/")))))

(defn- rsync-pull! [ssh-host wt-path]
  (state/exec! (str "rsync -avz --delete --exclude='.git' "
                    (js/JSON.stringify ssh-host) ":" (js/JSON.stringify (str wt-path "/"))
                    " " (js/JSON.stringify (str wt-path "/")))))

;; ── Lima ─────────────────────────────────────────────────────────────────────

(defn lima-start! [vm-name _wt-path]
  ;; Boot the VM without mounting any host directories — we rsync changes instead.
  (let [ca-certs (.. js/process -env -FLEET_LIMA_CA_CERTS)
        ca-flag  (when (seq ca-certs)
                   (str " --set '.caCerts.files += [\"" ca-certs "\"]'"))]
    (state/exec! (str "limactl start --name='" vm-name "' --mount-none"
                      ca-flag " -y template:fedora 2>/dev/null || true"))))

(defn lima-provision! [vm-name]
  (let [copy-dirs-files (.. js/process -env -FLEET_COPY_DIRS_FILES)
        home            (os/homedir)
        ssh-host        (str "lima-" vm-name)
        scp-cmds        (when (seq copy-dirs-files)
                          (->> (.split copy-dirs-files ":")
                               (map (fn [p]
                                      (let [rel (.replace p (str home "/") "")]
                                        (str "ssh " ssh-host
                                             " 'mkdir -p $(dirname ~/" rel ")'"
                                             " && scp -r " (js/JSON.stringify p)
                                             " " ssh-host ":~/" rel))))
                               (str/join " && ")))]
    (state/exec! (str (when scp-cmds (str scp-cmds " && "))
                      "ssh " ssh-host
                      " " dotfiles-install-str
                      " && limactl restart " vm-name))))

(defn lima-delete! [vm-name]
  (-> (state/exec! (str "limactl stop " vm-name " 2>/dev/null || true"))
      (.then #(state/exec! (str "limactl delete " vm-name " 2>/dev/null || true")))))

(defn rsync-to-lima! [vm-name branch]
  (rsync-push! (str "lima-" vm-name) (worktree/worktree-path branch)))

(defn rsync-from-lima! [vm-name branch]
  (rsync-pull! (str "lima-" vm-name) (worktree/worktree-path branch)))

;; ── DigitalOcean ─────────────────────────────────────────────────────────────

(defn digitalocean-start! [agent-id droplet-name]
  ;; Creates a droplet and returns its public IP once active.
  ;; Uses the first registered SSH key and sensible defaults.
  (let [droplet-id (atom nil)
        droplet-ipv4 (atom nil)]
    (-> (state/exec!
         (str "doctl compute droplet create " (js/JSON.stringify droplet-name)
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
        (.then #(write-ssh-config! agent-id droplet-name @droplet-ipv4 "root"))
        (.then #(state/exec! (str "ssh " droplet-name " " (js/JSON.stringify "cloud-init status --wait")
                                  " && doctl compute droplet-action reboot " @droplet-id " --wait"))))))

(defn digitalocean-provision! [droplet-name]
  (-> (state/exec! (str "ssh " droplet-name " " dotfiles-install-str))
      (.then #(state/exec! (str "doctl compute droplet get " droplet-name " --format ID --no-header")))
      (.then #(state/exec! (str "doctl compute droplet-action reboot " (.trim %) " --wait")))))

(defn digitalocean-delete! [droplet-name]
  (state/exec!
   (str "doctl compute droplet delete " (js/JSON.stringify droplet-name)
        " --force"
        " 2>/dev/null || true")))

(defn rsync-to-digitalocean! [digitalocean-name branch]
  (rsync-push! digitalocean-name (worktree/worktree-path branch)))

(defn rsync-from-digitalocean! [digitalocean-name branch]
  (rsync-pull! digitalocean-name (worktree/worktree-path branch)))
