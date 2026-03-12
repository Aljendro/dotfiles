(ns aljendro.cli.commands.mfa
  (:require ["@aws-sdk/client-sts" :refer [STSClient GetSessionTokenCommand]]
            ["@smithy/shared-ini-file-loader" :refer [loadSharedConfigFiles]]
            ["@inquirer/prompts" :refer [input]]
            ["node:child_process" :refer [execSync]]
            [cljs.core.async :refer [go <!]]
            [cljs.core.async.interop :refer-macros [<p!]]))

(def ^:private session-duration 43200) ; 12 hours in seconds
(def ^:private default-date (js/Date. "1970-01-01T00:00:00Z"))
(def ^:private sts-client (STSClient. #js {}))

(defn- session-expired? [expiration-str]
  (< (js/Date. expiration-str) (js/Date.)))

(defn- get-session [mfa-serial mfa-code]
  (.send sts-client
         (GetSessionTokenCommand.
          #js {:TokenCode       mfa-code
               :SerialNumber    mfa-serial
               :DurationSeconds session-duration})))

(defn- prompt-for-token [profile]
  (input #js {:message (str "MFA Code for profile (" profile "): ")}))

(defn- refresh-token [profile mfa-serial mfa-code]
  (go
    (try
      (let [session (<p! (get-session mfa-serial mfa-code))
            creds   (.-Credentials session)
            key-id  (.-AccessKeyId creds)
            expiry  (.toISOString (.-Expiration creds))
            secret  (.-SecretAccessKey creds)
            token   (.-SessionToken creds)]
        (execSync (str "aws configure set session_expiration " expiry " --profile " profile))
        (execSync (str "aws configure set aws_access_key_id " key-id " --profile " profile))
        (execSync (str "aws configure set aws_secret_access_key " secret " --profile " profile))
        (execSync (str "aws configure set aws_session_token " token " --profile " profile))
        (println (str "Token set successfully with expiration (" expiry ").")))
      (catch js/Error e
        (println "Error refreshing token:" (.-message e))))))

(defn run [args]
  (let [profile (first args)]
    (when-not profile
      (println "Error: profile argument is required")
      (js/process.exit 1))
    (go
      (let [config         (<p! (loadSharedConfigFiles))
            profile-config (aget (.-configFile config) profile)
            expiration     (or (and profile-config (.-session_expiration profile-config))
                               default-date)]
        (if (session-expired? expiration)
          (let [mfa-code     (<p! (prompt-for-token profile))
                creds-config (aget (.-credentialsFile config) profile)
                mfa-serial   (or (and creds-config (.-mfa_serial creds-config)) "")]
            (<! (refresh-token profile mfa-serial mfa-code)))
          (println (str "Token is still valid with expiration (" expiration ")")))))))
