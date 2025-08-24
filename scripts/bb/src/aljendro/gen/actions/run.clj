(ns aljendro.gen.actions.run
  (:require [aljendro.common :as common]
            [aljendro.gen.actions.fns :refer [gen-fns]]
            [camel-snake-kebab.core :as csk]
            [clojure.string :as string]
            [clojure.tools.cli :refer [parse-opts]]
            [clojure.walk :as walk]
            [selmer.parser :as selmer]
            [selmer.util :as selmer-util]))

;; Load all fns that are used in gnerators files
(common/load-files common/fns-dir)

(defn inject-context-values-into-input
  "Walks the input map and replaces any values that are strings with the
  rendered value of that string using the context map."
  [input context]
  (walk/postwalk
   (fn [x]
     (if (string? x)
       (selmer/render x context)
       x))
   input))

(defn traverse-steps
  "Walks the steps map and executes any functions that are found in the :fn
  key. The result of the function is stored in the context map under the
  :id key if it exists. The result of the function is returned."
  [steps context]
  (walk/prewalk
   (fn [x]
     (if (map? x)
       (let [fn-kw (get x :fn)
             input (get x :input {})]
         (if fn-kw
           (do
             (println "Running:" fn-kw "with input:" input)
             (let [resolved-input (inject-context-values-into-input input @context)
                   result (gen-fns fn-kw resolved-input @context)]
               (when (get x :id)
                 (swap! context assoc (get x :id) result))
               (if (get x :steps)
                 {:result result :steps (get x :steps)}
                 {:result result})))
           x))
       x))
   steps))

(defn usage [generator-name options-summary]
  (->> [(str "Usage: gen " generator-name " [options]")
        ""
        "Arguments and Options:"
        options-summary
        ""]
       (string/join \newline)))

(defn filter-errors [filter-fn errors]
  (if (fn? filter-fn)
    (filter #(not (filter-fn %)) errors)
    errors))

(defn validate-args
  "Validate command line arguments. Either return a map indicating the program
  should exit (with an error message, and optional ok status), or a map
  indicating the options provided."
  [path args cli-options & {:keys [error-filter]}]
  (let [{:keys [options arguments errors summary]} (parse-opts args cli-options)
        filtered-errors (filter-errors error-filter errors)]
    (cond
      (or (:help options) (:spec options)) ; help => exit OK with usage summary
      {:exit-message (usage path summary) :ok? true}
      (seq filtered-errors) ; errors => exit with description of errors
      {:exit-message (common/error-msg filtered-errors)}
      :else
      {:options options :arguments arguments})))

(defn configure-selmer []
  (selmer.parser/set-resource-path! @common/templates-dir)
  (selmer.util/turn-off-escaping!)
  (selmer/add-filter! :snake-case csk/->snake_case_string)
  (selmer/add-filter! :kebab-case csk/->kebab-case-string)
  (selmer/add-filter! :pascal-case csk/->PascalCaseString))

(defn run-generator [cwd generator-file-path args]
  (let [generator-file-path (str @common/generators-dir "/" generator-file-path)
        data (common/read-edn-file generator-file-path)
        input-metadata (get data :input)
        {:keys [options exit-message :ok?]} (validate-args generator-file-path args input-metadata)]
    (if exit-message
      (common/exit (if ok? 0 1) exit-message)
      (do
        (configure-selmer)
        (traverse-steps
         data
         (atom {:input options
                :env (into {} (System/getenv))
                :cwd cwd}))))))


