(ns aljendro.cli.commands.recipe.InstructionAction
  (:require
   [aljendro.cli.utils.enum :as enum]))

(enum/defenum InstructionAction
  [CREATE DIR DELETE UPDATE NVIM])
