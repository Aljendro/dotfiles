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
    (await import('./generator.js')).handler(argv);
  },
};
