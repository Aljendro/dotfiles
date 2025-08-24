(ns aljendro.common
  (:require [clojure.string :as string]
            [clojure.java.io :as io]
            [clojure.edn :as edn])
  (:import [java.time ZonedDateTime]
           [java.time.format DateTimeFormatter]
           [java.nio.file Paths]))

(def dotfiles-dir (System/getenv "DOTFILES_DIR"))
(def root-dir (atom ""))
(def generators-dir (atom ""))
(def templates-dir (atom ""))
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

(defn absolute-path [path-str]
  (.getAbsolutePath (io/file path-str)))

(defn make-relative [directory absolute-path]
  (let [dir-path (Paths/get directory (into-array String []))
        abs-path (Paths/get absolute-path (into-array String []))]
    (str (.relativize dir-path abs-path))))

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

