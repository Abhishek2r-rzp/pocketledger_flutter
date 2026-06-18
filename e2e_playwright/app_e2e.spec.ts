import { test, expect } from '@playwright/test';

const APP = 'http://localhost:8080';

test.describe('PocketLedger Visual Regression', () => {
  test('onboarding page 1 screenshot', async ({ page }) => {
    await page.goto(APP, { waitUntil: 'networkidle', timeout: 30000 });
    await page.waitForTimeout(5000);
    await expect(page).toHaveScreenshot('onboarding-page-1.png');
  });

  test('dashboard screenshot', async ({ page }) => {
    await page.goto(`${APP}/#/`, { waitUntil: 'networkidle', timeout: 30000 });
    await page.waitForTimeout(5000);
    await expect(page).toHaveScreenshot('dashboard.png');
  });

  test('transactions screenshot', async ({ page }) => {
    await page.goto(`${APP}/#/transactions`, { waitUntil: 'networkidle', timeout: 30000 });
    await page.waitForTimeout(5000);
    await expect(page).toHaveScreenshot('transactions-screen.png');
  });

  test('settings screenshot', async ({ page }) => {
    await page.goto(`${APP}/#/settings`, { waitUntil: 'networkidle', timeout: 30000 });
    await page.waitForTimeout(5000);
    await expect(page).toHaveScreenshot('settings-screen.png');
  });
});
