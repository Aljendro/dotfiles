(ns aljendro.cli.commands.ui.fleet.components.confirm-delete
  (:require
   ["ink" :as ink]
   [aljendro.cli.commands.ui.fleet.components.common :as components-common]
   [aljendro.cli.commands.ui.fleet.remote :as remote]
   [aljendro.cli.commands.ui.fleet.state :as state]
   ;
   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;; Component ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn ConfirmDelete [remote]
  (let [{:keys [branch remote-type]} remote]
    [:> ink/Box {:flexDirection "column" :borderStyle "round" :borderColor "red"
                 :paddingX 2 :paddingY 1 :width 60}
     [:> ink/Text {:bold true :color "red"} "Delete Remote?"]
     [:> ink/Box {:marginTop 1 :flexDirection "column"}
      [:> ink/Box {:flexDirection "row"}
       [:> ink/Text {:color "gray"} "Branch: "]
       [:> ink/Text {:color "white"} branch]]
      [:> ink/Box {:flexDirection "row"}
       [:> ink/Text {:color "gray"} "Type:    "]
       [:> ink/Text {:color (components-common/remote-type-color remote-type)} (name remote-type)]]]
     [:> ink/Text {:color "gray" :marginTop 1}
      "This will kill the tmux window and remove the worktree."]
     [:> ink/Box {:marginTop 1}
      [:> ink/Text {:color "gray"} "Enter confirm · Esc cancel"]]]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Input Handler ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn handle-input [_input key]
  (let [{:keys [remotes selected]} @state/app-state
        ag (nth remotes selected nil)]
    (cond
      (.-escape key)
      (swap! state/app-state assoc :view :list)

      (.-return key)
      (when ag
        (state/clear-error!)
        (remote/delete-remote! ag)
        (swap! state/app-state assoc :view :list)))))

