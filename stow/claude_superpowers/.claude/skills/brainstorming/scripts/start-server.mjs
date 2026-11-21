#!/usr/bin/env node
// Start the brainstorm server and output connection info
// Usage: start-server.mjs [--project-dir <path>] [--host <bind-host>] [--url-host <display-host>] [--foreground] [--background]
//
// Starts server on a random high port, outputs JSON with URL.
// Each session gets its own directory to avoid conflicts.
//
// Options:
//   --project-dir <path>  Store session files under <path>/.superpowers/brainstorm/
//                         instead of /tmp. Files persist after server stops.
//   --host <bind-host>    Host/interface to bind (default: 127.0.0.1).
//                         Use 0.0.0.0 in remote/containerized environments.
//   --url-host <host>     Hostname shown in returned URL JSON.
//   --idle-timeout-minutes <n>  Shut down after n minutes idle (default 240 = 4h).
//   --open                Auto-open the browser on the first screen (use only
//                         after the user approves the visual companion).
//   --foreground          Run server in the current terminal (no backgrounding).
//   --background          Force background mode (overrides Codex auto-foreground).

import crypto from 'node:crypto';
import fs from 'node:fs';
import path from 'node:path';
import { execFileSync, spawn } from 'node:child_process';
import { isMainModule } from './is-main.mjs';

const SCRIPT_DIR = import.meta.dirname;
const SERVER_SCRIPT = path.join(SCRIPT_DIR, 'server.mjs');

class UsageError extends Error {}

function parseArgs(argv) {
  const opts = {
    projectDir: '',
    foreground: false,
    forceBackground: false,
    bindHost: '127.0.0.1',
    urlHost: '',
    idleTimeoutMinutes: '',
    open: false
  };
  const takeValue = (i) => {
    if (i + 1 >= argv.length) throw new UsageError('Missing value for ' + argv[i]);
    return argv[i + 1];
  };
  for (let i = 0; i < argv.length; i++) {
    switch (argv[i]) {
      case '--project-dir': opts.projectDir = takeValue(i); i++; break;
      case '--host': opts.bindHost = takeValue(i); i++; break;
      case '--url-host': opts.urlHost = takeValue(i); i++; break;
      case '--idle-timeout-minutes': opts.idleTimeoutMinutes = takeValue(i); i++; break;
      case '--open': opts.open = true; break;
      case '--foreground':
      case '--no-daemon': opts.foreground = true; break;
      case '--background':
      case '--daemon': opts.forceBackground = true; break;
      default: throw new UsageError('Unknown argument: ' + argv[i]);
    }
  }
  return opts;
}

function resolveUrlHost(bindHost, urlHost) {
  if (urlHost) return urlHost;
  return bindHost === '127.0.0.1' || bindHost === 'localhost' ? 'localhost' : bindHost;
}

// Returns milliseconds, null when unset, or throws on a non-positive-integer value.
function idleTimeoutMs(minutes) {
  if (minutes === '') return null;
  if (!/^[0-9]+$/.test(minutes) || Number(minutes) < 1) {
    throw new UsageError('--idle-timeout-minutes must be a positive integer');
  }
  return Number(minutes) * 60 * 1000;
}

function isWindowsLike({ platform = process.platform, env = process.env } = {}) {
  if (platform === 'win32' || platform === 'cygwin') return true;
  if (/^(msys|cygwin|mingw)/.test(env.OSTYPE || '')) return true;
  return Boolean(env.MSYSTEM);
}

// Some environments reap detached/background processes. Auto-foreground when detected.
function shouldForeground(opts, { env = process.env, windowsLike = isWindowsLike({ env }) } = {}) {
  if (opts.foreground) return true;
  if (opts.forceBackground) return false;
  return Boolean(env.CODEX_CI) || windowsLike;
}

function generateServerId() {
  return crypto.randomBytes(24).toString('hex');
}

// Resolve the harness PID (grandparent of this script).
// process.ppid is the ephemeral shell the harness spawned to run us — it dies
// when this script exits. The harness itself is that shell's parent.
//
// Windows/MSYS2: Node.js cannot see POSIX PIDs from the MSYS2 namespace.
// Passing a PID node cannot verify causes server to log owner-pid-invalid
// and self-terminate at the 60-second lifecycle check. Leave it empty so the
// watchdog is disabled and the idle timeout becomes the only shutdown trigger.
function resolveOwnerPid({ ppid = process.ppid, windowsLike = isWindowsLike() } = {}) {
  if (windowsLike) return '';
  let grandparent = '';
  try {
    grandparent = execFileSync('ps', ['-o', 'ppid=', '-p', String(ppid)], {
      encoding: 'utf-8', stdio: ['ignore', 'pipe', 'ignore']
    }).trim();
  } catch (e) { /* ps unavailable or process gone */ }
  if (!grandparent || grandparent === '1') return String(ppid);
  return grandparent;
}

function sessionPaths(projectDir, sessionId) {
  if (projectDir) {
    const base = path.join(projectDir, '.superpowers', 'brainstorm');
    return {
      sessionDir: path.join(base, sessionId),
      // Persist the bound port and key per project so a restart reuses them and an
      // already-open browser tab reconnects to the same URL with a valid cookie.
      portFile: path.join(base, '.last-port'),
      tokenFile: path.join(base, '.last-token')
    };
  }
  return { sessionDir: '/tmp/brainstorm-' + sessionId, portFile: null, tokenFile: null };
}

function isAlive(pid) {
  try { process.kill(pid, 0); return true; } catch (e) { return e.code === 'EPERM'; }
}

