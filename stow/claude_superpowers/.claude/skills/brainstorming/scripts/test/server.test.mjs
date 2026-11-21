import { describe, it, before, after } from 'node:test';
import assert from 'node:assert/strict';
import crypto from 'node:crypto';
import fs from 'node:fs';
import http from 'node:http';
import os from 'node:os';
import path from 'node:path';
import { spawn } from 'node:child_process';
import { once } from 'node:events';
import {
  computeAcceptKey,
  encodeFrame,
  decodeFrame,
  browserLauncherForPlatform,
  isFullDocument,
  wrapInFrame,
  escapeHtmlText,
  urlHostForHttp,
  parseCookies,
  timingSafeEqualStr,
  pathnameOf,
  queryKey,
  securityHeaders,
  isAllowedWebSocketOrigin,
  OPCODES,
  MAX_FRAME_PAYLOAD_BYTES,
} from '../server.mjs';
import { listenSkip } from './support.mjs';

const SERVER_SCRIPT = path.join(import.meta.dirname, '..', 'server.mjs');

// Build a client->server frame (clients must mask their payloads).
function maskedFrame(opcode, payload, mask = crypto.randomBytes(4)) {
  const unmasked = encodeFrame(opcode, payload);
  const headerLen = unmasked.length - payload.length;
  const header = Buffer.from(unmasked.subarray(0, headerLen));
  header[1] |= 0x80;
  const data = Buffer.alloc(payload.length);
  for (let i = 0; i < payload.length; i++) data[i] = payload[i] ^ mask[i % 4];
  return Buffer.concat([header, mask, data]);
}

describe('WebSocket protocol', () => {
  it('computes the RFC 6455 sample accept key', () => {
    assert.equal(computeAcceptKey('dGhlIHNhbXBsZSBub25jZQ=='), 's3pPLMBiTxaQ9kYGzzhZRbK+xOo=');
  });

  for (const size of [0, 5, 125, 126, 65535, 65536]) {
    it(`round-trips a ${size}-byte masked frame`, () => {
      const payload = crypto.randomBytes(size);
      const frame = maskedFrame(OPCODES.TEXT, payload);
      const result = decodeFrame(frame);
      assert.equal(result.opcode, OPCODES.TEXT);
      assert.equal(result.bytesConsumed, frame.length);
      assert.ok(result.payload.equals(payload));
    });
  }

  it('uses the right length encoding for server frames', () => {
    assert.equal(encodeFrame(OPCODES.TEXT, Buffer.alloc(125))[1], 125);
    assert.equal(encodeFrame(OPCODES.TEXT, Buffer.alloc(126))[1], 126);
    assert.equal(encodeFrame(OPCODES.TEXT, Buffer.alloc(65536))[1], 127);
    assert.equal(encodeFrame(OPCODES.CLOSE, Buffer.alloc(0))[0], 0x80 | OPCODES.CLOSE);
  });

  it('returns null for incomplete frames', () => {
    const frame = maskedFrame(OPCODES.TEXT, Buffer.from('hello'));
    assert.equal(decodeFrame(frame.subarray(0, 1)), null);
    assert.equal(decodeFrame(frame.subarray(0, frame.length - 1)), null);
  });

  it('decodes only the first of two concatenated frames', () => {
    const a = maskedFrame(OPCODES.TEXT, Buffer.from('one'));
    const b = maskedFrame(OPCODES.PING, Buffer.from('two'));
    const result = decodeFrame(Buffer.concat([a, b]));
    assert.equal(result.payload.toString(), 'one');
    assert.equal(result.bytesConsumed, a.length);
  });

  it('rejects unmasked client frames', () => {
    assert.throws(() => decodeFrame(encodeFrame(OPCODES.TEXT, Buffer.from('x'))), /masked/);
  });

  it('rejects frames that declare an oversized payload', () => {
    const header = Buffer.alloc(14);
    header[0] = 0x80 | OPCODES.TEXT;
    header[1] = 0x80 | 127;
    header.writeBigUInt64BE(BigInt(MAX_FRAME_PAYLOAD_BYTES + 1), 2);
    assert.throws(() => decodeFrame(header), /exceeds maximum/);
  });
});

