(ns aljendro.gen.main
  (:require [aljendro.gen.actions.run :as actions-run]))

(defn -main [& args]
  (let [cwd (first args)
        generator-file-path (second args)
        args (rest args)]
    (actions-run/run-generator
     cwd
     generator-file-path
     args)))

