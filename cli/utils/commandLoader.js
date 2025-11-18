import { fileURLToPath } from 'url';
import { dirname, join, relative } from 'path';
import { loadFilepaths } from './filesystem.js';

/**
 * Loads all commands from the commands directory
 * @returns {Promise<Array>} Array of command objects
 */
export async function loadCommands() {
  const __filename = fileURLToPath(import.meta.url);
  const __dirname = dirname(__filename);
  const suffix = '.command.js';

  const topLevelCommandsDir = join(__dirname, '../commands');
  const filepaths = await loadFilepaths(topLevelCommandsDir, suffix);

  // Group commands by their parent directory
  const commandsByParent = new Map();

  for (const filepath of filepaths) {
    const commandModule = await import(`file://${filepath}`);
    const command = commandModule.default;

    if (command && typeof command === 'object') {
      // Calculate the command path from directory structure
      const relativePath = relative(topLevelCommandsDir, filepath);
      const pathParts = relativePath
        .replace(new RegExp(`${suffix}$`), '')
        .split('/')
        .filter((part) => part !== '.');

      // Determine if this is a top-level or nested command
      if (pathParts.length === 1) {
        // Top-level command - add directly
        if (!commandsByParent.has('_root')) {
          commandsByParent.set('_root', []);
        }
        commandsByParent.get('_root').push(command);
      } else {
        // Nested command - group by parent directory
        const parentKey = pathParts.slice(0, -1).join('/');
        if (!commandsByParent.has(parentKey)) {
          commandsByParent.set(parentKey, []);
        }
        commandsByParent.get(parentKey).push(command);
      }
    }
  }

  // Build the final command list
  const commands = [];

  // Add top-level commands
  if (commandsByParent.has('_root')) {
    commands.push(...commandsByParent.get('_root'));
  }

  // Create parent commands for nested subcommands
  for (const [parentKey, subcommands] of commandsByParent.entries()) {
    if (parentKey === '_root') continue;

    const parentCommandName = parentKey.split('/').join(' ');
    const parentCommand = {
      command: `${parentCommandName} <subcommand>`,
      describe: `${parentCommandName} commands`,
      builder: (yargs) => {
        for (const subcommand of subcommands) {
          yargs.command(subcommand);
        }
        return yargs;
      },
      handler: () => {
        // This will be handled by subcommands
      },
    };

    commands.push(parentCommand);
  }

  return commands;
}
