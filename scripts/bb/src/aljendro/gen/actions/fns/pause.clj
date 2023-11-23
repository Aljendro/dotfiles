(ns aljendro.gen.actions.fns.pause
  (:require [aljendro.gen.actions.fns :refer [gen-fns]]))

(defmethod gen-fns :pause [_fn-kw input _context]
  (when-let [wait-time-in-ms (:ms input)]
    (println "Sleeping for " wait-time-in-ms " milliseconds")
    (Thread/sleep wait-time-in-ms)))

