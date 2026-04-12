(ns aljendro.cli.commands.ui.demo
  (:require ["ink" :as ink]
            [aljendro.cli.commands.ui.common.splash :as splash]
            [reagent.core :as r]))

(defonce state (r/atom {:input nil :splash true}))

(def initial-servers
  [;; load balancers
   {:id "lb-01"       :cpu 29 :mem 34 :procs  2 :uptime "60d 2h"}
   {:id "lb-02"       :cpu 33 :mem 36 :procs  2 :uptime "60d 2h"}
   {:id "lb-03"       :cpu 41 :mem 39 :procs  2 :uptime "12d 5h"}
   {:id "lb-04"       :cpu 22 :mem 31 :procs  2 :uptime "12d 5h"}
   {:id "lb-05"       :cpu 37 :mem 33 :procs  2 :uptime "4d 1h"}
   ;; web
   {:id "web-01"      :cpu 23 :mem 45 :procs 12 :uptime "14d 3h"}
   {:id "web-02"      :cpu 67 :mem 71 :procs 11 :uptime "14d 3h"}
   {:id "web-03"      :cpu 12 :mem 38 :procs 13 :uptime "14d 3h"}
   {:id "web-04"      :cpu 51 :mem 59 :procs 10 :uptime "14d 3h"}
   {:id "web-05"      :cpu 78 :mem 66 :procs 12 :uptime "3d 8h"}
   {:id "web-06"      :cpu 44 :mem 52 :procs 11 :uptime "3d 8h"}
   {:id "web-07"      :cpu 19 :mem 43 :procs 10 :uptime "3d 8h"}
   {:id "web-08"      :cpu 88 :mem 77 :procs  9 :uptime "0d 14h"}
   {:id "web-09"      :cpu 35 :mem 49 :procs 11 :uptime "0d 14h"}
   {:id "web-10"      :cpu 61 :mem 64 :procs 12 :uptime "0d 14h"}
   {:id "web-11"      :cpu 27 :mem 41 :procs 10 :uptime "0d 3h"}
   {:id "web-12"      :cpu 73 :mem 68 :procs 11 :uptime "0d 3h"}
   ;; api
   {:id "api-01"      :cpu 89 :mem 82 :procs  8 :uptime "6d 11h"}
   {:id "api-02"      :cpu 44 :mem 55 :procs  9 :uptime "6d 11h"}
   {:id "api-03"      :cpu 33 :mem 48 :procs  8 :uptime "6d 11h"}
   {:id "api-04"      :cpu 91 :mem 74 :procs  7 :uptime "1d 2h"}
   {:id "api-05"      :cpu 57 :mem 61 :procs  8 :uptime "1d 2h"}
   {:id "api-06"      :cpu 22 :mem 40 :procs  9 :uptime "1d 2h"}
   {:id "api-07"      :cpu 64 :mem 67 :procs  8 :uptime "0d 9h"}
   {:id "api-08"      :cpu 38 :mem 53 :procs  7 :uptime "0d 9h"}
   {:id "api-09"      :cpu 79 :mem 72 :procs  9 :uptime "0d 9h"}
   {:id "api-10"      :cpu 46 :mem 58 :procs  8 :uptime "0d 2h"}
   ;; grpc
   {:id "grpc-01"     :cpu 36 :mem 44 :procs  5 :uptime "9d 0h"}
   {:id "grpc-02"     :cpu 48 :mem 51 :procs  5 :uptime "9d 0h"}
   {:id "grpc-03"     :cpu 55 :mem 59 :procs  5 :uptime "9d 0h"}
   {:id "grpc-04"     :cpu 31 :mem 46 :procs  4 :uptime "2d 17h"}
   ;; databases
   {:id "db-01"       :cpu 31 :mem 91 :procs  5 :uptime "90d 1h"}
   {:id "db-02"       :cpu 28 :mem 87 :procs  5 :uptime "90d 1h"}
   {:id "db-03"       :cpu 19 :mem 76 :procs  4 :uptime "12d 0h"}
   {:id "db-04"       :cpu 55 :mem 83 :procs  4 :uptime "12d 0h"}
   {:id "db-05"       :cpu 42 :mem 80 :procs  5 :uptime "12d 0h"}
   {:id "db-read-01"  :cpu 14 :mem 69 :procs  3 :uptime "45d 6h"}
   {:id "db-read-02"  :cpu 17 :mem 72 :procs  3 :uptime "45d 6h"}
   {:id "db-read-03"  :cpu 11 :mem 65 :procs  3 :uptime "45d 6h"}
   {:id "db-read-04"  :cpu 20 :mem 70 :procs  3 :uptime "45d 6h"}
   {:id "db-read-05"  :cpu 13 :mem 68 :procs  3 :uptime "7d 11h"}
   ;; cache
   {:id "cache-01"    :cpu  8 :mem 22 :procs  3 :uptime "30d 7h"}
   {:id "cache-02"    :cpu 14 :mem 31 :procs  3 :uptime "30d 7h"}
   {:id "cache-03"    :cpu  6 :mem 19 :procs  3 :uptime "30d 7h"}
   {:id "cache-04"    :cpu 11 :mem 27 :procs  3 :uptime "7d 3h"}
   {:id "cache-05"    :cpu  9 :mem 24 :procs  3 :uptime "7d 3h"}])

