(ns aljendro.cli.utils.filesystem
  (:require
   ["node:fs/promises" :as fs]))

(defn ^:async file-exists? [path]
  (try
    (await (.access fs path))
    true
    (catch :default _ false)))
