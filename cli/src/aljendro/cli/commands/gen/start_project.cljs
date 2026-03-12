(ns aljendro.cli.commands.gen.start-project
  (:require [aljendro.cli.utils.handlebars :as hbs]
            [cljs.core.async :refer [go]]
            [cljs.core.async.interop :refer-macros [<p!]]
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
            cwd          (.cwd js/process)]
        (go
          (<p! (hbs/render-at
                (.join path dotfiles-dir "/files/templates/general/ignore.txt")
                (.join path cwd ".ignore")
                {:name name}))
          (let [start-project-path (.join path cwd "start_project.local.sh")]
            (<p! (hbs/render-at
                  (.join path dotfiles-dir "/files/templates/general/start_project.txt")
                  start-project-path
                  {:name name}))
            (<p! (.chmod fs start-project-path "700"))
            (-> (.unlink fs "/tmp/tmux_projects_cache")
                (.catch (fn [_])))))))))
