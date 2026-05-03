(ns aljendro.cli.commands.ui.fleet.main
  (:require ["ink" :as ink]
            [reagent.core :as r]
            [aljendro.cli.commands.ui.fleet.remote :as remote]
            [aljendro.cli.commands.ui.fleet.state :as state]
            [aljendro.cli.commands.ui.fleet.components.app :as app]
            [aljendro.cli.commands.ui.fleet.components.confirm-delete :as confirm-delete]
            [aljendro.cli.commands.ui.fleet.components.create-wizard :as create-wizard]
            [aljendro.cli.commands.ui.fleet.components.detail-view :as detail-view]))

;; ── Root ─────────────────────────────────────────────────────────────────────

(defn Base []
  (let [stdout (.-stdout (ink/useStdout))
        rows   (.-rows stdout)
        cols   (.-columns stdout)
        _      (ink/useInput
                (fn [input key]
                  (case (:view @state/app-state)
                    :create         (create-wizard/handle-input input key)
                    :detail         (detail-view/handle-input input key)
                    :confirm-delete (confirm-delete/handle-input input key)
                    (app/handle-input input key))))]
    [:f> app/App rows cols]))

(defn root []
  [:f> Base])

(defn run []
  (when-not (.-TMUX js/process.env)
    (js/console.error "Error: fleet must be run inside a tmux session")
    (js/process.exit 1))
  (state/init-runtime!)
  (state/init-persistence! remote/create-remote)
  (.write js/process.stdout "\u001b[?1049h\u001b[2J\u001b[H")
  (ink/render (r/as-element [root])))
