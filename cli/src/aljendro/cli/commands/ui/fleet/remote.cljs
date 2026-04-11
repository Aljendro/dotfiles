(ns aljendro.cli.commands.ui.fleet.remote
  (:require ["path" :as path]
            [aljendro.cli.commands.ui.fleet.state :as state]
            [aljendro.cli.commands.ui.fleet.worktree :as worktree]))

;; ── rsync helpers ────────────────────────────────────────────────────────────

(defn- rsync-push! [ssh-host wt-path]
  (state/exec! (str "ssh " (js/JSON.stringify ssh-host)
                    " " (js/JSON.stringify
                         (str "sudo mkdir -p " wt-path
                              " && sudo chown -R \"$USER\" " (path/dirname wt-path)))
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

(defn lima-stop! [vm-name]
  (state/exec! (str "limactl stop " vm-name " 2>/dev/null || true")))

(defn lima-provision! [vm-name]
  (state/exec! (str "ssh lima-" vm-name
                    " " (js/JSON.stringify "cd ~/dotfiles && ansible-playbook install.yml")
                    " && limactl restart " vm-name)))

(defn rsync-to-lima! [vm-name branch]
  (rsync-push! (str "lima-" vm-name) (worktree/worktree-path branch)))

(defn rsync-from-lima! [vm-name branch]
  (rsync-pull! (str "lima-" vm-name) (worktree/worktree-path branch)))

;; ── EC2 ──────────────────────────────────────────────────────────────────────

(defn rsync-to-ec2! [ec2-host branch]
  (rsync-push! ec2-host (worktree/worktree-path branch)))

(defn rsync-from-ec2! [ec2-host branch]
  (rsync-pull! ec2-host (worktree/worktree-path branch)))

;; ── DigitalOcean ─────────────────────────────────────────────────────────────

(defn digitalocean-create! [droplet-name]
  ;; Creates a droplet and returns its public IP once active.
  ;; Uses the first registered SSH key and sensible defaults.
  (state/exec!
   (str "doctl compute droplet create " (js/JSON.stringify droplet-name)
        " --image fedora-43-x64"
        " --size s-2vcpu-4gb"
        " --region sfo3"
        " --ssh-keys \"$(doctl compute ssh-key list --format ID --no-header | head -1)\""
        " --enable-ipv6"
        " --wait"
        " --format PublicIPv6"
        " --no-header")))

(defn digitalocean-delete! [droplet-name]
  (state/exec!
   (str "doctl compute droplet delete " (js/JSON.stringify droplet-name)
        " --force"
        " 2>/dev/null || true")))

(defn rsync-to-digitalocean! [digitalocean-host branch]
  (rsync-push! digitalocean-host (worktree/worktree-path branch)))

(defn rsync-from-digitalocean! [digitalocean-host branch]
  (rsync-pull! digitalocean-host (worktree/worktree-path branch)))
