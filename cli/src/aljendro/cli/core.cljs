(ns aljendro.cli.core
  (:require
   [aljendro.cli.commands.ui.demo :as demo]
   [aljendro.cli.commands.now :as now]
   [aljendro.cli.commands.unix2iso :as unix2iso]
   [aljendro.cli.commands.mfa :as mfa]
   [aljendro.cli.commands.gen.generator :as generator]
   [aljendro.cli.commands.gen.start-project :as start-project]
   [clojure.tools.cli :refer [parse-opts]]))

(def ^:private commands
  {"now"
   {:desc "Prints the current ISO 8601 timestamp"
    :run  now/run}

   "unix2iso"
   {:desc "Converts 13-digit Unix timestamps in stdin to ISO 8601 format"
    :run  unix2iso/run}

   "mfa"
   {:desc "Authenticate using MFA device for AWS CLI access"
    :run  mfa/run}

   "gen"
   {:desc "Generator subcommands"
    :subcommands
    {"generator"
     {:desc "Create a new generator"
      :run  generator/run}
     "start_project"
     {:desc "Create a startup project file"
      :run  start-project/run}}}})

(defn- print-usage []
  (println "Usage: t <command> [options]\n")
  (println "Commands:")
  (doseq [[cmd {:keys [desc subcommands]}] (sort-by first commands)]
    (if subcommands
      (do
        (println (str "  " cmd "  " desc))
        (doseq [[sub {:keys [desc]}] (sort-by first subcommands)]
          (println (str "    " sub "  " desc))))
      (println (str "  " cmd "  " desc))))
  (println "\nOptions:")
  (println "  -h, --help  Show this help"))

(defn- handle-result [result]
  (when (instance? js/Promise result)
    (.catch result (fn [e]
                     (js/console.error (.-message e))
                     (js/process.exit 1)))))

(defn -main [& args]
  (let [{:keys [arguments options]} (parse-opts args [["-h" "--help" "Show help"]] :in-order true)
        [cmd & rest-args] arguments]
    (cond
      (:help options)
      (print-usage)

      (nil? cmd)
      (do (print-usage) (js/process.exit 1))

      :else
      (if-let [{:keys [run subcommands]} (get commands cmd)]
        (if subcommands
          (let [[sub-cmd & sub-args] rest-args]
            (if-let [{sub-run :run} (get subcommands sub-cmd)]
              (handle-result (sub-run sub-args))
              (do (println (str "Unknown subcommand '" sub-cmd "' for command '" cmd "'"))
                  (js/process.exit 1))))
          (handle-result (run rest-args)))
        (do (println (str "Unknown command: '" cmd "'"))
            (js/process.exit 1))))))
