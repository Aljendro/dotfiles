import path from 'path';
import pick from 'lodash/pick.js';
import * as handlebarsUtilities from '../../utils/handlebars.js';

const { DOTFILES_DIR } = process.env;

/**
 * startProject handler
 */
export async function handler(argv) {
  const generatorCommandTemplate = path.join(DOTFILES_DIR, '/files/templates/gen/generator_command.txt');
  const genratorHandlerTemplate = path.join(DOTFILES_DIR, '/files/templates/gen/generator_handler.txt');

  /*
   * generatorCommandTemplate
   */
  await handlebarsUtilities.renderAt(generatorCommandTemplate, {
    toFilepath: `${DOTFILES_DIR}/cli/commands/gen/${argv.name}.command.js`,
    data: argv,
  });

  /*
   * generatorCommandTemplate
   */
  await handlebarsUtilities.renderAt(genratorHandlerTemplate, {
    toFilepath: `${DOTFILES_DIR}/cli/commands/gen/${argv.name}.js`,
    data: argv,
  });
}
