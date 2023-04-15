(ns cgpt
  (:require
   ["dotenv" :as dotenv]
   ["openai" :as openai]
   [promesa.core :as p]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helper Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(.config dotenv)

;; Setup openai configuration and api instance
(def configuration (new (.-Configuration openai) (clj->js {:apiKey (.-OPENAI_API_KEY (.-env js/process))})))
(def openai-api (new (.-OpenAIApi openai) configuration))

(defn create-chat-completion []
  #_{:clj-kondo/ignore [:unresolved-symbol]}
  (p/let [result (.. openai-api
                     (createChatCompletion (clj->js {:model "gpt-3.5-turbo"
                                                     :messages [{:role "user" :content "What is pi to the 7th digit"}]})))]
    (js/console.log
     (js/JSON.stringify
      result
      (fn [k v]
        (if (= k "request")
          nil
          v))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn -main []
  (create-chat-completion))
