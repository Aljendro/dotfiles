(ns mfa-aws
  (:require
   ["@aws-sdk/client-sts" :refer [STS]]
   ["@aws-sdk/shared-ini-file-loader" :as aws-file-loader]
   ["node:child_process" :refer [execSync]]
   [clojure.string :refer [blank?]]
   [preload :refer [get-readline prompt with-open]]
   [promesa.core :as p]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Constants
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def session-duration 43200) ; 12 hours in seconds
(def default-date (js/Date. "1970-01-01T00:00:00Z"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helper Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def sts-client (STS.))

(defn get-config-file
  "Read the aws profiles ~/.aws/{config,credentials} files"
  []
  #_{:clj-kondo/ignore [:unresolved-symbol]}
  (p/let [results (.loadSharedConfigFiles aws-file-loader)]
    (js->clj results)))

(defn get-mfa-serial
  "Read the mfa serial arn for the profile provided"
  [config-file profile]
  (get-in config-file ["credentialsFile" profile "mfa_serial"]))

(defn get-session
  "Get a temporary session from aws sts"
  [mfa-serial mfa-code]
  #_{:clj-kondo/ignore [:unresolved-symbol]}
  (->
   (p/let [results (.getSessionToken
                    sts-client
                    #js {"TokenCode" mfa-code
                         "SerialNumber" mfa-serial
                         "DurationSeconds" session-duration})]
     (js->clj results))
   (.catch (fn [error]
             (println "Unable to get session from sts")
             (throw error)))))

(defn prompt-user-for-token
  "Prompt a user for an mfa code"
  [profile]
  #_{:clj-kondo/ignore [:unresolved-symbol]}
  (with-open [rl (get-readline)]
    (prompt rl (str "MFA Code for profile (" profile "): "))))

(defn has-session-expired? [session-expiration-str]
  (let [now (js/Date.)
        session-expiration-date (js/Date. session-expiration-str)]
    (< session-expiration-date now)))

(defn refresh-token [profile mfa-serial mfa-code]
  #_{:clj-kondo/ignore [:unresolved-symbol]}
  (p/let [session (get-session mfa-serial mfa-code)
          {AccessKeyId "AccessKeyId"
           Expiration "Expiration"
           SecretAccessKey "SecretAccessKey"
           SessionToken "SessionToken"} (get-in session ["Credentials"])
          parsed-expiration (.toISOString Expiration)]
    (execSync (str "aws configure set session_expiration " parsed-expiration " --profile " profile))
    (execSync (str "aws configure set aws_access_key_id  " AccessKeyId " --profile " profile))
    (execSync (str "aws configure set aws_secret_access_key " SecretAccessKey " --profile " profile))
    (execSync (str "aws configure set aws_session_token " SessionToken " --profile " profile))
    (println (str "Token set successfully with expiration (" parsed-expiration ")."))))

(defn refresh-token-for-profile-if-needed [profile]
  #_{:clj-kondo/ignore [:unresolved-symbol]}
  (p/let [config-file (get-config-file)
          session-expiration-str (get-in config-file ["configFile" profile "session_expiration"] default-date)
          session-expired? (has-session-expired? session-expiration-str)]
    (if session-expired?
      (p/let [mfa-code (prompt-user-for-token profile)
              mfa-serial (get-in config-file ["credentialsFile" profile "mfa_serial"] "")]
        (refresh-token profile mfa-serial mfa-code))
      (println (str "Token is still valid with expiration (" session-expiration-str ")")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn -main []
  (let [profile (get js/process.argv 4)]
    (if (blank? profile)
      (do
        (println "Usage: mfa_aws <aws_profile>")
        (println "Authenticate using MFA device for AWS CLI Access.\n"))
      (refresh-token-for-profile-if-needed profile))))

