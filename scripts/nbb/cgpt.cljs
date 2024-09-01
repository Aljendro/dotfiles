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
(def openai-api (new (.-OpenAI openai) 
                     (clj->js {:apiKey (.-OPENAI_API_KEY (.-env js/process))})))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helper Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn request-models []
  (.. openai-api -models list))

(defn request-completion [query & {:keys [model context] :or {model "gpt-3.5-turbo" context []}}]
  (.. openai-api
      -chat
      -completions
      (create
       (clj->js {:model model
                 :messages (concat context [{:role "user" :content query}])}))))

(defn get-response-content [response]
  (let [response (js->clj (.-choices response))]
    (get-in response [0 "message" "content"])))

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Repl Usage
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(comment
  ; Get a list of the latest models newest to oldest
  (do
    (require '[cljs.pprint :refer [pprint]])
    #_{:clj-kondo/ignore [:unresolved-symbol]}
    (p/let [response (request-models)]
      (let [models (js->clj (.-data response))]
        (->>
         models
         ; only take the id and created fields
         (map #(select-keys % ["id" "created"]))
         ; sort newest to oldest
         (sort #(compare (get %2 "created") (get %1 "created")));
         (pprint))))))

(comment
  ; run a simple completion
  #_{:clj-kondo/ignore [:unresolved-symbol]}
  (p/let [response (request-completion "What is the capital of France?")]
    (println (get-response-content response))))
