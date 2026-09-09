(ns aljendro.cli.commands.recipe.InstructionAction)

(def CREATE_FILE :create-file)
(def UPDATE_TARGET :update-target)
(def UPDATE_NVIM :update-nvim)

(defn is-instruction-action? [in]
  (boolean (#{CREATE_FILE UPDATE_TARGET UPDATE_NVIM} in)))

