(ns preload
  (:require
   ["node:util" :as util]
   ["node:readline" :as readline]))

(defmacro with-open
  "bindings => [name init ...]
  Evaluates body in a try expression with names bound to the values
  of the inits, and a finally clause that calls (.close name) on each
  name in reverse order."
  [bindings & body]
  (assert (vector? bindings) "a vector for its binding")
  (assert (even? (count bindings)) "an even number of forms in binding vector")
  (cond
    (= (count bindings) 0) `(do ~@body)
    (symbol? (bindings 0)) `(let ~(subvec bindings 0 2)
                              (->
                               (js/Promise.
                                (fn [resolve#]
                                  (resolve#
                                   (with-open
                                    ~(subvec bindings 2)
                                     ~@body))))
                               (.finally #(.close ~(bindings 0)))))
    :else (throw (js/Error. "with-cleanup only allows Symbols in bindings"))))

(defn prompt
  "prompt a user with a statement, receive answer as a promise."
  [rl & args]
  (apply
   (.bind
    (.promisify util (.-question rl))
    rl)
   args))

(defn get-readline
  "get a readline object attached to stdin/stdout"
  []
  (. readline
     createInterface
     #js {:input (.-stdin js/process)
          :output (.-stdout js/process)}))

(defn printp
  "Takes a form that returns a promise, resolves the promise, pretty prints result."
  [promise & {:keys [flat?]}]
  (-> promise
      (.then
       #(println
         (if flat?
           (js/JSON.stringify %1)
           (js/JSON.stringify %1 nil 2))))))

