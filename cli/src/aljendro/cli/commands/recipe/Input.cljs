(ns aljendro.cli.commands.recipe.Input
  (:require
   [aljendro.cli.utils.shell :as shell]
   [aljendro.cli.utils.enum :as enum]
   [aljendro.cli.commands.recipe.InputAction :refer [InputAction]]
   ;
   ))

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

(def ^:private InputAction->action-fn
  {(enum/of InputAction USER) user-input
   (enum/of InputAction SET) set-input})

(comment
  ; METHODS

  ; PUBLIC UTILITIES

  ; PRIVATE UTILITIES
  ;
  )
