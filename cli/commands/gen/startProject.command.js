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
  handler: async () => {
    const handlebarsUtilities = await import('../../utils/handlebars.js');
    const path = await import('path');

    await handlebarsUtilities.extractInputs(
      path.join(process.env.DOTFILES_DIR, '/files/templates/general/start_project.txt'),
    );
  },
};
