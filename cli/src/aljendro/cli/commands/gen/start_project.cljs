(ns aljendro.cli.commands.gen.start-project
  (:require [aljendro.cli.utils.handlebars :as hbs]
            [promesa.core :as p]
            ["path" :as path]
            ["fs/promises" :as fs]
            [clojure.tools.cli :refer [parse-opts]]))

(def ^:private options
  [["-n" "--name NAME" "The name of the project identifier"]
   ["-h" "--help" "Show help"]])

(defn run [args]
  (let [{:keys [options errors]} (parse-opts args options)
        {:keys [name help]} options]
    (cond
      help
      (println "Usage: t gen start_project -n <name>")

      errors
      (do (doseq [e errors] (println e))
          (js/process.exit 1))

      (nil? name)
      (do (println "Error: --name is required")
          (js/process.exit 1))

      :else
      (let [dotfiles-dir (.-DOTFILES_DIR js/process.env)
            cwd          (.-PWD js/process.env)
            start-project-path (path/join cwd "start_project.local.sh")]
        (p/do
          (hbs/render-at
           (path/join dotfiles-dir "/files/templates/general/ignore.txt")
           (path/join cwd ".ignore")
           {:name name})
          (hbs/render-at
           (path/join dotfiles-dir "/files/templates/general/start_project.txt")
           start-project-path
           {:name name})
          (fs/chmod start-project-path "700")
          (-> (fs/unlink "/tmp/tmux_projects_cache")
              (.catch (fn [_]))))))))
