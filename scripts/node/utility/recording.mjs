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

export const browser = await puppeteer.connect({
  browserWSEndpoint: chromeWSEndpoint,
  headless: false,
  slowMo: 50,
});

