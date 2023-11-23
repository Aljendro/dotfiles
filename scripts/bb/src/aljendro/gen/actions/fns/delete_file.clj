(ns aljendro.gen.actions.fns.delete-file
  (:require [aljendro.gen.actions.fns :refer [gen-fns]]
            [babashka.fs :as fs]))

(defmethod gen-fns :delete-file [_fn-kw input context]
  (if-let [file-name (:file-name input)]
    (let [cwd (get input :cwd (get context :cwd))
          file-path (str cwd "/" file-name)]
      (println "file-path:" file-path)
      (when (fs/exists? file-path)
        (print "delete file (y/n): ")
        (flush)
        (when (= (read-line) "y")
          (println "deleting file:" file-name "in:" cwd)
          (fs/delete file-path))))
    (throw (IllegalArgumentException.
            (str "Missing file-name argument in delete-file: " input)))))

