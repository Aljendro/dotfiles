import { readFile, writeFile } from 'fs/promises';
import Handlebars from 'handlebars';

/**
 * Renders a handlebars template
 *
 * @param {string} fromFilepath The filepath to the handlebars template
 * @param {{toFilepath:string, data:object}} [options] Optional parameters
 */
export async function renderAt(fromFilepath, { toFilepath = '', data = {} }) {
  try {
    const templateContent = await readFile(fromFilepath, 'utf8');
    const template = Handlebars.compile(templateContent);
    const renderedData = template(data);
    try {
      await writeFile(toFilepath, renderedData, { flag: 'wx' });
    } catch (err) {
      if (err.code === 'EEXIST') {
        console.error('File already exists, not overwriting.');
      } else {
        throw err;
      }
    }
  } catch (error) {
    console.error(`Error rendering template from (${fromFilepath}) to (${toFilepath}): `, error);
    throw error;
  }
}

/**
 * Extract all the inputs necessary for a handlebars template
 *
 * @param {string} filepath The filepath to the handlebars template
 * @returns {Promise<string[]>} The list of strings paths (nested fields separated by '.')
 */
export async function extractInputs(filepath) {
  try {
    const templateContent = await readFile(filepath, 'utf8');
    const handlebarsAST = Handlebars.parseWithoutProcessing(templateContent);

    return handlebarsAST.body.filter((block) => block.type === 'MustacheStatement').map((block) => block.path.original);
  } catch (error) {
    console.error(`Error extracting variables from template (${filepath})`, error);
    throw error;
  }
}

/**
 * Extract all the inputs necessary for a handlebars template
 *
 * @param {string[]} filepaths The filepath to the handlebars template
 * @returns {Promise<string[]>} The list of strings paths (nested fields separated by '.')
 */
export async function extractAllInputs(filepaths) {
  return filepaths.map(extractInputs).flat();
}
