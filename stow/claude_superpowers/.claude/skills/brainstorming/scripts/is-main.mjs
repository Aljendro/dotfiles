import fs from 'node:fs';
import { fileURLToPath } from 'node:url';

// True when the module at moduleUrl is the script node was launched with.
// Compare real paths: stow installs this skill through symlinks, so argv[1]
// may not match the resolved module URL even when run directly.
export function isMainModule(moduleUrl, argv = process.argv) {
  if (!argv[1]) return false;
  try {
    return fs.realpathSync(argv[1]) === fs.realpathSync(fileURLToPath(moduleUrl));
  } catch (e) {
    return false;
  }
}
