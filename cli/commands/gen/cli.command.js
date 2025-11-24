import path from 'path';
import fs from 'fs/promises';
import { renderAll } from '@aljendro/cli_utilities/handlebars';

const { DOTFILES_DIR } = process.env;

export default {
  command: 'cli',
  describe: 'Generates a cli for a new project.',
  handler: async () => {
    const pathPrefix = `${process.cwd()}/cli`;
    const renderings = [
      { fromFilePath: path.join(DOTFILES_DIR, 'files/templates/cli/bin_cli.txt'), toFilePath: `${pathPrefix}/bin/cli` },
      {
        fromFilePath: path.join(DOTFILES_DIR, 'files/templates/cli/eslint_config.txt'),
        toFilePath: `${pathPrefix}/.eslint.config.js`,
      },
      {
        fromFilePath: path.join(DOTFILES_DIR, 'files/templates/cli/gitignore.txt'),
        toFilePath: `${pathPrefix}/.gitignore`,
      },
      {
        fromFilePath: path.join(DOTFILES_DIR, 'files/templates/cli/package_json.txt'),
        toFilePath: `${pathPrefix}/package.json`,
      },
      {
        fromFilePath: path.join(DOTFILES_DIR, 'files/templates/cli/prettierignore.tx'),
        toFilePath: `${pathPrefix}/.prettierignore`,
      },
      {
        fromFilePath: path.join(DOTFILES_DIR, 'files/templates/cli/prettierrc.txt'),
        toFilePath: `${pathPrefix}/.prettierrc`,
      },
    ];

    await renderAll(renderings);
    await fs.mkdir(`${pathPrefix}/commands`, { recursive: true });
  },
};
