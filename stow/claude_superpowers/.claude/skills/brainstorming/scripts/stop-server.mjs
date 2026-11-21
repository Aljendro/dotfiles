#!/usr/bin/env node
// Stop the brainstorm server and clean up
// Usage: stop-server.mjs <session_dir>
//
// Kills the server process. Only deletes session directory if it's
// under /tmp (ephemeral). Persistent directories (.superpowers/) are
// kept so mockups can be reviewed later.

import fs from 'node:fs';
import path from 'node:path';
import { execFileSync } from 'node:child_process';
import { isMainModule } from './is-main.mjs';

const SERVER_ID_PATTERN = /^[A-Za-z0-9_-]{32,64}$/;

function statePaths(sessionDir) {
  const stateDir = path.join(sessionDir, 'state');
  return {
    stateDir,
    pidFile: path.join(stateDir, 'server.pid'),
    serverIdFile: path.join(stateDir, 'server-instance-id'),
    logFile: path.join(stateDir, 'server.log'),
    infoFile: path.join(stateDir, 'server-info'),
    stoppedFile: path.join(stateDir, 'server-stopped')
  };
}

function markStopped(paths, reason) {
  fs.rmSync(paths.infoFile, { force: true });
  fs.writeFileSync(paths.stoppedFile,
    JSON.stringify({ reason, timestamp: Math.floor(Date.now() / 1000) }) + '\n');
}

function readExpectedServerId(serverIdFile) {
  let id;
  try { id = fs.readFileSync(serverIdFile, 'utf-8').replace(/[\r\n]/g, ''); } catch (e) { return null; }
  return SERVER_ID_PATTERN.test(id) ? id : null;
}

// Argument list of a running process: exact argv from /proc on Linux,
// otherwise the space-joined command line from ps (macOS, BSD).
function commandArgsForPid(pid) {
  const procFile = '/proc/' + pid + '/cmdline';
  try {
    return fs.readFileSync(procFile, 'utf-8').split('\0').filter(Boolean);
  } catch (e) { /* no procfs */ }
  try {
    const line = execFileSync('ps', ['-ww', '-p', String(pid), '-o', 'command='], {
      encoding: 'utf-8', stdio: ['ignore', 'pipe', 'ignore']
    }).trim();
    return line ? line.split(/\s+/) : [];
  } catch (e) {
    return [];
  }
}

function commandHasServerId(args, expected) {
  return args.includes('--brainstorm-server-id=' + expected);
}

function isAlive(pid) {
  try { process.kill(pid, 0); return true; } catch (e) { return e.code === 'EPERM'; }
}

// Confirm a PID has this session's per-start instance id, not just a familiar
// process name. Ambiguous or legacy metadata fails closed as stale_pid.
function isBrainstormServer(pid, serverIdFile, { argsForPid = commandArgsForPid } = {}) {
  if (!Number.isInteger(pid) || pid <= 0 || !isAlive(pid)) return false;
  const expected = readExpectedServerId(serverIdFile);
  if (!expected) return false;
  return commandHasServerId(argsForPid(pid), expected);
}

// Only ephemeral /tmp sessions are deleted on stop.
function isEphemeralSessionDir(sessionDir) {
  return sessionDir.startsWith('/tmp/');
}

const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

function printJson(obj) {
  process.stdout.write(JSON.stringify(obj) + '\n');
}

async function main(argv = process.argv.slice(2)) {
  const sessionDir = argv[0];
  if (!sessionDir) {
    printJson({ error: 'Usage: stop-server.mjs <session_dir>' });
    return 1;
  }

  const paths = statePaths(sessionDir);
  if (!fs.existsSync(paths.pidFile)) {
    printJson({ status: 'not_running' });
    return 0;
  }

  const pid = Number(fs.readFileSync(paths.pidFile, 'utf-8').trim());

  // Refuse to signal a PID we can't prove is our server. A stale pid file may
  // point at an unrelated process after a reboot/PID wraparound.
  if (!isBrainstormServer(pid, paths.serverIdFile)) {
    fs.rmSync(paths.pidFile, { force: true });
    fs.rmSync(paths.serverIdFile, { force: true });
    markStopped(paths, 'stale_pid');
    printJson({ status: 'stale_pid' });
    return 0;
  }

  // Try to stop gracefully, fallback to force if still alive
  try { process.kill(pid, 'SIGTERM'); } catch (e) { /* already gone */ }

  // Wait for graceful shutdown (up to ~2s)
  for (let i = 0; i < 20 && isAlive(pid); i++) await sleep(100);

  // If still running, escalate to SIGKILL
  if (isAlive(pid)) {
    try { process.kill(pid, 'SIGKILL'); } catch (e) { /* already gone */ }
    // Give SIGKILL a moment to take effect
    await sleep(100);
  }

  if (isAlive(pid)) {
    printJson({ status: 'failed', error: 'process still running' });
    return 1;
  }

  fs.rmSync(paths.pidFile, { force: true });
  fs.rmSync(paths.serverIdFile, { force: true });
  fs.rmSync(paths.logFile, { force: true });
  markStopped(paths, 'stop-server.mjs');

  if (isEphemeralSessionDir(sessionDir)) {
    fs.rmSync(sessionDir, { recursive: true, force: true });
  }

  printJson({ status: 'stopped' });
  return 0;
}

if (isMainModule(import.meta.url)) {
  process.exitCode = await main();
}

export {
  statePaths,
  readExpectedServerId,
  commandArgsForPid,
  commandHasServerId,
  isBrainstormServer,
  isEphemeralSessionDir,
  main
};
