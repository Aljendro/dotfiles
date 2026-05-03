(ns aljendro.cli.commands.ui.fleet.components.app
  (:require
   ["ink" :as ink]
   [aljendro.cli.commands.ui.fleet.components.common :as components-common]
   [aljendro.cli.commands.ui.fleet.components.confirm-delete :as components-confirm-delete]
   [aljendro.cli.commands.ui.fleet.components.create-wizard :as components-create-wizard]
   [aljendro.cli.commands.ui.fleet.components.detail-view :as components-detail-view]
   [aljendro.cli.commands.ui.fleet.remote :as remote]
   [aljendro.cli.commands.ui.fleet.state :as state]
   ;
   ))

;; ── Input Handler ───────────────────────────────────────────────────────────

(defn handle-input [input key]
  (let [{:keys [remotes selected]} @state/app-state
        total (count remotes)]
    (cond
      (= input "q") (js/process.exit 0)

      (= input "n")
      (do (reset! state/create-state {:step :branch :branch "" :remote-type :local
                                      :remote-type-idx 0 :remote-name "dev"})
          (swap! state/app-state assoc :view :create :error nil))

      (.-upArrow key)
      (swap! state/app-state update :selected #(max 0 (dec %)))

      (.-downArrow key)
      (when (pos? total)
        (swap! state/app-state update :selected #(min (dec total) (inc %))))

      (.-return key)
      (when (pos? total)
        (swap! state/app-state assoc :view :detail))

      (= input "a")
      (when-let [ag (nth remotes selected nil)]
        (state/clear-error!)
        (remote/attach-remote! ag))

      (= input "P")
      (when-let [ag (nth remotes selected nil)]
        (state/clear-error!)
        (remote/push-remote! ag))

      (= input "p")
      (when-let [ag (nth remotes selected nil)]
        (state/clear-error!)
        (remote/pull-remote! ag))

      (= input "d")
      (when (pos? total)
        (swap! state/app-state assoc :view :confirm-delete :error nil)))))

;; ── Component ───────────────────────────────────────────────────────────────

(defn App [rows cols]
  (let [{:keys [remotes selected view error]} @state/app-state
        total   (count remotes)
        running (count (filter #(= :running (:status %)) remotes))
        sep     (apply str (repeat (- cols 8) "─"))]
    [:> ink/Box {:height rows :width cols :flexDirection "column"
                 :paddingX 4 :paddingY 2 :justifyContent "center"}

     ;; Title bar
     [:> ink/Box {:paddingX 1}
      [:> ink/Text {:bold true :color "cyan"} "Fleet Manager"]
      [:> ink/Text {:color "gray"} (str "   remotes:" total)]
      [:> ink/Spacer]
      [:> ink/Text {:color "green"} (str "● " running " running")]
      (when error
        [:> ink/Text {:color "red"} (str "   ✗ " error)])]

     [:> ink/Box {}
      [:> ink/Text {:color "gray"} sep]]

     ;; Content
     (case view
       :list
       [:> ink/Box {:flexDirection "column" :flexGrow 1}
        [:> ink/Box {:paddingX 1}
         [:> ink/Text {:bold true :color "gray"}
          (str "  " (components-common/pad-right "BRANCH" 22) (components-common/pad-right " REMOTE TYPE" 8)
               " STATUS     LAST SYNC")]]
        [:> ink/Box {}
         [:> ink/Text {:color "gray"} sep]]
        (if (empty? remotes)
          [:> ink/Box {:paddingX 3 :marginTop 1}
           [:> ink/Text {:color "gray"} "No remotes. Press 'n' to create one."]]
          (into [:> ink/Box {:flexDirection "column"}]
                (map-indexed
                 (fn [i a] ^{:key (:id a)} [components-common/RemoteRow a (= i selected)])
                 remotes)))
        [:> ink/Spacer]
        [:> ink/Box {:borderStyle "single" :borderColor "gray" :paddingX 1}
         [:> ink/Text {:color "gray"}
          "n new   a attach   P push   p pull   d delete   ↑↓ navigate   Enter detail   q quit"]]]

       :create
       [:> ink/Box {:flexDirection "column" :flexGrow 1 :paddingX 2 :paddingTop 1}
        [components-create-wizard/CreateWizard]]

       :detail
       (when-let [remote (nth remotes selected nil)]
         [:> ink/Box {:flexDirection "column" :flexGrow 1}
          [components-detail-view/DetailView remote cols]])

       :confirm-delete
       (when-let [remote (nth remotes selected nil)]
         [:> ink/Box {:flexDirection "column" :flexGrow 1 :paddingX 2 :paddingTop 1}
          [components-confirm-delete/ConfirmDelete remote]])

       [:> ink/Text {:color "red"} "Unknown view"])]))
