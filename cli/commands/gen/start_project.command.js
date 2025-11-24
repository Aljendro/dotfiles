import path from 'path';
import fs from 'fs/promises';
import { renderAt } from '@aljendro/cli_utilities/handlebars';

const { DOTFILES_DIR } = process.env;

export default {
  command: 'start_project',
  describe: 'Create a startup project file',
  builder: {
    name: {
      type: 'string',
      desc: 'The name of the project identifier',
      demand: true,
    },
  },
  handler: async (argv) => {
    /*
     * Ignore File
     */
    await renderAt(path.join(DOTFILES_DIR, '/files/templates/general/ignore.txt'), `${process.cwd()}/.ignore`, argv);

    /*
     * Start project template
     */
    const startProjectTemplateToFilepath = `${process.cwd()}/start_project.local.sh`;
    await renderAt(
      path.join(DOTFILES_DIR, '/files/templates/general/start_project.txt'),
      startProjectTemplateToFilepath,
      argv,
    );
    await fs.chmod(startProjectTemplateToFilepath, '700');
  },
};
