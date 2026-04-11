(ns aljendro.cli.commands.ui.fleet.agent
  (:require [aljendro.cli.commands.ui.fleet.state :as state]
            [aljendro.cli.commands.ui.fleet.tmux :as tmux]
            [aljendro.cli.commands.ui.fleet.worktree :as worktree]
            [aljendro.cli.commands.ui.fleet.remote :as remote]))

(defn gen-id [] (str "a" (mod (.now js/Date) 99999)))

(defn update-agent! [id f]
  (swap! state/app-state update :agents (fn [agents] (mapv #(if (= (:id %) id) (f %) %) agents))))

(defn start-agent! [agent]
  (let [{:keys [id branch env lima-name ec2-host]} agent
        wt-path (worktree/worktree-path branch)]
    (-> (tmux/ensure-session!)
        (.then #(worktree/create-worktree! branch))
        (.then (fn [_]
                 (case env
                   :lima (remote/lima-start! lima-name wt-path)
                   :ec2  (remote/rsync-to-ec2! ec2-host branch)
                   (js/Promise.resolve nil))))
        (.then #(tmux/new-window! id))
        (.then (fn [_]
                 (case env
                   :local (tmux/send-keys! id (str "cd " wt-path))
                   :lima  (tmux/send-keys! id (str "kitten ssh lima-" lima-name))
                   :ec2   (tmux/send-keys! id (str "kitten ssh -t " ec2-host)))))
        (.then (fn [_]
                 (update-agent! id #(assoc % :status :running))
                 (state/log! (str "Started agent " id " [" branch "] on " (name env)))))
        (.catch (fn [err]
                  (update-agent! id #(assoc % :status :error))
                  (state/set-error! (str "Start failed: " err)))))))

(defn sync-agent! [agent]
  (let [{:keys [id env ec2-host branch]} agent]
    (case env
      :local nil
      :lima  (state/log! (remote/lima-sync-note))
      :ec2   (do
               (update-agent! id #(assoc % :status :syncing))
               (-> (remote/rsync-from-ec2! ec2-host branch)
                   (.then (fn [_]
                            (update-agent! id #(assoc % :status :running
                                                      :last-sync (.toISOString (js/Date.))))
                            (state/log! (str "Synced " id " from EC2"))))
                   (.catch (fn [err]
                             (update-agent! id #(assoc % :status :error))
                             (state/set-error! (str "Sync failed: " err)))))))))

(defn delete-agent! [agent]
  (let [{:keys [id branch env lima-name]} agent]
    (-> (tmux/kill-window! id)
        (.then (fn [_]
                 (when (= env :lima) (remote/lima-stop! lima-name))
                 (worktree/remove-worktree! branch)))
        (.then (fn [_]
                 (swap! state/app-state update :agents #(filterv (fn [a] (not= (:id a) id)) %))
                 (swap! state/app-state update :selected #(max 0 (dec %)))
                 (state/log! (str "Deleted agent " id))))
        (.catch (fn [err] (state/set-error! (str "Delete failed: " err)))))))

(defn attach-agent! [agent]
  (-> (tmux/switch-to-window! (:id agent))
      (.catch (fn [err] (state/set-error! (str "Attach failed: " err))))))
