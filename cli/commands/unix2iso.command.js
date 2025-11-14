export default {
  command: 'unix2iso',
  describe: 'Converts 13-digit Unix timestamps in stdin to ISO 8601 format and outputs the result.',
  handler: async () => {
    const { createInterface } = await import('readline');

    const rl = createInterface({
      input: process.stdin,
      output: process.stdout,
      terminal: false,
    });

    rl.on('line', (inputLine) => {
      const timestampRegex = /\b\d{13}\b/g;
      const convertedLine = inputLine.replace(timestampRegex, (match) => {
        const dt = new Date(parseInt(match, 10));
        return !isNaN(dt) ? dt.toISOString() : 'Invalid date format';
      });
      console.log(convertedLine);
    });
  },
};
