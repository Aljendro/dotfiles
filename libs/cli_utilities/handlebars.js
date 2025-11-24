import { readFile, writeFile } from 'fs/promises';
import has from 'lodash/has.js';
import Handlebars from 'handlebars';

/**
 * Renders a set of handlebars templates
 *
 * @param {{fromFilepath:string, toFilepath:string}[]} Array of objects specifying the templates location and rendered path
 * @param {object} data The data that is used by the templating engine
 */
export async function renderAll(specifications, data = {}) {
  for (const s of specifications) {
    await renderAt(s.fromFilepath, s.toFilepath, data);
  }
}

/**
 * Renders a handlebars template
 *
 * @param {string} fromFilepath The filepath to the handlebars template
 * @param {string} toFilepath The generated filepath after the render
 * @param {object} data The data that is used by the templating engine
 */
export async function renderAt(fromFilepath, toFilepath,  data = {} ) {
  try {
    await validateData(fromFilepath, data);
    const templateContent = await readFile(fromFilepath, 'utf8');
    const template = Handlebars.compile(templateContent);
    const renderedData = template(data);
    try {
      await writeFile(toFilepath, renderedData, { flag: 'wx' });
    } catch (err) {
      if (err.code === 'EEXIST') {
        console.error(`File (${toFilepath}) already exists, not overwriting.`);
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
 * Checks that all the inputs are defined in the data
 */
export async function validateData(filepath, data = {}) {
  const parameters = await extractTemplateParameters(filepath);
  for (const p of parameters) {
    if (!has(data, p)) {
      throw new Error(`The input ${JSON.stringify(data)} does not contain "${p}" for the template at ${filepath}`);
    }
  }
}

/**
 * Extract all the inputs necessary for a handlebars template
 *
 * @param {string} filepath The filepath to the handlebars template
 * @returns {Promise<string[]>} The list of strings paths (nested fields separated by '.')
 */
export async function extractTemplateParameters(filepath) {
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
export async function extractAllTemplateParameters(filepaths) {
  return filepaths.map(extractTemplateParameters).flat();
}
