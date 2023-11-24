(ns aljendro.gen.main
  (:require [aljendro.common :as common]
            [aljendro.gen.actions.run :as actions-run]
            [aljendro.gen.actions.list :as actions-list]
            [babashka.process :as process]
            [clojure.string :as string]))

(defn extract-required-fields [chosen-generator description required-inputs]
  (let [chosen-inputs (atom [])]
    (println (str "Template: " chosen-generator))
    (println (str "Description: " description "\n"))
    (dorun
     (map
      (fn [required-input]
        (let [input-flag (first required-input)
              input-description (nth required-input 2)]
          (println (str input-description " (" input-flag "):"))
          (print "> ")
          (flush)
          (let [input-value (read-line)]
            (swap! chosen-inputs conj input-flag input-value)
            (println))))
      required-inputs))
    @chosen-inputs))

(defn extract-generator-details []
  (let [available-generators (actions-list/list-generators)
        fzf-input (string/join "\n" available-generators)
        chosen-generator (string/trim (:out (process/shell {:in fzf-input :out :string} "fzf")))
        chosen-generator-path (str common/generators-dir "/" chosen-generator)
        generator-details (common/read-edn-file chosen-generator-path)
        inputs (:input generator-details)
        description (:description generator-details)
        required-fields (filter #(some #{:missing} %) inputs)
        chosen-args (extract-required-fields chosen-generator description required-fields)]
    (println "Generated input:")
    (println (str "gen " chosen-generator " " (string/join " " chosen-args) "\n"))
    {:chosen-generator chosen-generator :chosen-args chosen-args}))

(defn -main [& args]
  (let [cwd (first args)
        generator-file-path (second args)
        args (rest args)]
    (if-not (nil? generator-file-path)
      (actions-run/run-generator
       cwd
       generator-file-path
       args)
      (let [{:keys [chosen-generator chosen-args]} (extract-generator-details)]
        (when-not (nil? chosen-generator)
          (actions-run/run-generator
           cwd
           chosen-generator
           chosen-args))))))


