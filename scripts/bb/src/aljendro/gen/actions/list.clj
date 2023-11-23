(ns aljendro.gen.actions.list
  (:require [aljendro.common :as common]
            [clojure.string :as string]))

(defn list-generators []
  (doseq [file (file-seq (java.io.File. common/generators-dir))]
    (when (.isFile file)
      (println (string/replace (.getPath file) common/generators-dir "")))))

