import path from 'path';
import fs from 'fs/promises';
import { renderAll } from '@aljendro/cli_utilities/handlebars';

const { DOTFILES_DIR } = process.env;

export default {
  command: 'cli',
  describe: 'Generates a cli for a new project.',
  builder: {
    name: {
      type: 'string',
      desc: 'The name prefix of the cli command',
      demand: true,
    },
  },
  handler: async (argv) => {
    const pathPrefix = `${process.cwd()}/cli`;
    const renderings = [
      { fromFilepath: path.join(DOTFILES_DIR, 'files/templates/cli/bin_cli.txt'), toFilepath: `${pathPrefix}/bin/cli` },
      {
        fromFilepath: path.join(DOTFILES_DIR, 'files/templates/cli/eslint_config.txt'),
        toFilepath: `${pathPrefix}/.eslint.config.js`,
      },
      {
        fromFilepath: path.join(DOTFILES_DIR, 'files/templates/cli/gitignore.txt'),
        toFilepath: `${pathPrefix}/.gitignore`,
      },
      {
        fromFilepath: path.join(DOTFILES_DIR, 'files/templates/cli/package_json.txt'),
        toFilepath: `${pathPrefix}/package.json`,
      },
      {
        fromFilepath: path.join(DOTFILES_DIR, 'files/templates/cli/prettierignore.txt'),
        toFilepath: `${pathPrefix}/.prettierignore`,
      },
      {
        fromFilepath: path.join(DOTFILES_DIR, 'files/templates/cli/prettierrc.txt'),
        toFilepath: `${pathPrefix}/.prettierrc`,
      },
    ];

    await renderAll(renderings, argv);
    await fs.mkdir(`${pathPrefix}/commands`, { recursive: true });
  },
};
