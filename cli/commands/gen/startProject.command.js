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
    (await import('./startProject.js')).handler(argv);
  },
};
