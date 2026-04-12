(ns aljendro.cli.commands.ui.fleet.components.create-wizard
  (:require ["ink" :as ink]
            [aljendro.cli.commands.ui.fleet.state :as state]
            [aljendro.cli.commands.ui.fleet.agent :as agent]
            [aljendro.cli.commands.ui.fleet.components.common :as common]))

;; ── Input Handler ───────────────────────────────────────────────────────────

(defn handle-input [input key]
  (let [{:keys [step branch env env-idx lima-name digitalocean-name]} @state/create-state]
    (cond
      (.-escape key)
      (swap! state/app-state assoc :view :list :error nil)

      (.-return key)
      (case step
        :branch
        (when (seq branch)
          (swap! state/create-state assoc :step :env))

        :env
        (case env
          :lima         (swap! state/create-state assoc :step :lima-name)
          :digitalocean (swap! state/create-state assoc :step :digitalocean-name)
          (swap! state/create-state assoc :step :confirm))

        :lima-name
        (when (seq lima-name)
          (swap! state/create-state assoc :step :confirm))

        :digitalocean-name
        (when (seq digitalocean-name)
          (swap! state/create-state assoc :step :confirm))

        :confirm
        (let [{:keys [branch env lima-name digitalocean-name]} @state/create-state
              new-agent {:id                (agent/gen-id)
                         :branch            branch
                         :env               env
                         :lima-name         (when (= env :lima) lima-name)
                         :digitalocean-name (when (= env :digitalocean) digitalocean-name)
                         :status            :starting
                         :last-sync         nil}]
          (swap! state/app-state (fn [s]
                                   (-> s
                                       (update :agents conj new-agent)
                                       (assoc :view :list :error nil))))
          (reset! state/create-state {:step :branch :branch "" :env :local
                                      :env-idx 0 :lima-name "dev"
                                      :digitalocean-name "fleet-agent"})
          (agent/start-agent! new-agent))
        nil)

      ;; Env selection with arrows
      (and (= step :env) (.-leftArrow key))
      (let [i (mod (dec env-idx) (count common/envs))]
        (swap! state/create-state assoc :env (nth common/envs i) :env-idx i))

      (and (= step :env) (.-rightArrow key))
      (let [i (mod (inc env-idx) (count common/envs))]
        (swap! state/create-state assoc :env (nth common/envs i) :env-idx i))

      ;; Backspace
      (or (.-backspace key) (.-delete key))
      (case step
        :branch            (swap! state/create-state update :branch            #(subs % 0 (max 0 (dec (count %)))))
        :lima-name         (swap! state/create-state update :lima-name         #(subs % 0 (max 0 (dec (count %)))))
        :digitalocean-name (swap! state/create-state update :digitalocean-name #(subs % 0 (max 0 (dec (count %)))))
        nil)

      ;; Printable chars
      (and (seq input) (not (.-ctrl key)) (not (.-meta key)))
      (case step
        :branch            (swap! state/create-state update :branch            str input)
        :lima-name         (swap! state/create-state update :lima-name         str input)
        :digitalocean-name (swap! state/create-state update :digitalocean-name str input)
        nil))))

;; ── Component ───────────────────────────────────────────────────────────────

(defn CreateWizard []
  (let [{:keys [step branch env lima-name digitalocean-name]} @state/create-state]
    [:> ink/Box {:flexDirection "column" :borderStyle "round" :borderColor "cyan"
                 :paddingX 2 :paddingY 1 :width 60}
     [:> ink/Text {:bold true :color "cyan"} "New Agent"]

     [:> ink/Box {:marginTop 1 :flexDirection "column"}
      ;; Branch
      [:> ink/Box {:flexDirection "row" :marginBottom 1}
       [:> ink/Text {:color (if (= step :branch) "cyan" "gray")} "Branch:      "]
       (if (= step :branch)
         [common/TextInput {:value branch :placeholder "feature/my-branch"}]
         [:> ink/Text {:color "white"} branch])]

      ;; Environment
      [:> ink/Box {:flexDirection "row" :marginBottom 1}
       [:> ink/Text {:color (if (= step :env) "cyan" "gray")} "Environment: "]
       (into [:> ink/Box {:flexDirection "row"}]
             (map (fn [e]
                    [:> ink/Box {:key (name e) :marginRight 2}
                     [:> ink/Text {:color (if (= e env) (common/env-color e) "gray")}
                      (str (if (= e env) "◉ " "○ ") (name e))]])
                  common/envs))]

      ;; Lima VM name (only for :lima)
      (when (and (= env :lima) (not= step :branch))
        [:> ink/Box {:flexDirection "row" :marginBottom 1}
         [:> ink/Text {:color (if (= step :lima-name) "cyan" "gray")} "VM name:     "]
         (if (= step :lima-name)
           [common/TextInput {:value lima-name :placeholder "dev"}]
           [:> ink/Text {:color "white"} lima-name])])

      ;; DigitalOcean droplet name (only for :digitalocean)
      (when (and (= env :digitalocean) (not= step :branch))
        [:> ink/Box {:flexDirection "row" :marginBottom 1}
         [:> ink/Text {:color (if (= step :digitalocean-name) "cyan" "gray")} "Droplet:     "]
         (if (= step :digitalocean-name)
           [common/TextInput {:value digitalocean-name :placeholder "fleet-agent"}]
           [:> ink/Text {:color "white"} digitalocean-name])])]

     [:> ink/Box {:marginTop 1}
      [:> ink/Text {:color "gray"}
       (case step
         :branch            "Type branch name · Enter to continue · Esc cancel"
         :env               "← → select env · Enter continue · Esc cancel"
         :lima-name         "Type VM name · Enter continue · Esc cancel"
         :digitalocean-name "Type droplet name · Enter continue · Esc cancel"
         :confirm           "Enter to create · Esc cancel"
         "")]]]))
