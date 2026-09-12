(ns aljendro.cli.commands.recipe.InputAction
  (:require
   [aljendro.cli.utils.enum :as enum]))

(enum/defenum InputAction
  [USER SET AWS_SECRET])
