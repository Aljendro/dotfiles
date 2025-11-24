import { readdir, stat } from 'fs/promises';
import { join, relative } from 'path';

/**
 * Loads all commands from the commands directory
 * @param {string} commandsDir The directory containing command files
 * @param {string} [suffix='.command.js'] The suffix for command files
 * @returns {Promise<Array>} Array of command objects
 */
export async function loadCommands(commandsDir, suffix = '.command.js') {
  const filepaths = await loadFilepaths(commandsDir, suffix);

  // Group commands by their parent directory
  const commandsByParent = new Map();

  for (const filepath of filepaths) {
    const commandModule = await import(`file://${filepath}`);
    const command = commandModule.default;

    if (command && typeof command === 'object') {
      // Calculate the command path from directory structure
      const relativePath = relative(commandsDir, filepath);
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

/**
 * Recursively loads all filenames from a directory
 * @param {string} dir Directory to scan for commands
 * @param {string} [suffix=''] The file suffix that we want to filter with
 * @returns {Promise<Array>} Array of command objects with their metadata
 */
export async function loadFilepaths(dir, suffix = '') {
  const filepaths = [];

  try {
    const entries = await readdir(dir);

    for (const entry of entries) {
      const fullPath = join(dir, entry);
      const stats = await stat(fullPath);

      if (stats.isDirectory()) {
        const subCommands = await loadFilepaths(fullPath, suffix);
        filepaths.push(...subCommands);
      } else if (entry.endsWith(suffix)) {
        filepaths.push(fullPath);
      }
    }
  } catch (error) {
    console.error(`Error loading commands from ${dir}:`, error.message);
  }

  return filepaths;
}
