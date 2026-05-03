(ns aljendro.cli.commands.ui.fleet.remotes.common
  (:require
   ["path" :as path]
   [aljendro.cli.commands.ui.fleet.common :as common]
   ;
   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;; Rsync Helpers  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn rsync-push! [ssh-host wt-path]
  (common/exec!
   (str "ssh " (js/JSON.stringify ssh-host)
        " '" "sudo mkdir -p " wt-path
        " && sudo chown -R $USER " (path/dirname wt-path) "'"
        " && rsync -avz --delete --exclude='.git' "
        (js/JSON.stringify (str wt-path "/"))
        " " (js/JSON.stringify ssh-host) ":" (js/JSON.stringify (str wt-path "/")))
   {:retries 2 :delay-ms 5000}))

(defn rsync-pull! [ssh-host wt-path]
  (common/exec!
   (str "rsync -avz --delete --exclude='.git' "
        (js/JSON.stringify ssh-host) ":" (js/JSON.stringify (str wt-path "/"))
        " " (js/JSON.stringify (str wt-path "/")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;; Misc. Helpers ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def dotfiles-install-command-str
  (js/JSON.stringify
   (str "cd ~ && git clone https://github.com/aljendro/dotfiles-vm.git dotfiles && "
        "cd ~/dotfiles && ansible-playbook install.yml")))

