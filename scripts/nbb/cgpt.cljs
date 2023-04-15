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

(defn request-completion [query & {:keys [model context] :or {model "gpt-3.5-turbo" context []}}]
  (.. openai-api
      (createChatCompletion
       (clj->js {:model model
                 :messages (concat context [{:role "user" :content query}])}))))

(defn get-response-content [response]
  (let [response (js->clj response)]
    (get-in response ["data" "choices" 0 "message" "content"])))

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
