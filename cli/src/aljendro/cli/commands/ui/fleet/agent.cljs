(ns aljendro.cli.commands.ui.fleet.agent
  (:require [aljendro.cli.commands.ui.fleet.state :as state]
            [aljendro.cli.commands.ui.fleet.tmux :as tmux]
            [aljendro.cli.commands.ui.fleet.worktree :as worktree]
            [aljendro.cli.commands.ui.fleet.remote :as remote]))

(defn gen-id [] (str "a" (mod (.now js/Date) 99999)))

(defn update-remote! [id f]
  (swap! state/app-state update :remotes (fn [remotes] (mapv #(if (= (:id %) id) (f %) %) remotes))))

(defn start-remote! [remote]
  (let [{:keys [id branch remote-type lima-name digitalocean-name]} remote
        wt-path (worktree/worktree-path branch)]
    (-> (tmux/ensure-session!)
        (.then #(worktree/create-worktree! branch))
        (.then (fn [_]
                 (case remote-type
                   :lima (-> (remote/lima-start! lima-name wt-path)
                             (.then #(remote/rsync-to-lima! lima-name branch)))
                   :digitalocean (-> (remote/digitalocean-start! id digitalocean-name)
                                     (.then #(remote/rsync-to-digitalocean! digitalocean-name branch)))
                   nil)))
        (.then (fn [_]
                 (case remote-type
                   :lima  (remote/lima-provision! lima-name)
                   :digitalocean  (remote/digitalocean-provision! digitalocean-name)
                   nil)))
        (.then #(tmux/new-window! id))
        (.then (fn [_]
                 (case remote-type
                   :local        (tmux/send-keys! id (str "cd " wt-path))
                   :lima         (tmux/send-keys! id (str "kitten ssh lima-" lima-name))
                   :digitalocean (tmux/send-keys! id (str "kitten ssh -t " digitalocean-name))
                   nil)))
        (.then (fn [_]
                 (update-remote! id #(assoc % :status :running))
                 (state/log! (str "Started remote " id " [" branch "] on " (name remote-type)))))
        (.catch (fn [err]
                  (update-remote! id #(assoc % :status :error))
                  (state/set-error! (str "Start failed: " err)))))))

(defn push-remote! [remote]
  (let [{:keys [id remote-type lima-name digitalocean-name branch]} remote
        push-fn (case remote-type
                  :lima         #(remote/rsync-to-lima! lima-name branch)
                  :digitalocean #(remote/rsync-to-digitalocean! digitalocean-name branch)
                  nil)]
    (when push-fn
      (update-remote! id #(assoc % :status :pushing))
      (-> (push-fn)
          (.then (fn [_]
                   (update-remote! id #(assoc % :status :running
                                              :last-sync (.toISOString (js/Date.))))
                   (state/log! (str "Pushed " id " to " (name remote-type)))))
          (.catch (fn [err]
                    (update-remote! id #(assoc % :status :error))
                    (state/set-error! (str "Push failed: " err))))))))

(defn pull-remote! [remote]
  (let [{:keys [id remote-type lima-name digitalocean-name branch]} remote
        pull-fn (case remote-type
                  :lima         #(remote/rsync-from-lima! lima-name branch)
                  :digitalocean #(remote/rsync-from-digitalocean! digitalocean-name branch)
                  nil)]
    (when pull-fn
      (update-remote! id #(assoc % :status :pulling))
      (-> (pull-fn)
          (.then (fn [_]
                   (update-remote! id #(assoc % :status :running
                                              :last-sync (.toISOString (js/Date.))))
                   (state/log! (str "Pulled " id " from " (name remote-type)))))
          (.catch (fn [err]
                    (update-remote! id #(assoc % :status :error))
                    (state/set-error! (str "Pull failed: " err))))))))

(defn delete-remote! [remote]
  (let [{:keys [id remote-type lima-name digitalocean-name]} remote]
    (-> (tmux/kill-window! id)
        (.then (fn [_]
                 (case remote-type
                   :lima         (remote/lima-delete! lima-name)
                   :digitalocean (do (remote/delete-ssh-config! id)
                                     (remote/digitalocean-delete! digitalocean-name))
                   nil)))
        (.then (fn [_]
                 (swap! state/app-state update :remotes #(filterv (fn [a] (not= (:id a) id)) %))
                 (swap! state/app-state update :selected #(max 0 (dec %)))
                 (state/log! (str "Deleted remote " id))))
        (.catch (fn [err] (state/set-error! (str "Delete failed: " err)))))))

(defn attach-remote! [remote]
  (-> (tmux/switch-to-window! (:id remote))
      (.catch (fn [err] (state/set-error! (str "Attach failed: " err))))))
