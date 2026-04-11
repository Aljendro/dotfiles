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

      (and ag (= input "s"))
      (do (state/clear-error!) (agent/sync-agent! ag))

      (and ag (= input "d"))
      (swap! state/app-state assoc :view :confirm-delete :error nil))))

;; ── Component ───────────────────────────────────────────────────────────────

(defn DetailView [agent cols]
  (let [{:keys [branch env status last-sync lima-name ec2-host
                digitalocean-name digitalocean-host]} agent
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
      (when ec2-host
        [:> ink/Box {:flexDirection "row"}
         [:> ink/Text {:color "gray"} (common/pad-right "EC2 host" 10)]
         [:> ink/Text {:color "white"} ec2-host]])
      (when digitalocean-name
        [:> ink/Box {:flexDirection "row"}
         [:> ink/Text {:color "gray"} (common/pad-right "Droplet" 10)]
         [:> ink/Text {:color "white"} digitalocean-name]])
      (when digitalocean-host
        [:> ink/Box {:flexDirection "row"}
         [:> ink/Text {:color "gray"} (common/pad-right "DO host" 10)]
         [:> ink/Text {:color "white"} digitalocean-host]])
      [:> ink/Box {:flexDirection "row"}
       [:> ink/Text {:color "gray"} (common/pad-right "Synced" 10)]
       [:> ink/Text {:color "white"} (or (common/time-ago last-sync) "never")]]]
     [:> ink/Box {}
      [:> ink/Text {:color "gray"} sep]]
     [:> ink/Box {:marginTop 1}
      (case env
        :local        [:> ink/Text {:color "gray"} "Local worktree — changes are on disk immediately."]
        :lima         [:> ink/Text {:color "cyan"} "Lima VM — press 's' to rsync changes back."]
        :ec2          [:> ink/Text {:color "magenta"} "EC2 remote — press 's' to rsync changes back."]
        :digitalocean [:> ink/Text {:color "blue"} "DigitalOcean Droplet — press 's' to rsync changes back."]
        nil)]
     [:> ink/Box {:marginTop 1}
      [:> ink/Text {:color "gray"} "a attach  s sync  d delete  Esc back"]]]))
