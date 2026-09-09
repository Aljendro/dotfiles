;   Copyright (c) Rich Hickey. All rights reserved.
;   The use and distribution terms for this software are covered by the
;   Eclipse Public License 1.0 (http://opensource.org/licenses/eclipse-1.0.php)
;   which can be found in the file epl-v10.html at the root of this distribution.
;   By using this software in any fashion, you are agreeing to be bound by
;   the terms of this license.
;   You must not remove this notice, or any other, from this software.

;;; walk.clj - generic tree walker with replacement

;; by Stuart Sierra
;; December 15, 2008

;; CHANGE LOG:
;;
;; * September 8, 2026: simplified 'walk' and added async processing for cljs
;;
;; * December 15, 2008: replaced 'walk' with 'prewalk' & 'postwalk'
;;
;; * December 9, 2008: first version

(ns aljendro.cli.utils.walk)

(defn ^:async async-walk
  [async-fn form]
  (let [all (^:async fn [xs]
                        (loop [xs (seq xs) acc []]
                          (if xs
                            (let [v (await (async-fn (first xs)))]
                              (recur (next xs) (conj acc v)))
                            acc)))]
    (cond
      (list? form)      (apply list (await (all form)))
      (map-entry? form) (vec (await (all form)))
      (seq? form)       (doall (await (all form)))
      (record? form)    (reduce conj form (await (all form)))
      (coll? form)      (into (empty form) (await (all form)))
      :else form)))

(defn ^:async async-prewalk [f form]
  (await (async-walk (partial async-prewalk f) (await (f form)))))

(comment
  (def v1 [:a [:b [:c (seq '(:d :e :f))] {:h "hello" :i "bye"} #{:x :y :z}] :zz])
  ((^:async fn [] (def r1 (await (async-prewalk (^:async fn [x] (println x) x) v1)))))
  ;
  )
