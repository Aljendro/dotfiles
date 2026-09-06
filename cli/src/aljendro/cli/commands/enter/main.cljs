(ns aljendro.cli.commands.enter.main
  (:require
   [clojure.string :as str]
   [aljendro.cli.utils.shell :as shell]
   [aljendro.cli.commands.enter.ProjectInitializer :as projectinit]
   ;
   ))

(defn- ^:async display-project-sessions "Display all projects by their (active or inactive) session names"
  [options initialized-projects]
  (shell/exec! (str "echo \""
                    (str/join "\n" (map #(if (some (fn [item] (str/starts-with? item %)) initialized-projects)
                                           ; Adding additional chars to show which project is already active (ref: additional_selection_chars)
                                           (str "O " %)
                                           (str "- " %))
                                        options))
                    "\" | fzf --ansi --header=\"O = Active Session\"")))

(defn ^:async run []
  (let [[identifier->ProjectInitializer initialized-projects]
        (await (js/Promise.all [(projectinit/get-identifier->ProjectInitializer)
                                (projectinit/find-all-initialized-projects)]))
        chosen-identifier (await (display-project-sessions (keys identifier->ProjectInitializer) initialized-projects))
        ; Remove the extra characters we added (ref: additional_selection_chars)
        final-chosen-identifier (subs chosen-identifier 2)]
    (await (projectinit/enter (get identifier->ProjectInitializer final-chosen-identifier)))))

