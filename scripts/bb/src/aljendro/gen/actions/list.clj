(ns aljendro.gen.actions.list
  (:require [aljendro.common :as common]
            [babashka.fs :as fs]
            [clojure.string :as string]))

(defn list-generators []
  (let [available-generators (atom [])]
    (fs/walk-file-tree
     @common/generators-dir
     {:visit-file
      (fn [unix-path _unix-file-attrs]
        (swap! available-generators conj (string/replace (.toString unix-path) (str @common/generators-dir "/") ""))
        :continue)})
    @available-generators))