(defonce server-state (r/atom {:servers initial-servers :tick 0 :selected 0}))

(defn clamp [v lo hi] (max lo (min hi v)))

(defn jitter [v]
  (clamp (+ v (- (js/Math.round (* (js/Math.random) 13)) 6)) 0 100))

(defn derive-status [cpu mem]
  (cond
    (or (>= cpu 85) (>= mem 88)) :crit
    (or (>= cpu 65) (>= mem 70)) :warn
    :else                         :ok))

(defn tick-servers [servers]
  (mapv (fn [s]
          (let [cpu (jitter (:cpu s))
                mem (jitter (:mem s))]
            (assoc s :cpu cpu :mem mem :status (derive-status cpu mem))))
        servers))

(defn status-color [status]
  (case status :ok "green" :warn "yellow" :crit "red" "white"))

(defn status-label [status]
  (case status :ok " OK  " :warn "WARN " :crit "CRIT " " ??? "))

(defn pct-bar [v width]
  (let [filled (js/Math.round (* (/ v 100) width))
        color  (cond (>= v 85) "red" (>= v 65) "yellow" :else "green")]
    [color (str (apply str (repeat filled "█")) (apply str (repeat (- width filled) "░")))]))

(defn pad-right [s n]
  (let [len (count s)]
    (if (>= len n) (subs s 0 n) (str s (apply str (repeat (- n len) " "))))))

(defn pad-left [s n]
  (let [len (count s)]
    (if (>= len n) (subs s 0 n) (str (apply str (repeat (- n len) " ")) s))))

;; Fixed chars per row (excluding bar content):
;;   sel(2) host(10) status(7) cpu%(4) " ["(2) "] "(2) mem%(4) " ["(2) "] "(2) procs(4) uptime-pad(2)
;;   = 2+10+7+4+2+2+4+2+2+4+2 = 41  → two bar sections add 2*bar-w
;;   uptime-w is whatever remains
(defn compute-widths [cols]
  (let [fixed   41
        min-ut  8
        bar-w   (max 4 (js/Math.floor (/ (- cols fixed min-ut) 2)))
        uptime-w (- cols fixed (* 2 bar-w))]
    {:bar-w bar-w :uptime-w (max min-ut uptime-w)}))

(defn ServerRow [{:keys [id cpu mem procs uptime status]} selected? bar-w uptime-w]
  (let [[cpu-color cpu-bar] (pct-bar cpu bar-w)
        [mem-color mem-bar] (pct-bar mem bar-w)
        sc                  (status-color status)
        sl                  (status-label status)]
    [:> ink/Box {:flexDirection "row"}
     [:> ink/Text {:color (if selected? "cyan" "gray")} (if selected? "▶ " "  ")]
     [:> ink/Text {:color "white"}                      (pad-right id 10)]
     [:> ink/Text {:color sc :bold selected?}           (str " " sl " ")]
     [:> ink/Text {:color cpu-color}                    (pad-left (str cpu "%") 4)]
     [:> ink/Text {:color cpu-color}                    (str " [" cpu-bar "] ")]
     [:> ink/Text {:color mem-color}                    (pad-left (str mem "%") 4)]
     [:> ink/Text {:color mem-color}                    (str " [" mem-bar "] ")]
     [:> ink/Text {:color "gray"}                       (pad-left (str procs "p") 4)]
     [:> ink/Text {:color "gray"}                       (pad-right (str "  " uptime) uptime-w)]]))

