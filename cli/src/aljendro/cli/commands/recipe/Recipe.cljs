(ns aljendro.cli.commands.recipe.Recipe
  (:require
   ["node:fs/promises" :as fs]
   ["node:process" :as path]
   [clojure.string :as str]
   [clojure.edn :as edn]
   [aljendro.cli.commands.recipe.common :refer [RECIPE_DIRECTORY
                                                RECIPE_FILE_SUFFIX]]
   [aljendro.cli.commands.recipe.Instruction :as instruction]
   [aljendro.cli.commands.recipe.Input :as input_ns]
   ;
   ))

(defrecord Recipe [title description inputs instructions])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; METHODS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(declare generate-instruction-step-fn)

(defn ^:async follow "Follow the recipe"
  [self]
  (let [state-atom (atom {})]
    (doseq [i (:inputs self)]
      (when (input_ns/is-input? i)
        (await (input_ns/execute i state-atom))))
    (doseq [i (:instructions self)]
      (when (instruction/is-instruction? i)
        (await (instruction/execute i state-atom))))))

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
             'instructions (fn [n] (map #(apply instruction/->Instruction %) n))
             'inputs (fn [n] (map #(apply input_ns/->Input %) n))}})

(defn ^:async read-recipe "Read a recipe from the filesystem"
  [filepath]
  (->> (fs/readFile filepath "utf8")
       await
       (edn/read-string readers)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PRIVATE UTILITIES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

