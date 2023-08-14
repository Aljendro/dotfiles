import { readFileSync } from 'fs';
import { PuppeteerRunnerExtension, createRunner } from '@puppeteer/replay';
import puppeteer from 'puppeteer-core';
import http from 'node:http';

const { CHROME_DEBUG_PORT } = process.env;

const chromeWSEndpoint = await (async () => {
  const debugURL = new URL(
    `http://127.0.0.1:${CHROME_DEBUG_PORT}/json/version`,
  );
  const response = await new Promise((resolve, reject) => {
    http
      .get(debugURL, (res) => {
        res.on('data', (d) => {
          resolve(JSON.parse(d));
        });
      })
      .on('error', (e) => {
        reject(e);
      });
  });
  return response.webSocketDebuggerUrl;
})();

const browser = await puppeteer.connect({
  browserWSEndpoint: chromeWSEndpoint,
  headless: false,
  slowMo: 100,
});

const page = await browser.newPage();

class Extension extends PuppeteerRunnerExtension {
  async beforeAllSteps(flow) {
    await super.beforeAllSteps(flow);
    console.log(JSON.stringify({ extensionAction: 'starting' }));
  }

  async beforeEachStep(step, flow) {
    await super.beforeEachStep(step, flow);
    step.extensionAction = 'before';
    console.log(JSON.stringify(step));
  }

  async afterEachStep(step, flow) {
    await super.afterEachStep(step, flow);
    step.extensionAction = 'after';
    console.log(JSON.stringify(step));
  }

  async afterAllSteps(flow) {
    await super.afterAllSteps(flow);
    console.log(JSON.stringify({ extensionAction: 'done' }));
  }
}

const runnerJson = readFileSync(process.argv[2], 'utf8');
const parsed = JSON.parse(runnerJson);

const runner = await createRunner(parsed, new Extension(browser, page, 7000));

await runner.run();

process.exit(0);
