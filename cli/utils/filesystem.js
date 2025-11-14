import { join } from 'path';
import { readdir, stat } from 'fs/promises';

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
