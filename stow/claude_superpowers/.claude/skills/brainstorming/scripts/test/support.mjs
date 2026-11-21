import net from 'node:net';
import { execFileSync } from 'node:child_process';

// Some sandboxes forbid binding local ports or running ps. Integration tests
// skip with this reason instead of timing out.
async function probeListen() {
  return new Promise(resolve => {
    const server = net.createServer();
    server.once('error', () => resolve(false));
    server.listen(0, '127.0.0.1', () => server.close(() => resolve(true)));
  });
}

function probePs() {
  try {
    execFileSync('ps', ['-o', 'pid=', '-p', String(process.pid)], { stdio: 'ignore' });
    return true;
  } catch (e) {
    return false;
  }
}

export const listenSkip = (await probeListen()) ? false : 'local port binding is not permitted here';
export const psSkip = probePs() ? false : 'ps is not available here';
