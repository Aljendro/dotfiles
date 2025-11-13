export default {
  command: 'now',
  describe: 'Prints the current ISO 8601 timestamp.',
  handler: () => console.log(new Date().toISOString()),
};
