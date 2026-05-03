(ns aljendro.cli.commands.ui.fleet.remote
  (:require
   [aljendro.cli.commands.ui.fleet.protocols.remote :as protocols-remote]
   [aljendro.cli.commands.ui.fleet.remotes.digitalocean :as remotes-digitalocean]
   [aljendro.cli.commands.ui.fleet.remotes.lima :as remotes-lima]
   [aljendro.cli.commands.ui.fleet.remotes.local :as remotes-local]
   [aljendro.cli.commands.ui.fleet.state :as state]
   [aljendro.cli.commands.ui.fleet.tmux :as tmux]
   [aljendro.cli.commands.ui.fleet.worktree :as worktree]
   ;
   ))

(defn create-remote [remote-map]
  (let [{:keys [id branch remote-type remote-name status last-sync]} remote-map
        remote-type (keyword remote-type)
        status (if (keyword? status) status (keyword (or status "stopped")))]
    (case remote-type
      :local        (remotes-local/->LocalRemote id branch remote-type remote-name status last-sync)
      :lima         (remotes-lima/->LimaRemote id branch remote-type remote-name status last-sync)
      :digitalocean (remotes-digitalocean/->DigitalOceanRemote id branch remote-type remote-name status last-sync)
      nil)))

(defn gen-id [] (str "a" (mod (.now js/Date) 99999)))

(defn update-remote! [id f]
  (swap! state/app-state update :remotes (fn [remotes] (mapv #(if (= (:id %) id) (f %) %) remotes))))

(defn start-remote! [remote]
  (-> (tmux/ensure-session!)
      (.then #(worktree/create-worktree! (:branch remote)))
      (.then #(protocols-remote/start! remote))
      (.then #(protocols-remote/rsync-to! remote))
      (.then #(protocols-remote/provision! remote))
      (.then #(tmux/new-window! (:id remote)))
      (.then #(protocols-remote/enter! remote))
      (.then (fn [_]
               (update-remote! (:id remote) #(assoc % :status :running))
               (state/log! (str "Started remote "
                                (:id remote)
                                " [" (:id remote) "] on "
                                (name (:remote-type remote))))))
      (.catch (fn [err]
                (update-remote! (:id remote) #(assoc % :status :error))
                (state/set-error! (str "Start failed: " err))))))

(defn push-remote! [remote]
  (let [id (:id remote)]
    (update-remote! id #(assoc % :status :pushing))
    (-> (protocols-remote/rsync-to! remote)
        (.then (fn [_]
                 (update-remote! id #(assoc % :status :running
                                            :last-sync (.toISOString (js/Date.))))
                 (state/log! (str "Pushed " id " from " (name (:remote-type remote))))))
        (.catch (fn [err]
                  (update-remote! id #(assoc % :status :error))
                  (state/set-error! (str "Push failed: " err)))))))

(defn pull-remote! [remote]
  (let [id (:id remote)]
    (update-remote! id #(assoc % :status :pulling))
    (-> (protocols-remote/rsync-from! remote)
        (.then (fn [_]
                 (update-remote! id #(assoc % :status :running
                                            :last-sync (.toISOString (js/Date.))))
                 (state/log! (str "Pulled " id " from " (name (:remote-type remote))))))
        (.catch (fn [err]
                  (update-remote! id #(assoc % :status :error))
                  (state/set-error! (str "Pull failed: " err)))))))

(defn delete-remote! [remote]
  (let [id (:id remote)]
    (-> (tmux/kill-window! id)
        (.then #(protocols-remote/delete! remote))
        (.then (fn [_]
                 (swap! state/app-state update :remotes #(filterv (fn [r] (not= (:id r) id)) %))
                 (swap! state/app-state update :selected #(max 0 (dec %)))
                 (state/log! (str "Deleted remote " id))))
        (.catch (fn [err] (state/set-error! (str "Delete failed: " err)))))))

(defn attach-remote! [remote]
  (-> (tmux/switch-to-window! (:id remote))
      (.catch (fn [err] (state/set-error! (str "Attach failed: " err))))))
