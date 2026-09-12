(ns aljendro.cli.utils.enum
  (:require
   [clojure.string :as str]))

(defmacro defenum
  "Defines ONE var holding the whole enum."
  [enum-name members]
  (when-not (simple-symbol? enum-name)
    (throw (ex-info "defenum: enum name must be a simple symbol" {:got enum-name})))
  (when-not (and (vector? members) (seq members) (every? simple-symbol? members))
    (throw (ex-info "defenum: members must be a non-empty literal vector of symbols"
                    {:enum enum-name :got members})))
  (when-not (apply distinct? members)
    (throw (ex-info "defenum: duplicate members" {:enum enum-name :members members})))
  (let [base (str/lower-case (name enum-name))
        m    (into {} (map (fn [s] [(keyword (name s))
                                    (keyword base (str/lower-case (name s)))]))
                   members)]
    `(def ~enum-name
       {:enum/name    '~enum-name
        :enum/members ~m
        :enum/values  ~(set (vals m))})))

(defn- resolve-enum [sym]
  (let [v (resolve sym)]
    (when-not (var? v)
      (throw (ex-info (str "Unknown enum: " sym) {:symbol sym})))
    (let [e (deref v)]
      (when-not (:enum/members e)
        (throw (ex-info (str sym " is not an enum") {:symbol sym})))
      e)))

(defmacro of
  "Returns the value of MEMBER in ENUM-SYM. Compile-time error if it isn't a member."
  [enum-sym member]
  (let [{:enum/keys [members]} (resolve-enum enum-sym)]
    (or (get members (keyword (name member)))
        (throw (ex-info (str member " is not a member of " enum-sym
                             ". Valid members: " (str/join ", " (map name (keys members))))
                        {:enum enum-sym :member member})))))

