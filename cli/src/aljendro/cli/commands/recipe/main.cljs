(ns aljendro.cli.commands.recipe.main
  (:require
   ["node:path" :as path]
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

(defn ^:async select-recipe "Ask the user to select a recipe, bypass if passed into arguments"
  [extracted-recipes arguments]
  (let [arguments-filepath (first arguments)
        absolute-filepath (when arguments-filepath (path/resolve arguments-filepath))
        chosen-recipe (some #(when (= (:filepath %) absolute-filepath) %) extracted-recipes)]
    (if chosen-recipe
      chosen-recipe
      (let [selection->Recipe (into {} (map #(vector (str (:title %) " | " (:description %)) %) extracted-recipes))
            chosen-selection (await (display-recipes (keys selection->Recipe)))]
        (selection->Recipe chosen-selection)))))

(defn ^:async resolve-all-recipes "Resolve local and global recipes"
  [options]
  (let [{global? :global local? :local} options
        global-recipes (when global? (await (recipe/extract-recipes {:global? global?})))
        local-recipes (when (or local? (not global?)) (await (recipe/extract-recipes)))
        all-recipes-filepaths (set/union (set local-recipes) (set global-recipes))
        all-recipes (await (js/Promise.all (map recipe/read-recipe all-recipes-filepaths)))]
    (map #(conj %1 [:filepath %2]) all-recipes all-recipes-filepaths)))

(defn parse-template-inputs "Takes a set of inputs that a template needs as input"
  [arguments]
  (let [inputs (rest arguments)]
    (when (even? (count inputs))
      (into {} (for [[k v] (partition 2 inputs)]
                 [(keyword k) (str v)])))))

(defn ^:async run [args]
  (let [{:keys [options arguments errors]} (parse-opts args options)
        {help :help} options]
    (cond
      help
      (println "Usage: t recipe")

      errors
      (do (doseq [e errors] (println e))
          (js/process.exit 1))

      :else
      (let [extracted-recipes (await (resolve-all-recipes options))
            chosen-recipe (await (select-recipe extracted-recipes arguments))]
        (recipe/follow chosen-recipe (atom (parse-template-inputs args)))))))
