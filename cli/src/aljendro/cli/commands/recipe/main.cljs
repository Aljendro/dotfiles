(ns aljendro.cli.commands.recipe.main
  (:require
   [clojure.string :as str]
   [clojure.set :as set]
   [clojure.tools.cli :refer [parse-opts]]
   [aljendro.cli.utils.shell :as shell]
   [aljendro.cli.commands.recipe.Recipe :as recipe]))

(def ^:private options
  [["-h" "--help" "Show help"]
   ["-g" "--global" "Show global recipes" :default false]
   ["-l" "--local" "Show local recipes" :default false]])

(defn- ^:async display-recipes "Display all recipes"
  [selections]
  (shell/exec! (str "echo \"" (str/join "\n" selections) "\" | fzf --ansi")))

(defn ^:async run [args]
  (let [{:keys [options errors]} (parse-opts args options)
        {help :help global? :global local? :local} options]
    (cond
      help
      (println "Usage: t recipe")

      errors
      (do (doseq [e errors] (println e))
          (js/process.exit 1))

      :else
      (let [global-recipes (when global? (await (recipe/extract-recipes {:global? global?})))
            local-recipes (when (or local? (not global?)) (await (recipe/extract-recipes)))
            all-recipes-filepaths (set/union (set local-recipes) (set global-recipes))
            extracted-recipes (await (js/Promise.all (map recipe/read-recipe all-recipes-filepaths)))
            selection->Recipe (into {} (map #(vector (str (:title %) " | " (:description %)) %) extracted-recipes))
            chosen-selection (await (display-recipes (keys selection->Recipe)))]
        (recipe/follow (selection->Recipe chosen-selection))))))