describe('browserLauncherForPlatform', () => {
  const url = 'http://localhost:1/?key=k';

  it('uses open on macOS', () => {
    assert.deepEqual(browserLauncherForPlatform(url, { platform: 'darwin', osRelease: '', env: {} }), {
      bin: 'open',
      args: [url],
    });
  });

  it('uses rundll32 on Windows and WSL', () => {
    const expected = { bin: 'rundll32.exe', args: ['url.dll,FileProtocolHandler', url] };
    assert.deepEqual(browserLauncherForPlatform(url, { platform: 'win32', osRelease: '', env: {} }), expected);
    assert.deepEqual(
      browserLauncherForPlatform(url, {
        platform: 'linux',
        osRelease: '5.15.0-microsoft-standard-WSL2',
        env: {},
      }),
      expected,
    );
  });

  it('uses xdg-open on Linux with a display and nothing when headless', () => {
    assert.deepEqual(browserLauncherForPlatform(url, { platform: 'linux', osRelease: '6.1', env: { DISPLAY: ':0' } }), {
      bin: 'xdg-open',
      args: [url],
    });
    assert.equal(browserLauncherForPlatform(url, { platform: 'linux', osRelease: '6.1', env: {} }), null);
  });
});

describe('HTML helpers', () => {
  it('detects full documents', () => {
    assert.ok(isFullDocument('  <!DOCTYPE html><html></html>'));
    assert.ok(isFullDocument('<HTML><body></body></HTML>'));
    assert.ok(!isFullDocument('<h2>Fragment</h2>'));
  });

  it('wraps fragments in the frame template without interpreting $ patterns', () => {
    const html = wrapInFrame('<p id="frag">cost: $& $1</p>');
    assert.ok(html.includes('<p id="frag">cost: $& $1</p>'));
    assert.ok(!html.includes('<!-- CONTENT -->'));
  });

  it('escapes HTML text', () => {
    assert.equal(escapeHtmlText('<a href="x">&</a>'), '&lt;a href=&quot;x&quot;&gt;&amp;&lt;/a&gt;');
  });

  it('brackets IPv6 hosts for URLs', () => {
    assert.equal(urlHostForHttp('localhost'), 'localhost');
    assert.equal(urlHostForHttp('::1'), '[::1]');
    assert.equal(urlHostForHttp('[::1]'), '[::1]');
  });
});

describe('request helpers', () => {
  it('parses cookies', () => {
    assert.deepEqual(parseCookies('a=1; b = two ;bad; c=x=y'), { a: '1', b: 'two', c: 'x=y' });
    assert.deepEqual(parseCookies(undefined), {});
  });

  it('compares strings in constant time', () => {
    assert.ok(timingSafeEqualStr('abc', 'abc'));
    assert.ok(!timingSafeEqualStr('abc', 'abd'));
    assert.ok(!timingSafeEqualStr('abc', 'abcd'));
  });

  it('splits pathname and key from a request URL', () => {
    assert.equal(pathnameOf('/files/x.png?key=1'), '/files/x.png');
    assert.equal(pathnameOf('/'), '/');
    assert.equal(queryKey('/?key=abc&x=1'), 'abc');
    assert.equal(queryKey('/'), null);
  });

  it('adds security headers that callers can extend', () => {
    const headers = securityHeaders({ 'Content-Type': 'text/plain' });
    assert.equal(headers['X-Frame-Options'], 'DENY');
    assert.equal(headers['Cache-Control'], 'no-store');
    assert.equal(headers['Content-Type'], 'text/plain');
  });

  it('allows only same-origin or origin-less WebSocket upgrades', () => {
    assert.ok(isAllowedWebSocketOrigin({ headers: { host: 'localhost:1' } }));
    assert.ok(isAllowedWebSocketOrigin({ headers: { host: 'localhost:1', origin: 'http://localhost:1' } }));
    assert.ok(!isAllowedWebSocketOrigin({ headers: { host: 'localhost:1', origin: 'http://evil.test' } }));
    assert.ok(!isAllowedWebSocketOrigin({ headers: { origin: 'http://localhost:1' } }));
  });
});

