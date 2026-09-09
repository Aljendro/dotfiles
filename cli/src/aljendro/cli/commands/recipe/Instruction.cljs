(ns aljendro.cli.commands.recipe.Instruction
  (:require
   ["node:fs/promises" :as fs]
   ["node:path" :as path]
   ["node:os" :as os]
   [aljendro.cli.commands.recipe.InstructionAction :as InstructionAction]
   [aljendro.cli.utils.templating :as templating]
   [aljendro.cli.utils.shell :as shell]
   [clojure.string :as str]
   [aljendro.cli.commands.recipe.common :refer [TEMPLATE_DIRECTORY]]
   ;
   ))

(defrecord Instruction [action inputs])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; METHODS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(declare InstructionAction->action-fn)

(defn ^:async execute "Execute this instruction"
  [self global-state-atom]
  ((InstructionAction->action-fn (:action self)) global-state-atom (:inputs self)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PUBLIC UTILITIES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn is-instruction?
  [value]
  (instance? Instruction value))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PRIVATE UTILITIES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def ^:private nvim-command-str "nvim -u NONE --headless ")

(defn- resolve-filepath "Resolve filepath taken from a recipe file."
  [recipe-filepath]
  (-> recipe-filepath
      (str/replace #"^<gt>" (str js/process.env.DOTFILES_DIR "/" TEMPLATE_DIRECTORY))
      (str/replace #"<t>" TEMPLATE_DIRECTORY)
      path/resolve))

(defn- ^:async create-file "Create the file"
  [global-state-atom {:keys [filepath template]}]
  (let [template-content (await (fs/readFile (resolve-filepath template) "utf8"))
        content (templating/render template-content @global-state-atom "<< MISSING >>")]
    (fs/writeFile filepath content #js {:encoding "utf8" :flush true})))

(defn- ^:async update-target "Targetted update within file using a template"
  [global-state-atom {:keys [filepath template target]}]
  (let [temp-filepath (path/join (os/tmpdir) (str "update-target-" (random-uuid) ".tmp"))
        nvim-command (str nvim-command-str "'+/" target "' '+-r " temp-filepath "' '+x' " filepath)]
    (try
      (await (create-file global-state-atom {:filepath temp-filepath :template template}))
      (await (shell/exec! nvim-command))
      (finally
        (await (fs/rm temp-filepath #js {:force true}))))))

(defn- ^:async update-nvim "Update a file with arbitrary nvim dsl"
  [_global-state-atom {:keys [filepath commands]}]
  (let [nvim-command (str nvim-command-str "'+" commands "' '+x' " filepath)]
    (shell/exec! nvim-command)))

(def ^:private InstructionAction->action-fn
  {InstructionAction/CREATE_FILE create-file
   InstructionAction/UPDATE_TARGET update-target
   InstructionAction/UPDATE_NVIM update-nvim})

(comment
  ; METHODS
  (def a1 (atom {:name "Bob"}))

  ((^:async fn [] (def m1
                    (await (execute
                            (->Instruction
                             InstructionAction/CREATE_FILE
                             {:filepath "./somefile.local.txt"
                              :template "<t>/hello.template"})
                            a1)))))

  ((^:async fn [] (def m2
                    (await (execute
                            (->Instruction
                             InstructionAction/UPDATE_TARGET
                             {:filepath "./somefile.local.txt"
                              :template "<t>/hello.template"
                              :target "<< TARGET >>"})
                            a1)))))

  ((^:async fn [] (def m3 (await (execute
                                  (->Instruction
                                   InstructionAction/UPDATE_NVIM
                                   {:filepath "./somefile.local.txt"
                                    :commands "norm! /TARGET
oHELLO FROM THE VIM COMMAND"})
                                  a1)))))

  ; PUBLIC UTILITIES

  ; PRIVATE UTILITIES
  (resolve-filepath "<gt>/hello.template")
  (resolve-filepath "<t>/hello.template")
  ;
  )
