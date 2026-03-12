(ns aljendro.cli.commands.gen.generator
  (:require [aljendro.cli.utils.handlebars :as hbs]
            ["path" :as path]
            [clojure.tools.cli :refer [parse-opts]]))

(def ^:private options
  [["-n" "--name NAME" "The name of the generator"]
   ["-d" "--description DESCRIPTION" "The description of the generator"]
   ["-h" "--help" "Show help"]])

(defn run [args]
  (let [{:keys [options errors]} (parse-opts args options)
        {:keys [name description help]} options]
    (cond
      help
      (println "Usage: t gen generator -n <name> -d <description>")

      errors
      (do (doseq [e errors] (println e))
          (js/process.exit 1))

      (or (nil? name) (nil? description))
      (do (println "Error: --name and --description are required")
          (js/process.exit 1))

      :else
      (let [dotfiles-dir (.-DOTFILES_DIR js/process.env)
            from-path    (.join path dotfiles-dir "/files/templates/gen/generator_command.cljs.txt")
            to-path      (.join path dotfiles-dir (str "/cli/src/aljendro/cli/commands/gen/" name ".cljs"))]
        (hbs/render-at from-path to-path {:name name :description description})))))
