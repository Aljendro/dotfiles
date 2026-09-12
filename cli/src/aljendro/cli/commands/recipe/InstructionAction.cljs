(ns aljendro.cli.commands.recipe.InstructionAction)

(def CREATE_FILE :create)
(def UPDATE_TARGET :update)
(def UPDATE_NVIM :nvim)

(defn is-instruction-action? [in]
  (boolean (#{CREATE_FILE UPDATE_TARGET UPDATE_NVIM} in)))

