export default {
  command: 'gen',
  describe: 'Generate arbitrary change sets.',
  builder: {
    templateDir: {
      type: 'string',
      default: `${process.env.DOTFILES_DIR}/files/`,
    },
  },
  handler: async () => {
    // Read the templateDir directory to gather all the templates
    // If the user has not chosen a template, present choices with inquirer
    // If the user has not provided all the injection values, prompt them for each one with a inquirer
    // Generate files according to configuration json file
  },
};
