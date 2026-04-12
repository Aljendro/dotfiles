(ns aljendro.cli.commands.ui.fleet.components.confirm-delete
  (:require ["ink" :as ink]
            [aljendro.cli.commands.ui.fleet.state :as state]
            [aljendro.cli.commands.ui.fleet.agent :as agent]
            [aljendro.cli.commands.ui.fleet.components.common :as common]))

;; ── Input Handler ───────────────────────────────────────────────────────────

(defn handle-input [_input key]
  (let [{:keys [agents selected]} @state/app-state
        ag (nth agents selected nil)]
    (cond
      (.-escape key)
      (swap! state/app-state assoc :view :list)

      (.-return key)
      (when ag
        (state/clear-error!)
        (agent/delete-agent! ag)
        (swap! state/app-state assoc :view :list)))))

;; ── Component ───────────────────────────────────────────────────────────────

(defn ConfirmDelete [agent]
  (let [{:keys [branch env]} agent]
    [:> ink/Box {:flexDirection "column" :borderStyle "round" :borderColor "red"
                 :paddingX 2 :paddingY 1 :width 60}
     [:> ink/Text {:bold true :color "red"} "Delete Agent?"]
     [:> ink/Box {:marginTop 1 :flexDirection "column"}
      [:> ink/Box {:flexDirection "row"}
       [:> ink/Text {:color "gray"} "Branch: "]
       [:> ink/Text {:color "white"} branch]]
      [:> ink/Box {:flexDirection "row"}
       [:> ink/Text {:color "gray"} "Env:    "]
       [:> ink/Text {:color (common/env-color env)} (name env)]]]
     [:> ink/Text {:color "gray" :marginTop 1}
      "This will kill the tmux window and remove the worktree."]
     [:> ink/Box {:marginTop 1}
      [:> ink/Text {:color "gray"} "Enter confirm · Esc cancel"]]]))
