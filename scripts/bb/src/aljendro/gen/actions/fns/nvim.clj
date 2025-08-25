(ns aljendro.gen.actions.fns.nvim
  (:require [aljendro.common :as common]
            [aljendro.gen.actions.fns :refer [gen-fns]]
            [babashka.fs :as fs]
            [babashka.process :as process]
            [selmer.parser :as selmer])
  (:import [java.util UUID]))

(defn create-shada-dir []
  (let [shada-dir (str "/tmp/gen-nvim-shada-dir-" (UUID/randomUUID))]
    (fs/create-dir shada-dir)
    shada-dir))

(defn process-register [shada-dir shada-filename context [register content]]
  (let [register-str (name register)
        register-type (get content :type :charwise)
        register-file-name (str shada-dir "/" register-str ".txt")]
    (if-let [register-template (get content :template)]
      (let [template-data (slurp (str @common/templates-dir "/" register-template))
            register-content (selmer/render template-data context)]
        (spit register-file-name register-content))
      (spit register-file-name (get content :text "")))
    (if (= register-type :linewise)
      (process/sh (str "nvim --headless -u NONE -i " shada-filename " -c '%y " register-str "' +wq " register-file-name))
      (process/sh (str "nvim --headless -u NONE -i " shada-filename " -c 'norm! gg0vG$\"" register-str "y' +wq " register-file-name)))))

(defn setup-shada-file [input context]
  (let [shada-dir (create-shada-dir)
        shada-filename (str shada-dir "/tmp.shada")
        process-register-partial (partial process-register shada-dir shada-filename context)]
    (dorun
     (map process-register-partial (get input :registers {})))
    {:shada-filename shada-filename :shada-dir shada-dir}))

(defmethod gen-fns :nvim [_fn-kw input context]
  (let [file-name (:file-name input)
        macro (:macro input)]
    (if (and file-name macro)
      (let [cwd (get input :cwd (get context :cwd))
            file-path (str cwd "/" file-name)]
        (when (fs/exists? file-path)
          (let [merged-input (assoc-in input [:registers :z] {:text macro :type :charwise})
                {:keys [shada-filename shada-dir]} (setup-shada-file merged-input context)]
            (process/sh (str "nvim --headless -u NONE -i " shada-filename " -c 'norm @z' +wq " file-path))
            (fs/delete-tree shada-dir))))
      (throw (IllegalArgumentException.
              (str "Missing :file-name or :macro argument for nvim: " input))))))

