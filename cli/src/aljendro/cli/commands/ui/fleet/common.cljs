(ns aljendro.cli.commands.ui.fleet.common
  (:require
   ["child_process" :as child-process]
   ["util" :as util]
   ;
   ))

(def exec-promise (.promisify util (.-exec child-process)))

(defn- sleep [ms]
  (js/Promise. (fn [resolve] (js/setTimeout resolve ms))))

(defn exec!
  ([cmd] (exec! cmd nil))
  ([cmd {:keys [retries delay-ms on-retry]
         :or   {retries 0 delay-ms 0}}]
   (-> (exec-promise cmd)
       (.then #(.trim (str (.-stdout %))))
       (.catch (fn [err]
                 (if (pos? retries)
                   (do
                     (when on-retry (on-retry err retries))
                     (-> (sleep delay-ms)
                         (.then #(exec! cmd {:retries  (dec retries)
                                             :delay-ms delay-ms
                                             :on-retry on-retry}))))
                   (js/Promise.reject
                    (str (or (.-message err) "") " "
                         (or (.-stderr err) "")))))))))

