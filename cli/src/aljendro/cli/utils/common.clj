(ns aljendro.cli.utils.common)

(defmacro adefn-
  "defn with a go block wrapping the body"
  [name & args]
  (let [pre-body (butlast args)
        body     (last args)]
    `(defn- ~name ~@pre-body
       (cljs.core.async/go ~body))))

(defmacro adefn
  "defn with a go block wrapping the body"
  [name & args]
  (let [pre-body (butlast args)
        body     (last args)]
    `(defn ~name ~@pre-body
       (cljs.core.async/go ~body))))
