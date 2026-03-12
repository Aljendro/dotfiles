(ns aljendro.cli.utils.handlebars
  (:require ["handlebars" :as Handlebars]
            ["fs/promises" :as fs]
            ["path" :as path]))

(defn render-at [from-filepath to-filepath data]
  (-> (.readFile fs from-filepath "utf8")
      (.then (fn [template-content]
               (let [template (.compile Handlebars template-content)
                     rendered (template (clj->js data))]
                 (-> (.mkdir fs (.dirname path to-filepath) #js {:recursive true})
                     (.then (fn [_]
                              (.writeFile fs to-filepath rendered #js {:flag "wx"})))))))
      (.catch (fn [err]
                (if (= (.-code err) "EEXIST")
                  (js/console.error (str "File (" to-filepath ") already exists, not overwriting."))
                  (throw err))))))
