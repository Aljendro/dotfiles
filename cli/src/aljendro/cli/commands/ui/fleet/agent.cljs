(ns aljendro.cli.commands.ui.fleet.agent
  (:require [aljendro.cli.commands.ui.fleet.state :as state]
            [aljendro.cli.commands.ui.fleet.tmux :as tmux]
            [aljendro.cli.commands.ui.fleet.worktree :as worktree]
            [aljendro.cli.commands.ui.fleet.remote :as remote]))

(defn gen-id [] (str "a" (mod (.now js/Date) 99999)))

(defn update-agent! [id f]
  (swap! state/app-state update :agents (fn [agents] (mapv #(if (= (:id %) id) (f %) %) agents))))

(defn start-agent! [agent]
  (let [{:keys [id branch env lima-name ec2-host digitalocean-name]} agent
        wt-path (worktree/worktree-path branch)]
    (-> (tmux/ensure-session!)
        (.then #(worktree/create-worktree! branch))
        (.then (fn [_]
                 (case env
                   :lima (-> (remote/lima-start! lima-name wt-path)
                             (.then #(remote/rsync-to-lima! lima-name branch)))
                   :ec2 (remote/rsync-to-ec2! ec2-host branch)
                   :digitalocean (-> (remote/digitalocean-start! id digitalocean-name)
                                     (.then #(remote/rsync-to-digitalocean! digitalocean-name branch)))
                   nil)))
        (.then (fn [_]
                 (case env
                   :lima  (remote/lima-provision! lima-name)
                   :digitalocean  (remote/digitalocean-provision! digitalocean-name)
                   nil)))
        (.then #(tmux/new-window! id))
        (.then (fn [_]
                 (case env
                   :local        (tmux/send-keys! id (str "cd " wt-path))
                   :lima         (tmux/send-keys! id (str "kitten ssh lima-" lima-name))
                   :ec2          (tmux/send-keys! id (str "kitten ssh -t " ec2-host))
                   :digitalocean (tmux/send-keys! id (str "kitten ssh -t " digitalocean-name))
                   nil)))
        (.then (fn [_]
                 (update-agent! id #(assoc % :status :running))
                 (state/log! (str "Started agent " id " [" branch "] on " (name env)))))
        (.catch (fn [err]
                  (update-agent! id #(assoc % :status :error))
                  (state/set-error! (str "Start failed: " err)))))))

(defn push-agent! [agent]
  (let [{:keys [id env ec2-host lima-name digitalocean-name branch]} agent
        push-fn (case env
                  :lima         #(remote/rsync-to-lima! lima-name branch)
                  :ec2          #(remote/rsync-to-ec2! ec2-host branch)
                  :digitalocean #(remote/rsync-to-digitalocean! digitalocean-name branch)
                  nil)]
    (when push-fn
      (update-agent! id #(assoc % :status :pushing))
      (-> (push-fn)
          (.then (fn [_]
                   (update-agent! id #(assoc % :status :running
                                             :last-sync (.toISOString (js/Date.))))
                   (state/log! (str "Pushed " id " to " (name env)))))
          (.catch (fn [err]
                    (update-agent! id #(assoc % :status :error))
                    (state/set-error! (str "Push failed: " err))))))))

(defn pull-agent! [agent]
  (let [{:keys [id env ec2-host lima-name digitalocean-name branch]} agent
        pull-fn (case env
                  :lima         #(remote/rsync-from-lima! lima-name branch)
                  :ec2          #(remote/rsync-from-ec2! ec2-host branch)
                  :digitalocean #(remote/rsync-from-digitalocean! digitalocean-name branch)
                  nil)]
    (when pull-fn
      (update-agent! id #(assoc % :status :pulling))
      (-> (pull-fn)
          (.then (fn [_]
                   (update-agent! id #(assoc % :status :running
                                             :last-sync (.toISOString (js/Date.))))
                   (state/log! (str "Pulled " id " from " (name env)))))
          (.catch (fn [err]
                    (update-agent! id #(assoc % :status :error))
                    (state/set-error! (str "Pull failed: " err))))))))

(defn delete-agent! [agent]
  (let [{:keys [id env lima-name digitalocean-name]} agent]
    (-> (tmux/kill-window! id)
        (.then (fn [_]
                 (case env
                   :lima         (remote/lima-delete! lima-name)
                   :digitalocean (do (remote/delete-ssh-config! id)
                                     (remote/digitalocean-delete! digitalocean-name))
                   nil)))
        (.then (fn [_]
                 (swap! state/app-state update :agents #(filterv (fn [a] (not= (:id a) id)) %))
                 (swap! state/app-state update :selected #(max 0 (dec %)))
                 (state/log! (str "Deleted agent " id))))
        (.catch (fn [err] (state/set-error! (str "Delete failed: " err)))))))

(defn attach-agent! [agent]
  (-> (tmux/switch-to-window! (:id agent))
      (.catch (fn [err] (state/set-error! (str "Attach failed: " err))))))
