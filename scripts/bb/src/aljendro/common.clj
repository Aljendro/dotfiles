(ns aljendro.common
  (:require [clojure.string :as string]
            [clojure.java.io :as io]
            [clojure.edn :as edn])
  (:import [java.time ZonedDateTime]
           [java.time.format DateTimeFormatter]))

(def dotfiles-dir (System/getenv "DOTFILES_DIR"))
(def templates-dir (str dotfiles-dir "/files/templates"))
(def generators-dir (str dotfiles-dir "/files/generators"))
(def fns-dir (str dotfiles-dir "/scripts/bb/src/aljendro/gen/actions/fns"))

(defn read-edn-file
  "Load edn from an io/reader source (filename or io/resource)."
  [source]
  (try
    (with-open [r (io/reader source)]
      (edn/read (java.io.PushbackReader. r)))
    (catch java.io.IOException e
      (printf "Couldn't open '%s': %s\n" source (.getMessage e)))
    (catch RuntimeException e
      (printf "Error parsing edn file '%s': %s\n" source (.getMessage e)))))

(defn error-msg [errors]
  (str "The following errors occurred while parsing your command:\n\n"
       (string/join \newline errors)))

(defn exit [_status msg]
  (println msg))

(defn load-files [path]
  (let [file  (java.io.File. path)
        files (.listFiles file)]
    (doseq [x files]
      (when (.isFile x)
        (load-file (.getCanonicalPath x))))))

(defn gen-8601-timestamp
  "generate iso8601 timestamp
   https://gist.github.com/minimal/b79f50fe6cdd2f6da9698c4a47599afe"
  []
  (.. (ZonedDateTime/now) (format DateTimeFormatter/ISO_INSTANT)))

