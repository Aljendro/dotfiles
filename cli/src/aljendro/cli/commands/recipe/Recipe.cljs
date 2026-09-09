(ns aljendro.cli.commands.recipe.Recipe
  (:require
   ["node:fs/promises" :as fs]
   ["node:process" :as path]
   [clojure.string :as str]
   [clojure.edn :as edn]
   [aljendro.cli.utils.walk :refer [async-prewalk]]
   [aljendro.cli.commands.recipe.common :refer [RECIPE_DIRECTORY
                                                RECIPE_FILE_SUFFIX]]
   [aljendro.cli.commands.recipe.Instruction :as instruction]
   ;
   ))

(defrecord Recipe [title description inputs instructions])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; METHODS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(declare generate-execute-step-fn)

(defn ^:async follow "Follow the recipe"
  [self]
  (let [execute-step (generate-execute-step-fn (atom {}))]
    (async-prewalk execute-step (:instructions self))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PUBLIC UTILITIES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn ^:async extract-recipes "Extract the Recipe(s) filepaths in the current working directory or globally"
  [& {:keys [global?]}]
  (let [recipe-directory (str (if global? js/process.env.DOTFILES_DIR (path/cwd)) "/" RECIPE_DIRECTORY)]
    (try
      (->> (fs/readdir recipe-directory #js {:encoding "utf8" :recursive true})
           await
           js->clj
           (filter #(str/ends-with? % RECIPE_FILE_SUFFIX))
           (map #(str recipe-directory "/" %)))
      (catch js/Error _e '()))))

(def ^:private readers
  {:readers {'recipe map->Recipe
             'instructions (fn [n] (map #(apply instruction/->Instruction %) n))}})

(defn ^:async read-recipe "Read a recipe from the filesystem"
  [filepath]
  (->> (fs/readFile filepath "utf8")
       await
       (edn/read-string readers)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PRIVATE UTILITIES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn- generate-execute-step-fn "Creates a function that will executes a single step of the recipe traversal"
  [state-atom]
  (fn execute-step [step]
    (cond
      (instruction/is-instruction? step) (instruction/execute step state-atom)
      :else step)))

(comment
  ; METHODS
  (def steps [:a :b :c {:create-fn "hello"}])
  (def recipe1 (->Recipe "sample" "description" [] steps))

  (follow recipe1)

  ; PUBLIC UTILITIES
  ((^:async fn [] (def p1 (await (extract-recipes)))))
  ((^:async fn [] (def p2 (await (extract-recipes {:global? true})))))

  ((^:async fn [] (def p3 (await (read-recipe "/Users/alejandroalvarado/dotfiles/cli/recipes/hello.recipe.edn")))))

  ; PRIVATE UTILITIES
  ;
  )

