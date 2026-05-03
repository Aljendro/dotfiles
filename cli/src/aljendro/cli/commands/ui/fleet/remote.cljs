(ns aljendro.cli.commands.ui.fleet.remote
  (:require
   [aljendro.cli.commands.ui.fleet.remotes.local :as local-remote]
   [aljendro.cli.commands.ui.fleet.remotes.lima :as lima-remote]
   [aljendro.cli.commands.ui.fleet.remotes.digitalocean :as digitalocean-remote]))

(defn create-remote [remote-map]
  (let [{:keys [id branch remote-type remote-name status last-sync]} remote-map
        remote-type (keyword remote-type)
        status (if (keyword? status) status (keyword (or status "stopped")))]
    (case remote-type
      :local        (local-remote/->LocalRemote id branch remote-type remote-name status last-sync)
      :lima         (lima-remote/->LimaRemote id branch remote-type remote-name status last-sync)
      :digitalocean (digitalocean-remote/->DigitalOceanRemote id branch remote-type remote-name status last-sync)
      nil)))

