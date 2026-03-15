(ns aljendro.cli.commands.mfa
  (:require ["@aws-sdk/client-sts" :refer [STSClient GetSessionTokenCommand]]
            ["@smithy/shared-ini-file-loader" :refer [loadSharedConfigFiles]]
            ["@inquirer/prompts" :refer [input]]
            ["node:child_process" :refer [execSync]]
            [cljs.core.async :refer [<!]]
            [cljs.core.async.interop :refer-macros [<p!]]
            [aljendro.cli.utils.common :refer-macros [adefn adefn-]]))

(def ^:private session-duration 43200) ; 12 hours in seconds
(def ^:private default-date (js/Date. "1970-01-01T00:00:00Z"))
(def ^:private sts-client (STSClient. #js {}))

(defn- session-expired? [expiration-str]
  (< (js/Date. expiration-str) (js/Date.)))

(adefn- get-session [mfa-serial mfa-code]
  (try
    (<p! (.send sts-client
                (GetSessionTokenCommand.
                 #js {:TokenCode       mfa-code
                      :SerialNumber    mfa-serial
                      :DurationSeconds session-duration})))
    (catch js/Error e
      (println "ERROR: Unable to get session token:" (.-message e))
      (js/process.exit 1))))

(adefn- prompt-for-token [profile]
  (try
    (<p! (input #js {:message (str "MFA Code for profile (" profile "): ")}))
    (catch js/Error _
      (println "INFO: Input was closed")
      (js/process.exit 1))))

(adefn- refresh-token [profile mfa-serial mfa-code]
  (try
    (let [session (<! (get-session mfa-serial mfa-code))
          creds   (.-Credentials session)
          key-id  (.-AccessKeyId creds)
          expiry  (.toISOString (.-Expiration creds))
          secret  (.-SecretAccessKey creds)
          token   (.-SessionToken creds)]
      (execSync (str "aws configure set session_expiration " expiry " --profile " profile))
      (execSync (str "aws configure set aws_access_key_id " key-id " --profile " profile))
      (execSync (str "aws configure set aws_secret_access_key " secret " --profile " profile))
      (execSync (str "aws configure set aws_session_token " token " --profile " profile))
      (println (str "INFO: Token set successfully with expiration (" expiry ").")))
    (catch js/Error e
      (println "ERROR: unable to refresh token:" (.-message e)))))

(adefn run [args]
  (let [profile (first args)]
    (when-not profile
      (println "ERROR: profile argument is required")
      (js/process.exit 1))
    (let [config         (<p! (loadSharedConfigFiles))
          profile-config (aget (.-configFile config) profile)
          expiration     (or (and profile-config (.-session_expiration profile-config)) default-date)]
      (if (session-expired? expiration)
        (let [mfa-code     (<! (prompt-for-token profile))
              creds-config (aget (.-credentialsFile config) profile)
              mfa-serial   (or (and creds-config (.-mfa_serial creds-config)) "")]
          (<! (refresh-token profile mfa-serial mfa-code)))
        (println (str "INFO: Token is still valid with expiration (" expiration ")"))))))


