import { describe, it, before, after } from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import http from 'node:http';
import os from 'node:os';
import path from 'node:path';
import { execFile } from 'node:child_process';
import { promisify } from 'node:util';
import {
  parseArgs,
  resolveUrlHost,
  idleTimeoutMs,
  isWindowsLike,
  shouldForeground,
  generateServerId,
  sessionPaths,
  UsageError
} from '../start-server.mjs';
import {
  statePaths,
  readExpectedServerId,
  commandArgsForPid,
  commandHasServerId,
  isBrainstormServer,
  isEphemeralSessionDir
} from '../stop-server.mjs';
import { listenSkip, psSkip } from './support.mjs';

const execFileAsync = promisify(execFile);
const SCRIPTS_DIR = path.join(import.meta.dirname, '..');

// Run a script and parse its single-line JSON output, regardless of exit code.
async function runScript(name, args) {
  try {
    const { stdout } = await execFileAsync(process.execPath, [path.join(SCRIPTS_DIR, name), ...args]);
    return { code: 0, json: JSON.parse(stdout.trim()) };
  } catch (e) {
    return { code: e.code, json: JSON.parse(e.stdout.trim()) };
  }
}

describe('start-server argument handling', () => {
  it('uses defaults with no arguments', () => {
    assert.deepEqual(parseArgs([]), {
      projectDir: '', foreground: false, forceBackground: false,
      bindHost: '127.0.0.1', urlHost: '', idleTimeoutMinutes: '', open: false
    });
  });

  it('parses every option and alias', () => {
    const opts = parseArgs([
      '--project-dir', '/p', '--host', '0.0.0.0', '--url-host', 'box',
      '--idle-timeout-minutes', '5', '--open', '--no-daemon', '--daemon'
    ]);
    assert.equal(opts.projectDir, '/p');
    assert.equal(opts.bindHost, '0.0.0.0');
    assert.equal(opts.urlHost, 'box');
    assert.equal(opts.idleTimeoutMinutes, '5');
    assert.ok(opts.open && opts.foreground && opts.forceBackground);
  });

  it('rejects unknown arguments and missing values', () => {
    assert.throws(() => parseArgs(['--bogus']), UsageError);
    assert.throws(() => parseArgs(['--host']), UsageError);
  });

  it('derives the URL host from the bind host', () => {
    assert.equal(resolveUrlHost('127.0.0.1', ''), 'localhost');
    assert.equal(resolveUrlHost('localhost', ''), 'localhost');
    assert.equal(resolveUrlHost('0.0.0.0', ''), '0.0.0.0');
    assert.equal(resolveUrlHost('0.0.0.0', 'box.local'), 'box.local');
  });

  it('validates the idle timeout', () => {
    assert.equal(idleTimeoutMs(''), null);
    assert.equal(idleTimeoutMs('2'), 120000);
    for (const bad of ['0', '-1', '1.5', 'abc']) assert.throws(() => idleTimeoutMs(bad), UsageError, bad);
  });

  it('detects Windows-like shells', () => {
    assert.ok(isWindowsLike({ platform: 'win32', env: {} }));
    assert.ok(isWindowsLike({ platform: 'linux', env: { MSYSTEM: 'MINGW64' } }));
    assert.ok(isWindowsLike({ platform: 'linux', env: { OSTYPE: 'msys' } }));
    assert.ok(!isWindowsLike({ platform: 'darwin', env: { OSTYPE: 'darwin25' } }));
  });

  it('auto-foregrounds under Codex CI and Windows unless --background is given', () => {
    const base = parseArgs([]);
    assert.equal(shouldForeground(base, { env: {}, windowsLike: false }), false);
    assert.equal(shouldForeground(base, { env: { CODEX_CI: '1' }, windowsLike: false }), true);
    assert.equal(shouldForeground(base, { env: {}, windowsLike: true }), true);
    assert.equal(shouldForeground(parseArgs(['--background']), { env: { CODEX_CI: '1' }, windowsLike: true }), false);
    assert.equal(shouldForeground(parseArgs(['--foreground', '--background']), { env: {}, windowsLike: false }), true);
  });

  it('generates server ids that stop-server accepts', () => {
    const id = generateServerId();
    assert.match(id, /^[A-Za-z0-9_-]{32,64}$/);
    assert.notEqual(id, generateServerId());
  });

  it('places sessions under the project or /tmp', () => {
    assert.deepEqual(sessionPaths('/proj', '1-2'), {
      sessionDir: '/proj/.superpowers/brainstorm/1-2',
      portFile: '/proj/.superpowers/brainstorm/.last-port',
      tokenFile: '/proj/.superpowers/brainstorm/.last-token'
    });
    assert.deepEqual(sessionPaths('', '1-2'), { sessionDir: '/tmp/brainstorm-1-2', portFile: null, tokenFile: null });
  });
});

