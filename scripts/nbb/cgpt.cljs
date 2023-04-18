(ns cgpt
  (:require
   ["dotenv" :as dotenv]
   ["openai" :as openai]
   [promesa.core :as p]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(.config dotenv)
;; Setup openai configuration and api instance
(def configuration (new (.-Configuration openai) (clj->js {:apiKey (.-OPENAI_API_KEY (.-env js/process))})))
(def openai-api (new (.-OpenAIApi openai) configuration))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helper Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn request-models []
  (.listModels openai-api))

(defn request-completion [query & {:keys [model context] :or {model "gpt-3.5-turbo" context []}}]
  (.. openai-api
      (createChatCompletion
       (clj->js {:model model
                 :messages (concat context [{:role "user" :content query}])}))))

(defn get-response-content [response]
  (let [response (js->clj response)]
    (get-in response ["data" "choices" 0 "message" "content"])))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Repl Usage
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(comment
  ; Get a list of the latest models newest to oldest
  (do
    (require '[cljs.pprint :refer [pprint]])
    #_{:clj-kondo/ignore [:unresolved-symbol]}
    (p/let [response (request-models)
            models (js->clj response)]
      (->>
       ; Get the list of models
       (get-in models ["data" "data"])
       ; only take the id and created fields
       (map #(select-keys % ["id" "created"]))
       ; sort newest to oldest
       (sort #(compare (get %2 "created") (get %1 "created")));
       (pprint)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn -main
  "main function intended for simple commandline interaction,
  Prefer to use `request-completion` from repl instead."
  []
  (let [input (get js/process.argv 4)]
    #_{:clj-kondo/ignore [:unresolved-symbol]}
    (p/let [response (request-completion input)]
      (println (get-response-content response)))))
