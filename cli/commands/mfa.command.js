import { execSync } from 'node:child_process';
import { loadSharedConfigFiles } from '@smithy/shared-ini-file-loader';
import { STSClient, GetSessionTokenCommand } from '@aws-sdk/client-sts';
import { input } from '@inquirer/prompts';

const SESSION_DURATION = 43200; // 12 hours in seconds
const DEFAULT_DATE = new Date('1970-01-01T00:00:00Z');

const stsClient = new STSClient({});

export default {
  command: 'mfa <profile>',
  describe: 'Authenticate using MFA device for AWS CLI Access.',
  builder: {
    profile: {
      type: 'string',
      desc: 'The AWS profile to authenticate',
      demand: true,
    },
  },
  handler: async (argv) => {
    await refreshTokenForProfileIfNeeded(argv.profile);
  },
};

async function getConfigFile() {
  const results = await loadSharedConfigFiles();
  return results;
}

async function getSession(mfaSerial, mfaCode) {
  try {
    const command = new GetSessionTokenCommand({
      TokenCode: mfaCode,
      SerialNumber: mfaSerial,
      DurationSeconds: SESSION_DURATION,
    });
    return await stsClient.send(command);
  } catch (error) {
    console.log('Unable to get session from STS');
    throw error;
  }
}

async function promptUserForToken(profile) {
  return await input({ message: `MFA Code for profile (${profile}): ` });
}

function hasSessionExpired(sessionExpirationStr) {
  const now = new Date();
  const sessionExpirationDate = new Date(sessionExpirationStr);
  return sessionExpirationDate < now;
}

async function refreshToken(profile, mfaSerial, mfaCode) {
  const session = await getSession(mfaSerial, mfaCode);
  const { AccessKeyId, Expiration, SecretAccessKey, SessionToken } = session.Credentials;
  const parsedExpiration = Expiration.toISOString();

  execSync(`aws configure set session_expiration ${parsedExpiration} --profile ${profile}`);
  execSync(`aws configure set aws_access_key_id ${AccessKeyId} --profile ${profile}`);
  execSync(`aws configure set aws_secret_access_key ${SecretAccessKey} --profile ${profile}`);
  execSync(`aws configure set aws_session_token ${SessionToken} --profile ${profile}`);

  console.log(`Token set successfully with expiration (${parsedExpiration}).`);
}

async function refreshTokenForProfileIfNeeded(profile) {
  const configFile = await getConfigFile();
  const sessionExpirationStr = configFile.configFile?.[profile]?.session_expiration ?? DEFAULT_DATE;
  const sessionExpired = hasSessionExpired(sessionExpirationStr);

  if (sessionExpired) {
    const mfaCode = await promptUserForToken(profile);
    const mfaSerial = configFile.credentialsFile?.[profile]?.mfa_serial ?? '';
    await refreshToken(profile, mfaSerial, mfaCode);
  } else {
    console.log(`Token is still valid with expiration (${sessionExpirationStr})`);
  }
}
