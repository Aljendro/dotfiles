(ns aljendro.cli.commands.now)

(defn run []
  (println (.toISOString (js/Date.))))
