(ns aljendro.cli.commands.ui.fleet.components.create-wizard
  (:require ["ink" :as ink]
            [aljendro.cli.commands.ui.fleet.remote :as remote]
            [aljendro.cli.commands.ui.fleet.state :as state]
            [aljendro.cli.commands.ui.fleet.agent-refactor :as agent]
            [aljendro.cli.commands.ui.fleet.components.common :as common]))

;; ── Input Handler ───────────────────────────────────────────────────────────

(defn handle-input [input key]
  (let [{:keys [step branch remote-type remote-type-idx remote-name]} @state/create-state]
    (cond
      (.-escape key)
      (swap! state/app-state assoc :view :list :error nil)

      (.-return key)
      (case step
        :branch
        (when (seq branch)
          (swap! state/create-state assoc :step :remote-type))

        :remote-type
        (when (some? remote-type)
          (swap! state/create-state assoc :step :remote-name))

        :remote-name
        (when (seq remote-name)
          (swap! state/create-state assoc :step :confirm))

        :confirm
        (let [{:keys [branch remote-type remote-name]} @state/create-state
              new-remote (remote/create-remote {:id          (agent/gen-id)
                                                :branch      branch
                                                :remote-type remote-type
                                                :remote-name remote-name
                                                :status      :starting
                                                :last-sync   nil})]
          (swap! state/app-state (fn [s]
                                   (-> s
                                       (update :remotes conj new-remote)
                                       (assoc :view :list :error nil))))
          (reset! state/create-state {:step :branch :branch "" :remote-type :local
                                      :remote-type-idx 0 :remote-name "dev"})
          (agent/start-remote! new-remote))
        nil)

      ;; Remote type selection with arrows
      (and (= step :remote-type) (.-leftArrow key))
      (let [i (mod (dec remote-type-idx) (count common/remote-types))]
        (swap! state/create-state assoc :remote-type (nth common/remote-types i) :remote-type-idx i))

      (and (= step :remote-type) (.-rightArrow key))
      (let [i (mod (inc remote-type-idx) (count common/remote-types))]
        (swap! state/create-state assoc :remote-type (nth common/remote-types i) :remote-type-idx i))

      ;; Backspace
      (or (.-backspace key) (.-delete key))
      (case step
        :branch      (swap! state/create-state update :branch      #(subs % 0 (max 0 (dec (count %)))))
        :remote-name (swap! state/create-state update :remote-name #(subs % 0 (max 0 (dec (count %)))))
        nil)

      ;; Printable chars
      (and (seq input) (not (.-ctrl key)) (not (.-meta key)))
      (case step
        :branch      (swap! state/create-state update :branch      str input)
        :remote-name (swap! state/create-state update :remote-name str input)
        nil))))

;; ── Component ───────────────────────────────────────────────────────────────

(defn CreateWizard []
  (let [{:keys [step branch remote-type remote-name]} @state/create-state]
    [:> ink/Box {:flexDirection "column" :borderStyle "round" :borderColor "cyan"
                 :paddingX 2 :paddingY 1 :width 60}
     [:> ink/Text {:bold true :color "cyan"} "New Remote"]

     [:> ink/Box {:marginTop 1 :flexDirection "column"}
      ;; Branch
      [:> ink/Box {:flexDirection "row" :marginBottom 1}
       [:> ink/Text {:color (if (= step :branch) "cyan" "gray")} "Branch:      "]
       (if (= step :branch)
         [common/TextInput {:value branch :placeholder "feature/my-branch"}]
         [:> ink/Text {:color "white"} branch])]

      ;; Remote Type
      [:> ink/Box {:flexDirection "row" :marginBottom 1}
       [:> ink/Text {:color (if (= step :env) "cyan" "gray")} "Type: "]
       (into [:> ink/Box {:flexDirection "row"}]
             (map (fn [e]
                    [:> ink/Box {:key (name e) :marginRight 2}
                     [:> ink/Text {:color (if (= e remote-type) (common/remote-type-color e) "gray")}
                      (str (if (= e remote-type) "◉ " "○ ") (name e))]])
                  common/remote-types))]

      (when (not= step :branch)
        [:> ink/Box {:flexDirection "row" :marginBottom 1}
         [:> ink/Text {:color (if (= step :remote-name) "cyan" "gray")} "Name:     "]
         (if (= step :remote-name)
           [common/TextInput {:value remote-name :placeholder "dev"}]
           [:> ink/Text {:color "white"} remote-name])])]

     [:> ink/Box {:marginTop 1}
      [:> ink/Text {:color "gray"}
       (case step
         :branch      "Type branch name · Enter to continue · Esc cancel"
         :remote-type "← → select env · Enter continue · Esc cancel"
         :remote-name "Type name · Enter continue · Esc cancel"
         :confirm     "Enter to create · Esc cancel"
         "")]]]))
