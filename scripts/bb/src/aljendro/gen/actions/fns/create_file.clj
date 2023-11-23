(ns aljendro.gen.actions.fns.create-file
  (:require [aljendro.gen.actions.fns :refer [gen-fns]]
            [aljendro.common :as common]
            [babashka.fs :as fs]
            [selmer.parser :as selmer]))

(defmethod gen-fns :create-file [_fn-kw input context]
  (if-let [file-name (:file-name input)]
    (let [cwd (get input :cwd (get context :cwd))
          file-path (str cwd "/" file-name)]
      (when (not (fs/exists? file-path))
        (println "creating file:" file-name "in:" cwd)
        (fs/create-file file-path)
        (when-let [template (:template input)]
          (let [template-path (str common/templates-dir "/" template)
                template-content (slurp template-path)
                rendered-content (selmer/render template-content context)]
            (spit file-path rendered-content :append true)))))
    (throw (IllegalArgumentException.
            (str "Missing file-name argument in create-file: " input)))))