// ========== Running server ==========

function request(port, urlPath, headers = {}) {
  return new Promise((resolve, reject) => {
    const req = http.get({ host: '127.0.0.1', port, path: urlPath, headers }, (res) => {
      let body = '';
      res.setEncoding('utf-8');
      res.on('data', (chunk) => {
        body += chunk;
      });
      res.on('end', () => resolve({ status: res.statusCode, headers: res.headers, body }));
    });
    req.on('error', reject);
  });
}

function upgrade(port, urlPath, headers = {}) {
  return new Promise((resolve, reject) => {
    const req = http.request({
      host: '127.0.0.1',
      port,
      path: urlPath,
      headers: {
        Connection: 'Upgrade',
        Upgrade: 'websocket',
        'Sec-WebSocket-Version': '13',
        'Sec-WebSocket-Key': crypto.randomBytes(16).toString('base64'),
        ...headers,
      },
    });
    req.on('upgrade', (res, socket) => resolve({ res, socket }));
    req.on('response', (res) => reject(new Error('unexpected HTTP ' + res.statusCode)));
    req.on('error', reject);
    req.end();
  });
}

async function waitFor(predicate, timeoutMs = 3000) {
  const deadline = Date.now() + timeoutMs;
  while (Date.now() < deadline) {
    if (predicate()) return;
    await new Promise((r) => setTimeout(r, 25));
  }
  throw new Error('timed out waiting for condition');
}

