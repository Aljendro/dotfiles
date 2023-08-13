import { readFileSync } from 'fs';
import { PuppeteerRunnerExtension, createRunner } from '@puppeteer/replay';
import puppeteer from 'puppeteer-core';

const { CHROME_EXECUTABLE_PATH } = process.env;

const browser = await puppeteer.launch({
  headless: true,
  executablePath: CHROME_EXECUTABLE_PATH,
});

const page = await browser.newPage();

class Extension extends PuppeteerRunnerExtension {
  async beforeAllSteps(flow) {
    await super.beforeAllSteps(flow);
  }

  async beforeEachStep(step, flow) {
    await super.beforeEachStep(step, flow);
  }

  async afterEachStep(step, flow) {
    await super.afterEachStep(step, flow);
  }

  async afterAllSteps(flow) {
    await super.afterAllSteps(flow);
  }
}

// Get runner json from a file from input
const runnerJson = readFileSync(process.argv[2], 'utf8');

const runner = await createRunner(
  JSON.parse(runnerJson),
  new Extension(browser, page, 7000),
);

await runner.run();

await browser.close();
