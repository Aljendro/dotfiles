(ns aljendro.cli.utils.shell
  (:require
   ["child_process" :as child-process]
   ["node:process" :as process]
   ["node:readline/promises" :as readline]
   ["util" :as util]
   ;
   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PUBLIC UTILITIES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(declare sleep-promise sleep-sync exec-sync exec-promise)

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
                     (-> (sleep-promise delay-ms)
                         (.then #(exec! cmd {:retries  (dec retries)
                                             :delay-ms delay-ms
                                             :on-retry on-retry}))))
                   (js/Promise.reject
                    (str (or (.-message err) "") " "
                         (or (.-stderr err) "")))))))))

(defn exec-sync!
  ([cmd] (exec-sync! cmd nil))
  ([cmd {:keys [retries delay-ms on-retry]
         :or   {retries 0 delay-ms 0}}]
   (loop [n retries]
     (let [[tag result]
           (try
             [::ok (-> cmd
                       (exec-sync #js {:encoding "utf8" :stdio #js ["pipe" "pipe" "pipe"]})
                       str
                       .trim)]
             (catch :default err
               [::err err]))]
       (if (= ::ok tag)
         result
         (if (pos? n)
           (do
             (when on-retry (on-retry result n))
             (sleep-sync delay-ms)
             (recur (dec n)))
           (throw (js/Error. (str (or (.-message result) "") " "
                                  (or (.-stderr result) ""))))))))))

(defn exec-interactive!
  "Run a command handing it the real terminal. Blocks until it exits."
  [cmd]
  (child-process/spawnSync "bash" #js ["-c" cmd] #js {:stdio "inherit"}))

(defn ^:async get-user-input
  "Get input from the user in the terminal"
  [prompt]
  (let [rl (readline/createInterface
            #js {:input process/stdin
                 :output process/stdout})]
    (try
      (await (.question rl prompt))
      (finally
        (.close rl)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PRIVATE UTILITIES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def ^:private exec-sync (.-execSync child-process))

(def ^:private exec-promise (.promisify util (.-exec child-process)))

(defn- sleep-promise [ms]
  (js/Promise. (fn [resolve] (js/setTimeout resolve ms))))

(defn- sleep-sync [ms]
  (when (pos? ms)
    (.wait js/Atomics (js/Int32Array. (js/SharedArrayBuffer. 4)) 0 0 ms)))
