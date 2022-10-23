(ns aljendro.preload
  (:require [clojure.java.shell :refer [sh]]
            [clojure.string :as str]))

(defn run [command & {:keys [error-message]}]
  (let [split-command (clojure.string/split command #" ")
        result (apply sh split-command)]
    (if (= (:exit result) 0)
      (:out result)
      (do
        (println error-message)
        (throw (Exception. (:err result)))))))

