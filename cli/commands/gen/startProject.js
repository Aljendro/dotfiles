import path from 'path';
import fs from 'fs/promises';
import { pick } from 'lodash';
import handlebarsUtilities from '../../utils/handlebars.js';

const { DOTFILES_DIR } = process.env;

/**
 * startProject handler
 */
export async function handler(argv) {
  const start_project_template = path.join(DOTFILES_DIR, '/files/templates/general/start_project.txt');

  const data = pick(argv, ['name']);
  await handlebarsUtilities.renderAt(start_project_template, {
    toFilepath: `${process.cwd()}/start_project.sh`,
    data,
  });

  await fs.chmod(`${process.cwd()}/start_project.sh`, '+x');
}
