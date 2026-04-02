(ns aljendro.cli.commands.ui.fleet.components.common
  (:require ["ink" :as ink]))

;; ── UI Helpers ───────────────────────────────────────────────────────────────

(defn pad-right [s n]
  (let [s   (str s)
        len (count s)]
    (if (>= len n) (subs s 0 n) (str s (apply str (repeat (- n len) " "))))))

(defn status-color [status]
  (case status
    :running  "green"
    :starting "yellow"
    :syncing  "cyan"
    :error    "red"
    "gray"))

(defn status-label [status]
  (case status
    :running  "RUNNING "
    :starting "STARTING"
    :syncing  "SYNCING "
    :error    "ERROR   "
    "IDLE    "))

(defn env-color [env]
  (case env :local "white" :lima "cyan" :ec2 "magenta" "gray"))

(defn time-ago [iso-str]
  (when iso-str
    (let [diff (- (.now js/Date) (.getTime (js/Date. iso-str)))
          secs (js/Math.floor (/ diff 1000))
          mins (js/Math.floor (/ secs 60))]
      (cond (< mins 1)  (str secs "s ago")
            (< mins 60) (str mins "m ago")
            :else       (str (js/Math.floor (/ mins 60)) "h ago")))))

(def envs [:local :lima :ec2])

;; ── TextInput ────────────────────────────────────────────────────────────────

(defn TextInput [{:keys [value placeholder]}]
  (if (seq value)
    [:> ink/Text {:color "white"} (str value "\u258c")]
    [:> ink/Text {:color "gray"} (str (or placeholder "") "\u258c")]))

;; ── AgentRow ─────────────────────────────────────────────────────────────────

(defn AgentRow [agent selected?]
  (let [{:keys [branch env status last-sync]} agent]
    [:> ink/Box {:flexDirection "row"}
     [:> ink/Text {:color (if selected? "cyan" "gray")}
      (if selected? "▶ " "  ")]
     [:> ink/Text {:color "white"}
      (pad-right branch 22)]
     [:> ink/Text {:color (env-color env)}
      (pad-right (str " " (name env)) 8)]
     [:> ink/Text {:color (status-color status) :bold selected?}
      (str " " (status-label status) " ")]
     [:> ink/Text {:color "gray"}
      (str "  " (or (time-ago last-sync) "—"))]]))
