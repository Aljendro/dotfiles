import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import {
  nextReconnectDelay,
  buildWebsocketUrl,
  buildRecoveryUrl,
  MIN_RECONNECT_MS,
  MAX_RECONNECT_MS,
  TOMBSTONE_AFTER_MS
} from '../helper.mjs';

describe('helper constants', () => {
  it('keeps the backoff bounds and tombstone delay ordered', () => {
    assert.ok(MIN_RECONNECT_MS > 0);
    assert.ok(MIN_RECONNECT_MS < TOMBSTONE_AFTER_MS);
    assert.ok(TOMBSTONE_AFTER_MS < MAX_RECONNECT_MS);
  });
});

describe('nextReconnectDelay', () => {
  it('doubles the current delay', () => {
    assert.equal(nextReconnectDelay(500, 30000), 1000);
    assert.equal(nextReconnectDelay(1000, 30000), 2000);
  });

  it('caps at the maximum', () => {
    assert.equal(nextReconnectDelay(20000, 30000), 30000);
    assert.equal(nextReconnectDelay(30000, 30000), 30000);
  });

  it('reaches the cap from the minimum in a bounded number of steps', () => {
    let delay = MIN_RECONNECT_MS;
    let steps = 0;
    while (delay < MAX_RECONNECT_MS) {
      delay = nextReconnectDelay(delay, MAX_RECONNECT_MS);
      steps++;
    }
    assert.equal(delay, MAX_RECONNECT_MS);
    assert.ok(steps <= 7);
  });
});

describe('buildWebsocketUrl', () => {
  it('uses the page host without a key', () => {
    assert.equal(buildWebsocketUrl('localhost:5000', null), 'ws://localhost:5000');
  });

  it('appends an encoded key', () => {
    assert.equal(buildWebsocketUrl('localhost:5000', 'a b&c'), 'ws://localhost:5000/?key=a%20b%26c');
  });
});

describe('buildRecoveryUrl', () => {
  it('builds the keyed bootstrap path', () => {
    assert.equal(buildRecoveryUrl('abc123'), '/?key=abc123');
    assert.equal(buildRecoveryUrl('x/y'), '/?key=x%2Fy');
  });
});

describe('browser init', () => {
  it('does not touch browser globals when imported in Node', () => {
    assert.equal(typeof globalThis.window, 'undefined');
    assert.equal(globalThis.brainstorm, undefined);
  });
});
