(ns aljendro.cli.utils.handlebars
  (:require ["handlebars$default" :as Handlebars]
            ["fs/promises" :as fs]
            ["path" :as path]
            [promesa.core :as p]))

(defn render-at [from-filepath to-filepath data]
  (-> (p/let [template-content  (fs/readFile from-filepath "utf8")
              template          (Handlebars/compile template-content)
              rendered          (template (clj->js data))
              _                 (fs/mkdir  (path/dirname to-filepath) #js {:recursive true})]
        (fs/writeFile to-filepath rendered #js {:flag "wx"}))
      (p/catch
       (fn [err]
         (if (= (.-code err) "EEXIST")
           (js/console.error (str "File (" to-filepath ") already exists, not overwriting."))
           (throw err))))))
