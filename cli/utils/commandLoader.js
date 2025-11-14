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

  const commands = [];
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

      // If nested, prefix the command with the directory path
      if (pathParts.length > 1) {
        const prefix = pathParts.slice(0, -1).join(' ');
        const originalCommand = command.command;

        // Modify the command to include the directory prefix
        command.command = `${prefix} ${originalCommand}`;
      }

      commands.push(command);
    }
  }

  return commands;
}
