(ns aljendro.cli.commands.enter.ProjectInitializer
  "Encapsulates the startup_project.local.sh script

  These scripts are set at the root of projects for discoverability
  and initialization within TMUX.

  (see: ../../../../../../files/templates/general/start_project.txt)"

  (:require
   ["node:path" :as path]
   ["node:fs/promises" :as fs]
   [clojure.string :as str]
   [aljendro.cli.utils.shell :as shell]
   [aljendro.cli.utils.filesystem :as cljsfs]))

(def ^:private CACHE_FILE "/tmp/tmux_identifiers_cache")

(defrecord ProjectInitializer [filepath])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; METHODS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(declare
 extract-session-name
 extract-session-identifier
 find-all-initialized-projects
 has-active-session?)

(defn ^:async initialize
  "Initalize the project"
  [self]
  (let [filepath (:filepath self)]
    (shell/exec! (str "cd " (path/dirname filepath) "; bash " filepath))))

(defn ^:async enter
  "Enters the project"
  [self]
  (let [active? (await (has-active-session? self))]
    (when (not active?)
      (await (initialize self)))
    (let [session-identifier (await (extract-session-identifier self))]
      (if js/process.env.TMUX
        (shell/exec! (str "tmux switch-client -t " session-identifier))
        (shell/exec-interactive! (str "tmux attach -t " session-identifier))))))

(defn ^:async extract-session-identifier
  "Extracts the session identifier that the user uses to select which project to initialize"
  [self]
  (->> (fs/readFile (:filepath self) "utf8")
       await
       str/split-lines
       (some #(when (str/starts-with? % "session=") %))
       extract-session-name))

(defn ^:async has-active-session?
  "Checks if a project has been initialized and active"
  [self]
  (let [[all-active-sessions session-identifier]
        (await (js/Promise.all [(find-all-initialized-projects)
                                (extract-session-identifier self)]))]

    (boolean (some #(str/starts-with? % session-identifier) all-active-sessions))))

(defn ^:async generate-identifier-project-filepath-pair
  "Generates a vector where the first element is the identifier
  and the second element is the proejct initializer filepath"
  [self]
  [(await (extract-session-identifier self)) self])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PUBLIC UTILITIES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn ^:async find-all-project-initializers "Find all projects startup_project.local.sh initialization scripts"
  []
  (->> (if (await (cljsfs/file-exists? CACHE_FILE))
         (await (fs/readFile CACHE_FILE "utf8"))
         (await (shell/exec! (str "cd $HOME; fd -H --type executable --absolute-path start_project.local.sh | tee " CACHE_FILE))))
       str/split-lines
       (map #(->ProjectInitializer %))))

(defn ^:async get-identifier->ProjectInitializer "Return a map from project identifier to project initializer filepath"
  []
  (let [initializers (await (find-all-project-initializers))
        identifiers (await (js/Promise.all
                            (mapv generate-identifier-project-filepath-pair initializers)))]
    (into {} identifiers)))

(defn ^:async find-all-initialized-projects "Lists all active sessions in TMUX"
  []
  (->> "tmux list-sessions -F '#{session_name}' 2>/dev/null || echo \"\""
       shell/exec!
       await
       str/split-lines))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PRIVATE UTILITIES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn- extract-session-name
  "Extract the session name from a line starting with session="
  [line]
  (when (string? line)
    (-> line
        str/trim
        (str/replace-first #"(?i)session=" "")
        ; replace the starting/ending quotations ("sample" => sample)
        (str/replace #"^\"|\"$" ""))))

(comment
  ; METHODS
  (def identifier1 (->ProjectInitializer "/Users/alejandroalvarado/dotfiles/start_project.local.sh"))
  (def identifier2 (->ProjectInitializer "/Users/alejandroalvarado/Documents/Projects/todoisp/start_project.local.sh"))

  ((^:async fn [] (def m1 (await (extract-session-identifier identifier1)))))
  ((^:async fn [] (def m2 (await (has-active-session? identifier1)))))
  ((^:async fn [] (def m3 (await (has-active-session? identifier2)))))

  ; PUBLIC UTILITIES
  ((^:async fn [] (def p1 (await (find-all-project-initializers)))))
  ((^:async fn [] (def p2 (await (find-all-initialized-projects)))))
  ((^:async fn [] (def p3 (await (get-identifier->ProjectInitializer)))))
  ;
  )