describe('stop-server process verification', () => {
  let tmp;
  before(() => { tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'brainstorm-stop-')); });
  after(() => fs.rmSync(tmp, { recursive: true, force: true }));

  it('reads only well-formed server ids', () => {
    const file = path.join(tmp, 'id');
    fs.writeFileSync(file, 'a'.repeat(48) + '\r\n');
    assert.equal(readExpectedServerId(file), 'a'.repeat(48));
    fs.writeFileSync(file, 'short');
    assert.equal(readExpectedServerId(file), null);
    assert.equal(readExpectedServerId(path.join(tmp, 'missing')), null);
  });

  it('matches the exact server id argument', () => {
    const id = 'b'.repeat(48);
    assert.ok(commandHasServerId(['node', 'server.mjs', '--brainstorm-server-id=' + id], id));
    assert.ok(!commandHasServerId(['node', 'server.mjs', '--brainstorm-server-id=' + id + 'x'], id));
    assert.ok(!commandHasServerId(['node', 'server.mjs'], id));
  });

  it('reads the command line of a live process', { skip: process.platform !== 'linux' && psSkip }, () => {
    assert.ok(commandArgsForPid(process.pid).some(arg => arg.includes('node')));
  });

  it('refuses live processes without the matching id', () => {
    const file = path.join(tmp, 'id2');
    const id = 'c'.repeat(48);
    fs.writeFileSync(file, id + '\n');
    assert.ok(!isBrainstormServer(process.pid, file, { argsForPid: () => ['node', 'other.mjs'] }));
    assert.ok(isBrainstormServer(process.pid, file, { argsForPid: () => ['--brainstorm-server-id=' + id] }));
    assert.ok(!isBrainstormServer(0, file));
    assert.ok(!isBrainstormServer(NaN, file));
  });

  it('treats only /tmp sessions as ephemeral', () => {
    assert.ok(isEphemeralSessionDir('/tmp/brainstorm-1-2'));
    assert.ok(!isEphemeralSessionDir('/proj/.superpowers/brainstorm/1-2'));
    assert.ok(!isEphemeralSessionDir('/tmpfoo/x'));
  });

  it('prints usage without a session dir', async () => {
    const { code, json } = await runScript('stop-server.mjs', []);
    assert.equal(code, 1);
    assert.match(json.error, /Usage/);
  });

  it('reports not_running when there is no pid file', async () => {
    fs.mkdirSync(path.join(tmp, 'empty', 'state'), { recursive: true });
    assert.deepEqual((await runScript('stop-server.mjs', [path.join(tmp, 'empty')])).json, { status: 'not_running' });
  });

  it('marks a pid that is not our server as stale without signalling it', async () => {
    const sessionDir = path.join(tmp, 'stale');
    const paths = statePaths(sessionDir);
    fs.mkdirSync(paths.stateDir, { recursive: true });
    fs.writeFileSync(paths.pidFile, process.pid + '\n');
    fs.writeFileSync(paths.serverIdFile, 'd'.repeat(48) + '\n');

    assert.deepEqual((await runScript('stop-server.mjs', [sessionDir])).json, { status: 'stale_pid' });
    assert.ok(!fs.existsSync(paths.pidFile));
    assert.equal(JSON.parse(fs.readFileSync(paths.stoppedFile, 'utf-8')).reason, 'stale_pid');
  });
});

describe('start-server and stop-server end to end', () => {
  let projectDir;
  before(() => { projectDir = fs.mkdtempSync(path.join(os.tmpdir(), 'brainstorm-e2e-')); });
  after(() => fs.rmSync(projectDir, { recursive: true, force: true }));

  it('rejects bad arguments with a JSON error', async () => {
    const unknown = await runScript('start-server.mjs', ['--nope']);
    assert.equal(unknown.code, 1);
    assert.deepEqual(unknown.json, { error: 'Unknown argument: --nope' });

    const badIdle = await runScript('start-server.mjs', ['--idle-timeout-minutes', '0']);
    assert.equal(badIdle.code, 1);
    assert.match(badIdle.json.error, /positive integer/);
  });

  it('starts a background server, then stops it and keeps project files', { skip: listenSkip || psSkip }, async () => {
    const started = await runScript('start-server.mjs', ['--project-dir', projectDir, '--background']);
    assert.equal(started.code, 0, JSON.stringify(started.json));
    assert.equal(started.json.type, 'server-started');

    const sessionDir = path.dirname(started.json.state_dir);
    assert.equal(path.dirname(sessionDir), path.join(projectDir, '.superpowers', 'brainstorm'));

    const base = path.join(projectDir, '.superpowers', 'brainstorm');
    assert.equal(fs.readFileSync(path.join(base, '.last-port'), 'utf-8'), String(started.json.port));
    assert.equal(fs.statSync(path.join(base, '.last-token')).mode & 0o777, 0o600);

    const status = await new Promise((resolve, reject) => {
      http.get(started.json.url.replace('localhost', '127.0.0.1'), res => { res.resume(); resolve(res.statusCode); })
        .on('error', reject);
    });
    assert.equal(status, 200);

    const stopped = await runScript('stop-server.mjs', [sessionDir]);
    assert.deepEqual(stopped.json, { status: 'stopped' });
    assert.ok(fs.existsSync(path.join(sessionDir, 'content')));
    assert.equal(JSON.parse(fs.readFileSync(path.join(sessionDir, 'state', 'server-stopped'), 'utf-8')).reason,
      'stop-server.mjs');

    assert.deepEqual((await runScript('stop-server.mjs', [sessionDir])).json, { status: 'not_running' });
  });
});
