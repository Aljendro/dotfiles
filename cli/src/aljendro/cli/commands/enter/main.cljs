(ns aljendro.cli.commands.enter.main
  (:require
   [clojure.string :as str]
   [aljendro.cli.utils.shell :as shell]
   [aljendro.cli.commands.enter.ProjectInitializer :as projectinit]
   [clojure.tools.cli :refer [parse-opts]]
   ;
   ))

(def ^:private options
  [["-a" "--active-only" "Only show the active sessions"
    :default false]
   ["-h" "--help" "Show help"]])

(defn- display-item
  [initialized-projects active-only selection]
  (if (some (fn [item] (str/starts-with? item selection)) initialized-projects)
    ; Adding additional chars to show which project is already active (ref: additional_selection_chars)
    (str "O " selection)
    (when (not active-only) (str "- " selection))))

(defn- ^:async display-project-sessions "Display all projects by their (active or inactive) session names"
  [selections initialized-projects {:keys [active-only]}]
  (shell/exec! (str "echo \""
                    (str/join "\n" (filter #(when % %) (map (partial display-item initialized-projects active-only) selections)))
                    "\" | fzf --ansi --header=\"O = Active Session\"")))

(defn ^:async run [args]
  (let [{:keys [options errors]} (parse-opts args options)
        {:keys [help]} options]
    (cond
      help
      (println "Usage: t enter [--active]")

      errors
      (do (doseq [e errors] (println e))
          (js/process.exit 1))

      :else
      (let [[identifier->ProjectInitializer initialized-projects]
            (await (js/Promise.all [(projectinit/get-identifier->ProjectInitializer)
                                    (projectinit/find-all-initialized-projects)]))
            chosen-identifier (await (display-project-sessions (keys identifier->ProjectInitializer) initialized-projects options))
        ; Remove the extra characters we added (ref: additional_selection_chars)
            final-chosen-identifier (subs chosen-identifier 2)]
        (await (projectinit/enter (get identifier->ProjectInitializer final-chosen-identifier)))))))