(defn summary-counts [servers]
  {:ok   (count (filter #(= :ok   (:status %)) servers))
   :warn (count (filter #(= :warn (:status %)) servers))
   :crit (count (filter #(= :crit (:status %)) servers))})

(defn App [rows cols]
  (r/with-let [timer (js/setInterval
                      #(swap! server-state
                              (fn [s] (-> s (update :tick inc) (update :servers tick-servers))))
                      1200)]
    (let [{:keys [servers tick selected]} @server-state
          {:keys [ok warn crit]}          (summary-counts servers)
          total                           (count servers)
          {:keys [bar-w uptime-w]}        (compute-widths cols)
          sep                             (apply str (repeat cols "─"))]
      [:> ink/Box {:height rows :width cols :flexDirection "column" :paddingY 1}

       ;; ── Title bar ──────────────────────────────────────────────────
       [:> ink/Box {:marginBottom 1 :paddingX 1}
        [:> ink/Text {:bold true :color "cyan"} "Fleet Process Monitor"]
        [:> ink/Text {:color "gray"} (str "  servers:" total)]
        [:> ink/Spacer]
        [:> ink/Text {:color "green"}  (str "● " ok " ok  ")]
        [:> ink/Text {:color "yellow"} (str "● " warn " warn  ")]
        [:> ink/Text {:color "red"}    (str "● " crit " crit")]
        [:> ink/Spacer]
        [:> ink/Text {:color "gray"} (str "t+" tick "s")]]

       ;; ── Column headers ─────────────────────────────────────────────
       [:> ink/Box {:paddingX 1}
        [:> ink/Text {:bold true :color "gray"} "  "]
        [:> ink/Text {:bold true :color "gray"} (pad-right "HOST" 10)]
        [:> ink/Text {:bold true :color "gray"} " STAT  "]
        [:> ink/Text {:bold true :color "gray"} (pad-left "CPU" 4)]
        [:> ink/Text {:bold true :color "gray"} (str " " (pad-right "" (+ bar-w 3)))]
        [:> ink/Text {:bold true :color "gray"} (pad-left "MEM" 4)]
        [:> ink/Text {:bold true :color "gray"} (str " " (pad-right "" (+ bar-w 3)))]
        [:> ink/Text {:bold true :color "gray"} "PROC"]
        [:> ink/Text {:bold true :color "gray"} (pad-right "  UPTIME" uptime-w)]]

       [:> ink/Box {:marginBottom 1}
        [:> ink/Text {:color "gray"} sep]]

       ;; ── Server rows ────────────────────────────────────────────────
       (into [:> ink/Box {:flexDirection "column"}]
             (map-indexed
              (fn [i s] ^{:key (:id s)} [ServerRow s (= i selected) bar-w uptime-w])
              servers))

       [:> ink/Spacer]

       ;; ── Footer ─────────────────────────────────────────────────────
       [:> ink/Box {:borderStyle "single" :borderColor "gray" :paddingX 1}
        [:> ink/Text {:color "gray"} "↑↓ navigate"]
        [:> ink/Text {:color "gray"} "   q quit"]]])
    (finally
      (js/clearInterval timer))))

(defn Base []
  (let [stdout (.-stdout (ink/useStdout))
        rows   (.-rows stdout)
        cols   (.-columns stdout)
        _      (ink/useInput
                (fn [input key]
                  (when (= input "q")
                    (js/process.exit 0))
                  (cond
                    (.-upArrow key)
                    (swap! server-state update :selected #(max 0 (dec %)))
                    (.-downArrow key)
                    (swap! server-state update :selected
                           #(min (dec (count (:servers @server-state))) (inc %))))))]
    (if (:splash @state)
      [:f> splash/Splash rows cols #(swap! state assoc :splash false)]
      [:f> App rows cols])))

(defn root []
  [:f> Base])

(defn run []
  (.write js/process.stdout "\u001b[?1049h\u001b[2J\u001b[H")
  (ink/render (r/as-element [root])))
