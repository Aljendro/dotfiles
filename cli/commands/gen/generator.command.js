import path from 'path';
import { renderAt } from '@aljendro/cli_utilities/handlebars';

const { DOTFILES_DIR } = process.env;

export default {
  command: 'generator',
  describe: 'Create a new generator',
  builder: {
    name: {
      type: 'string',
      desc: 'The name of the generator',
      demand: true,
    },
    description: {
      type: 'string',
      desc: 'The description of generator',
      demand: true,
    },
  },
  handler: async (argv) => {
    await renderAt(
      path.join(DOTFILES_DIR, '/files/templates/gen/generator_command.txt'),
      path.join(DOTFILES_DIR, `/cli/commands/gen/${argv.name}.command.js`),
      argv,
    );
  },
};
