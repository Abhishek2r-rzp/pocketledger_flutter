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

  test('glass bottom navigation mobile journey', async ({ page }) => {
    await page.goto(`${APP}/#/`, { waitUntil: 'networkidle', timeout: 30000 });
    await page.waitForTimeout(5000);
    await expect(page).toHaveScreenshot('mobile-home-bottom-nav.png');

    await page.goto(`${APP}/#/transactions`, { waitUntil: 'networkidle', timeout: 30000 });
    await page.waitForTimeout(3000);
    await expect(page).toHaveScreenshot('mobile-activity-bottom-nav.png');

    await page.goto(`${APP}/#/charts`, { waitUntil: 'networkidle', timeout: 30000 });
    await page.waitForTimeout(3000);
    await expect(page).toHaveScreenshot('mobile-insights-bottom-nav.png');

    await page.goto(`${APP}/#/budgets`, { waitUntil: 'networkidle', timeout: 30000 });
    await page.waitForTimeout(3000);
    await expect(page).toHaveScreenshot('mobile-plans-bottom-nav.png');
  });
});
