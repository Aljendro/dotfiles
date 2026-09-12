(ns aljendro.cli.commands.recipe.Input
  (:require
   ["@aws-sdk/client-secrets-manager" :as secrets]
   ["@aws-sdk/credential-providers" :as ini]
   [aljendro.cli.utils.shell :as shell]
   [aljendro.cli.utils.enum :as enum]
   [aljendro.cli.commands.recipe.InputAction :refer [InputAction]]))

(defrecord Input [action inputs])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; METHODS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(declare InputAction->action-fn)

(defn ^:async execute "Execute this instruction"
  [self global-state-atom]
  ((InputAction->action-fn (:action self)) global-state-atom (:inputs self)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PUBLIC UTILITIES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn is-input?
  [value]
  (instance? Input value))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PRIVATE UTILITIES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn ^:async user-input "Get the user's input"
  [global-state-atom inputs]
  (let [var-keyword (keyword (:var inputs))
        user-input (try
                     (await (shell/get-user-input (str "Set " var-keyword " : ")))
                     (catch js/Error _e
                       (or (:default inputs) "")))]
    (swap! global-state-atom assoc var-keyword user-input)))

(defn ^:async set-input "Set the input directly"
  [global-state-atom inputs]
  (let [var-keyword (keyword (:var inputs))]
    (cond
      (contains? inputs :with)
      (swap! global-state-atom assoc var-keyword (:with inputs))

      (contains? inputs :from)
      (swap! global-state-atom assoc var-keyword (get @global-state-atom (keyword (:from inputs))))

      :else "noop")))

(defn ^:async aws-secret "Get a secret from aws secrets manager"
  [global-state-atom inputs]
  (let [var-keyword (keyword (:var inputs))
        client (secrets/SecretsManagerClient. #js {:region (get-in inputs [:client :region] "us-west-1")
                                                   :credentials (ini/fromIni #js {:profile (:profile inputs)})})
        command (secrets/GetSecretValueCommand. #js {:SecretId (:name inputs)})
        secret (js->clj (await (.send client command)) :keywordize-keys true)]
    (swap! global-state-atom assoc var-keyword (:SecretString secret))))

(def ^:private InputAction->action-fn
  {(enum/of InputAction USER) user-input
   (enum/of InputAction SET) set-input
   (enum/of InputAction AWS_SECRET) aws-secret})

