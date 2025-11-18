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
    await writeFile(toFilepath, renderedData);
  } catch (error) {
    console.error(`Error rendering template from (${fromFilepath}) to (${toFilepath}): `, error);
    throw error;
  }
}

/**
 * Extract all the inputs necessary for a handlebars template
 *
 * @param {string} filepath The filepath to the handlebars template
 */
export async function extractInputs(filepath) {
  try {
    const templateContent = await readFile(filepath, 'utf8');
    const handlebarsAST = Handlebars.parseWithoutProcessing(templateContent);
    debugger;
    console.log('AST');
  } catch (error) {
    console.error(`Error extracting variables from template (${filepath})`, error);
    throw error;
  }
}
