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

(defn- get-display-item-fn
  [initialized-projects & {:keys [active-only] :or {active-only false}}]
  (fn display-item [selection]
    (if (some (fn [item] (str/starts-with? item selection)) initialized-projects)
      ; Adding additional chars to show which project is already active (ref: additional_selection_chars)
      (str "● " selection)
      (when (not active-only) (str "  " selection)))))

(defn- ^:async display-project-sessions "Display all projects by their (active or inactive) session names"
  [selections initialized-projects options]
  (shell/exec! (str "echo \""
                    (->> selections
                         (map (get-display-item-fn initialized-projects options))
                         (filter identity)
                         (str/join "\n"))
                    "\" | fzf --ansi --header=\"● = Active Session\"")))

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
            final-chosen-identifier (str/replace-first chosen-identifier "● " "")]
        (await (projectinit/enter (get identifier->ProjectInitializer final-chosen-identifier)))))))


