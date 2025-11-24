import path from 'path';
import fs from 'fs/promises';
import { renderAt } from '@aljendro/cli_utilities';

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
    const startProjectTemplate = path.join(DOTFILES_DIR, '/files/templates/general/start_project.txt');
    const ignoreTemplate = path.join(DOTFILES_DIR, '/files/templates/general/ignore.txt');

    /*
     * Ignore File
     */
    await renderAt(ignoreTemplate, {
      toFilepath: `${process.cwd()}/.ignore`,
      data: argv,
    });

    /*
     * Start project template
     */
    const startProjectTemplateToFilepath = `${process.cwd()}/start_project.local.sh`;
    await renderAt(startProjectTemplate, {
      toFilepath: startProjectTemplateToFilepath,
      data: argv,
    });
    await fs.chmod(startProjectTemplateToFilepath, '700');
  },
};
