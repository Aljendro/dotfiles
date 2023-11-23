(ns aljendro.gen.actions.fns)

(defmulti gen-fns (fn [fn-kw _input _context] fn-kw))

(defmethod gen-fns :default [fn-kw _input _context]
  (throw (IllegalArgumentException.
          (str "Unknown gen function: " fn-kw))))

