(ns aljendro.cli.commands.ui.fleet.remote
  (:require [aljendro.cli.commands.ui.fleet.state :as state]
            [aljendro.cli.commands.ui.fleet.worktree :as worktree]))

;; ── Lima ─────────────────────────────────────────────────────────────────────

(defn lima-start! [vm-name wt-path]
  ;; Mount main repo read-only (so git can resolve the .git dir from the worktree's .git file)
  ;; and the worktree itself writeable.
  (let [mounts   (str (state/tmux-session-root) "," wt-path ":w")
        ca-certs (.. js/process -env -FLEET_LIMA_CA_CERTS)
        ca-flag  (when (seq ca-certs)
                   (str " --set '.caCerts.files += [\"" ca-certs "\"]'"))]
    (-> (state/exec! (str "limactl start --name='" vm-name "' --mount-only='" mounts "'"
                          ca-flag " -y template:fedora 2>/dev/null || true"))
        (.then #(state/exec! (str "limactl restart " vm-name))))))

(defn lima-stop! [vm-name]
  (state/exec! (str "limactl stop " vm-name " 2>/dev/null || true")))

;; Lima mounts only the worktree directory (.:w), so changes in the VM are
;; immediately visible on the host at the same path — no rsync needed.
(defn lima-sync-note [] "Lima mounts the worktree dir — changes are immediately visible locally.")

;; ── EC2 ──────────────────────────────────────────────────────────────────────

(defn rsync-to-ec2! [ec2-host branch]
  (let [wt-path (worktree/worktree-path branch)]
    (state/exec! (str "rsync -avz --delete --exclude='.git' "
                      (js/JSON.stringify (str wt-path "/"))
                      " " (js/JSON.stringify ec2-host) ":" (js/JSON.stringify (str wt-path "/"))))))

(defn rsync-from-ec2! [ec2-host branch]
  (let [wt-path (worktree/worktree-path branch)]
    (state/exec! (str "rsync -avz --delete --exclude='.git' "
                      (js/JSON.stringify ec2-host) ":" (js/JSON.stringify (str wt-path "/"))
                      " " (js/JSON.stringify (str wt-path "/"))))))
