(ns aljendro.cli.utils.templating
  (:require [clojure.string :as str]))

(def ^:private token-re #"\{\{\s*([\w.-]+)\s*\}\}")
(def ^:private sentinel (js-obj)) ; distinguishes "missing" from nil

(defn- path [k]
  (mapv keyword (str/split k #"\.")))

(defn render
  ([template data] (render template data ""))
  ([template data missing]
   (str/replace template token-re
                (fn [[_ k]]
                  (let [v (get-in data (path k) sentinel)]
                    (if (identical? v sentinel) missing (str v)))))))