const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

function firstServerStartedLine(logFile) {
  let log;
  try { log = fs.readFileSync(logFile, 'utf-8'); } catch (e) { return null; }
  return log.split('\n').find(line => line.includes('server-started')) || null;
}

function printJson(obj) {
  process.stdout.write(JSON.stringify(obj) + '\n');
}

async function main(argv = process.argv.slice(2)) {
  let opts, idleMs;
  try {
    opts = parseArgs(argv);
    idleMs = idleTimeoutMs(opts.idleTimeoutMinutes);
  } catch (e) {
    if (!(e instanceof UsageError)) throw e;
    printJson({ error: e.message });
    return 1;
  }

  const urlHost = resolveUrlHost(opts.bindHost, opts.urlHost);
  const foreground = shouldForeground(opts);

  // Session files (server.log, server-info, .last-token) embed the session key —
  // keep everything this script and the server create owner-only.
  process.umask(0o077);

  const sessionId = process.pid + '-' + Math.floor(Date.now() / 1000);

  let projectDir = '';
  if (opts.projectDir) {
    // Make the project dir absolute now so the server sees the same path no
    // matter its working directory. Creates a missing project dir.
    try {
      fs.mkdirSync(opts.projectDir, { recursive: true });
      projectDir = path.resolve(opts.projectDir);
      if (!fs.statSync(projectDir).isDirectory()) throw new Error('not a directory');
    } catch (e) {
      printJson({ error: 'Cannot create or enter --project-dir' });
      return 1;
    }
  }

  const { sessionDir, portFile, tokenFile } = sessionPaths(projectDir, sessionId);
  const stateDir = path.join(sessionDir, 'state');
  const pidFile = path.join(stateDir, 'server.pid');
  const logFile = path.join(stateDir, 'server.log');
  const serverIdFile = path.join(stateDir, 'server-instance-id');

  // Create fresh session directory with content and state peers
  fs.mkdirSync(path.join(sessionDir, 'content'), { recursive: true });
  fs.mkdirSync(stateDir, { recursive: true });

  const serverId = generateServerId();
  fs.writeFileSync(serverIdFile, serverId + '\n', { mode: 0o600 });

  // Kill any existing server
  if (fs.existsSync(pidFile)) {
    const oldPid = Number(fs.readFileSync(pidFile, 'utf-8').trim());
    try { if (oldPid) process.kill(oldPid); } catch (e) { /* already gone */ }
    fs.rmSync(pidFile, { force: true });
  }

  const env = {
    ...process.env,
    BRAINSTORM_DIR: sessionDir,
    BRAINSTORM_HOST: opts.bindHost,
    BRAINSTORM_URL_HOST: urlHost,
    BRAINSTORM_OWNER_PID: resolveOwnerPid()
  };
  if (portFile) env.BRAINSTORM_PORT_FILE = portFile;
  if (tokenFile) env.BRAINSTORM_TOKEN_FILE = tokenFile;
  if (idleMs !== null) env.BRAINSTORM_IDLE_TIMEOUT_MS = String(idleMs);
  if (opts.open) env.BRAINSTORM_OPEN = '1';

  const serverArgs = [SERVER_SCRIPT, '--brainstorm-server-id=' + serverId];

  // Foreground mode for environments that reap detached/background processes.
  if (foreground) {
    const child = spawn(process.execPath, serverArgs, { cwd: SCRIPT_DIR, env, stdio: 'inherit' });
    fs.writeFileSync(pidFile, child.pid + '\n');
    for (const sig of ['SIGINT', 'SIGTERM', 'SIGHUP']) {
      process.on(sig, () => { try { child.kill(sig); } catch (e) { /* gone */ } });
    }
    return new Promise(resolve => {
      child.on('exit', (code, signal) => resolve(code ?? (signal ? 1 : 0)));
    });
  }

  // Start server detached so it survives this script's exit, capturing output to the log file
  const logFd = fs.openSync(logFile, 'a', 0o600);
  const child = spawn(process.execPath, serverArgs, {
    cwd: SCRIPT_DIR, env, detached: true, stdio: ['ignore', logFd, logFd]
  });
  fs.closeSync(logFd);
  child.unref();
  const serverPid = child.pid;
  fs.writeFileSync(pidFile, serverPid + '\n');

  // Wait for server-started message (check log file)
  for (let i = 0; i < 50; i++) {
    const startedLine = firstServerStartedLine(logFile);
    if (startedLine) {
      // Verify server is still alive after a short window (catches process reapers)
      for (let j = 0; j < 20; j++) {
        if (!isAlive(serverPid)) {
          const retry = [path.join(SCRIPT_DIR, 'start-server.mjs')];
          if (projectDir) retry.push('--project-dir', projectDir);
          retry.push('--host', opts.bindHost, '--url-host', urlHost, '--foreground');
          printJson({ error: 'Server started but was killed. Retry in a persistent terminal with: node ' + retry.join(' ') });
          return 1;
        }
        await sleep(100);
      }
      process.stdout.write(startedLine + '\n');
      return 0;
    }
    await sleep(100);
  }

  // Timeout - server didn't start
  printJson({ error: 'Server failed to start within 5 seconds' });
  return 1;
}

if (isMainModule(import.meta.url)) {
  process.exitCode = await main();
}

export {
  parseArgs,
  resolveUrlHost,
  idleTimeoutMs,
  isWindowsLike,
  shouldForeground,
  generateServerId,
  resolveOwnerPid,
  sessionPaths,
  UsageError,
  main
};
