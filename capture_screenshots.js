const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox'],
  });

  const page = await browser.newPage();
  await page.setViewport({ width: 900, height: 1400, deviceScaleFactor: 1 });

  await page.goto('http://localhost:5054', { waitUntil: 'networkidle0', timeout: 120000 });
  await new Promise((resolve) => setTimeout(resolve, 8000));
  await page.screenshot({ path: 'screenshots/login.png', fullPage: true });

  for (const [filename, pageIndex] of [['cv.png', 0], ['famille.png', 1], ['contact.png', 2]]) {
    await page.goto(`http://localhost:5054/?demo=1&page=${pageIndex}`, { waitUntil: 'networkidle0', timeout: 120000 });
    await new Promise((resolve) => setTimeout(resolve, 8000));
    await page.screenshot({ path: `screenshots/${filename}`, fullPage: true });
  }

  await browser.close();
})();