describe('server process', { skip: listenSkip }, () => {
  let tmp,
    child,
    info,
    stdout = '';
  let cookie;

  before(async () => {
    tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'brainstorm-test-'));
    child = spawn(process.execPath, [SERVER_SCRIPT], {
      env: { ...process.env, BRAINSTORM_DIR: tmp, BRAINSTORM_OWNER_PID: '', BRAINSTORM_OPEN: '' },
      stdio: ['ignore', 'pipe', 'pipe'],
    });
    child.stdout.setEncoding('utf-8');
    child.stdout.on('data', (chunk) => {
      stdout += chunk;
    });
    await waitFor(() => stdout.includes('server-started'), 5000);
    info = JSON.parse(stdout.split('\n').find((l) => l.includes('server-started')));
    cookie = 'brainstorm-key-' + info.port + '=' + new URL(info.url).searchParams.get('key');
  });

  after(async () => {
    if (child && child.exitCode === null) {
      child.kill();
      await once(child, 'exit');
    }
    fs.rmSync(tmp, { recursive: true, force: true });
  });

  it('reports startup info and writes an owner-only server-info file', () => {
    assert.equal(info.host, '127.0.0.1');
    assert.equal(info.screen_dir, path.join(tmp, 'content'));
    assert.match(info.url, /^http:\/\/localhost:\d+\/\?key=[0-9a-f]{64}$/);
    const stat = fs.statSync(path.join(tmp, 'state', 'server-info'));
    assert.equal(stat.mode & 0o777, 0o600);
  });

  it('rejects requests without the key', async () => {
    const res = await request(info.port, '/');
    assert.equal(res.status, 403);
    assert.match(res.body, /Session key required/);
    assert.equal((await request(info.port, '/?key=wrong')).status, 403);
  });

  it('bootstraps with the key and sets the session cookie', async () => {
    const key = new URL(info.url).searchParams.get('key');
    const res = await request(info.port, '/?key=' + key);
    assert.equal(res.status, 200);
    assert.ok(res.body.includes("sessionStorage.setItem('brainstorm-session-key'"));
    assert.match(res.headers['set-cookie'][0], new RegExp('^' + cookie + '; HttpOnly; SameSite=Strict'));
  });

  it('serves the waiting page with the helper injected as a module', async () => {
    const res = await request(info.port, '/', { Cookie: cookie });
    assert.equal(res.status, 200);
    assert.match(res.body, /Waiting for the agent/);
    assert.ok(res.body.includes('<script type="module">'));
    assert.ok(res.body.includes('export function nextReconnectDelay'));
  });

  it('serves the newest screen, wrapping fragments in the frame', async () => {
    fs.writeFileSync(path.join(tmp, 'content', 'one.html'), '<h2 id="screen-one">One</h2>');
    const res = await request(info.port, '/', { Cookie: cookie });
    assert.ok(res.body.includes('<h2 id="screen-one">One</h2>'));
    assert.ok(res.body.includes('<script type="module">'));
    assert.ok(!res.body.includes('<!-- CONTENT -->'));
  });

  it('serves full documents as-is plus the helper', async () => {
    const doc = '<!DOCTYPE html><html><body><p>Full</p></body></html>';
    const file = path.join(tmp, 'content', 'two.html');
    fs.writeFileSync(file, doc);
    const future = new Date(Date.now() + 5000);
    fs.utimesSync(file, future, future);
    const res = await request(info.port, '/', { Cookie: cookie });
    assert.ok(res.body.startsWith('<!DOCTYPE html><html><body><p>Full</p>'));
    assert.ok(res.body.includes('<script type="module">'));
  });

  it('serves content files and blocks dotfiles, directories, and symlinks', async () => {
    fs.writeFileSync(path.join(tmp, 'content', 'pic.svg'), '<svg/>');
    fs.writeFileSync(path.join(tmp, 'content', '.hidden.txt'), 'secret');
    fs.writeFileSync(path.join(tmp, 'outside.txt'), 'secret');
    fs.symlinkSync(path.join(tmp, 'outside.txt'), path.join(tmp, 'content', 'link.txt'));

    const ok = await request(info.port, '/files/pic.svg', { Cookie: cookie });
    assert.equal(ok.status, 200);
    assert.equal(ok.headers['content-type'], 'image/svg+xml');

    for (const p of ['/files/', '/files/.hidden.txt', '/files/link.txt', '/files/..%2Foutside.txt', '/nope']) {
      assert.equal((await request(info.port, p, { Cookie: cookie })).status, 404, p);
    }
  });

  it('refuses WebSocket upgrades without the key or from another origin', async () => {
    await assert.rejects(upgrade(info.port, '/'));
    await assert.rejects(upgrade(info.port, '/', { Cookie: cookie, Origin: 'http://evil.test' }));
  });

  it('records choice events from the WebSocket and answers pings', async () => {
    const { res, socket } = await upgrade(info.port, '/', { Cookie: cookie });
    assert.equal(res.statusCode, 101);

    const received = [];
    socket.on('data', (chunk) => received.push(chunk));

    socket.write(maskedFrame(OPCODES.PING, Buffer.from('hi')));
    socket.write(maskedFrame(OPCODES.TEXT, Buffer.from(JSON.stringify({ type: 'click', choice: 'a' }))));

    const eventsFile = path.join(tmp, 'state', 'events');
    await waitFor(() => fs.existsSync(eventsFile));
    assert.deepEqual(JSON.parse(fs.readFileSync(eventsFile, 'utf-8').trim()), { type: 'click', choice: 'a' });
    await waitFor(() => Buffer.concat(received).length >= 4);
    const pong = Buffer.concat(received);
    assert.equal(pong[0], 0x80 | OPCODES.PONG);
    assert.equal(pong.subarray(2, 4).toString(), 'hi');

    socket.destroy();
  });

  it('broadcasts a reload when a new screen is added', async () => {
    const { socket } = await upgrade(info.port, '/', { Cookie: cookie });
    const received = [];
    socket.on('data', (chunk) => received.push(chunk));

    fs.writeFileSync(path.join(tmp, 'content', 'three.html'), '<p>Three</p>');
    await waitFor(() => Buffer.concat(received).toString().includes('"reload"'));
    await waitFor(() => stdout.includes('"screen-added"') && stdout.includes('three.html'));

    socket.destroy();
  });
});
