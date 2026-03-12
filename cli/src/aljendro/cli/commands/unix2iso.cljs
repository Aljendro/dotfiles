(ns aljendro.cli.commands.unix2iso
  (:require ["readline" :as readline]))

(defn run []
  (let [rl (.createInterface
            readline
            #js {:input    js/process.stdin
                 :output   js/process.stdout
                 :terminal false})]
    (.on rl "line"
         (fn [line]
           (let [converted
                 (.replace line
                           (js/RegExp. "\\b\\d{13}\\b" "g")
                           (fn [match]
                             (let [dt (js/Date. (js/parseInt match 10))]
                               (if (js/isNaN (.getTime dt))
                                 "Invalid date format"
                                 (.toISOString dt)))))]
             (println converted))))))
