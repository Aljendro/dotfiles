(ns aljendro.cli.commands.ui.fleet.components.detail-view
  (:require ["ink" :as ink]
            [aljendro.cli.commands.ui.fleet.state :as state]
            [aljendro.cli.commands.ui.fleet.agent :as agent]
            [aljendro.cli.commands.ui.fleet.worktree :as worktree]
            [aljendro.cli.commands.ui.fleet.components.common :as common]))

;; ── Input Handler ───────────────────────────────────────────────────────────

(defn handle-input [input key]
  (let [{:keys [agents selected]} @state/app-state
        ag (nth agents selected nil)]
    (cond
      (or (.-escape key) (= input "q"))
      (swap! state/app-state assoc :view :list)

      (and ag (= input "a"))
      (do (state/clear-error!) (agent/attach-agent! ag))

      (and ag (= input "P"))
      (do (state/clear-error!) (agent/push-agent! ag))

      (and ag (= input "p"))
      (do (state/clear-error!) (agent/pull-agent! ag))

      (and ag (= input "d"))
      (swap! state/app-state assoc :view :confirm-delete :error nil))))

;; ── Component ───────────────────────────────────────────────────────────────

(defn DetailView [agent cols]
  (let [{:keys [branch env status last-sync lima-name digitalocean-name]} agent
        sep (apply str (repeat (- cols 10) "─"))]
    [:> ink/Box {:flexDirection "column" :paddingX 1}
     [:> ink/Box {:marginBottom 1}
      [:> ink/Text {:bold true :color "cyan"} "Agent Detail"]]
     [:> ink/Box {:flexDirection "column" :marginBottom 1}
      [:> ink/Box {:flexDirection "row"}
       [:> ink/Text {:color "gray"} (common/pad-right "Branch"  10)]
       [:> ink/Text {:color "white"} branch]]
      [:> ink/Box {:flexDirection "row"}
       [:> ink/Text {:color "gray"} (common/pad-right "Env"     10)]
       [:> ink/Text {:color (common/env-color env)} (name env)]]
      [:> ink/Box {:flexDirection "row"}
       [:> ink/Text {:color "gray"} (common/pad-right "Status"  10)]
       [:> ink/Text {:color (common/status-color status)} (name status)]]
      [:> ink/Box {:flexDirection "row"}
       [:> ink/Text {:color "gray"} (common/pad-right "Worktree" 10)]
       [:> ink/Text {:color "gray"} (worktree/worktree-path branch)]]
      (when lima-name
        [:> ink/Box {:flexDirection "row"}
         [:> ink/Text {:color "gray"} (common/pad-right "VM name" 10)]
         [:> ink/Text {:color "white"} lima-name]])
      (when digitalocean-name
        [:> ink/Box {:flexDirection "row"}
         [:> ink/Text {:color "gray"} (common/pad-right "Droplet" 10)]
         [:> ink/Text {:color "white"} digitalocean-name]])
      [:> ink/Box {:flexDirection "row"}
       [:> ink/Text {:color "gray"} (common/pad-right "Synced" 10)]
       [:> ink/Text {:color "white"} (or (common/time-ago last-sync) "never")]]]
     [:> ink/Box {}
      [:> ink/Text {:color "gray"} sep]]
     [:> ink/Box {:marginTop 1}
      (case env
        :local        [:> ink/Text {:color "gray"} "Local worktree — changes are on disk immediately."]
        :lima         [:> ink/Text {:color "cyan"} "Lima VM — press 'P' to push, 'p' to pull via rsync."]
        :digitalocean [:> ink/Text {:color "blue"} "DigitalOcean Droplet — press 'P' to push, 'p' to pull via rsync."]
        nil)]
     [:> ink/Box {:marginTop 1}
      [:> ink/Text {:color "gray"} "a attach  P push  p pull  d delete  Esc back"]]]))
