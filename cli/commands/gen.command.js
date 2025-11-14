import { loadFilepaths } from '../utils/filesystem.js';

export default {
  command: 'gen',
  describe: 'Generate arbitrary change sets.',
  builder: {
    directoryPath: {
      type: 'string',
      default: `${process.env.DOTFILES_DIR}/files/`,
    },
  },
  handler: async (argv) => {
    const generators = await loadFilepaths(`${argv.directoryPath}/generators`, '.edn');

    console.log(generators);

    // Read the templateDir directory to gather all the templates
    // If the user has not chosen a template, present choices with inquirer
    // If the user has not provided all the injection values, prompt them for each one with a inquirer
    // Generate files according to configuration json file
  },
};

/**
 * Recursively loads all generator modules from a directory
 * @param {string} dir - Directory to scan for commands
 * @param {string} baseDir - Base directory for calculating relative paths
 * @returns {Promise<Array>} Array of command objects with their metadata
 */
async function loadCommandsFromDirectory(dir, baseDir = dir) {
  const commands = [];

  try {
    const entries = await readdir(dir);

    for (const entry of entries) {
      const fullPath = join(dir, entry);
      const stats = await stat(fullPath);

      if (stats.isDirectory()) {
        // Recursively load commands from subdirectories
        const subCommands = await loadCommandsFromDirectory(fullPath, baseDir);
        commands.push(...subCommands);
      } else if (entry.endsWith('.js')) {
        // Import the command module
        const commandModule = await import(`file://${fullPath}`);
        const command = commandModule.default;

        if (command && typeof command === 'object') {
          // Calculate the command path from directory structure
          const relativePath = relative(baseDir, fullPath);
          const pathParts = relativePath
            .replace(/\.js$/, '')
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
    }
  } catch (error) {
    console.error(`Error loading commands from ${dir}:`, error.message);
  }

  return commands;
}

/**
 * Loads all commands from the commands directory
 * @returns {Promise<Array>} Array of command objects
 */
export async function loadCommands() {
  const commandsDir = join(__dirname, '../commands');
  return await loadCommandsFromDirectory(commandsDir);
}
