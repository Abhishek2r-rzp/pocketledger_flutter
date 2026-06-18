# PocketLedger — Manual E2E Test Checklist

Run through this checklist on a physical iPhone or iOS Simulator.
Check off each item as you verify it works.

## Prerequisites

- [ ] Flutter installed (`flutter doctor` all green)
- [ ] Project set up (`make setup`)
- [ ] Device connected or simulator running

---

## 1. App Launch & Onboarding

- [ ] App launches without crash
- [ ] Onboarding screen shows 3 pages
- [ ] Page 1: "Your Data Stays on iPhone" privacy message
- [ ] Page 2: "Import Bank Statements" with format info
- [ ] Page 3: "Smart Categorization" description
- [ ] Dot indicators show current page
- [ ] Swipe left/right navigates pages
- [ ] "Get Started" button completes onboarding
- [ ] After completion, navigates to Dashboard

## 2. Face ID / App Lock

- [ ] Settings → Face ID toggle exists
- [ ] Toggling on triggers Face ID prompt
- [ ] Face ID success enables lock
- [ ] App relaunch shows lock screen
- [ ] "Tap to Unlock" button visible
- [ ] Face ID / passcode authenticates
- [ ] App unlocks to Dashboard
- [ ] Toggling off in Settings removes lock

## 3. Dashboard

- [ ] Dashboard loads without error
- [ ] Summary cards show:
  - [ ] Income (green, current month)
  - [ ] Expenses (red, current month)
  - [ ] Savings (blue, positive=blue/negative=red)
  - [ ] Savings Rate (purple, percentage)
- [ ] Charts render (bar + donut)
- [ ] Insights section shows at least 1 item
- [ ] Quick action buttons (Import, Review, Transactions, Charts, Budgets, Settings)
- [ ] Tapping each button navigates correctly
- [ ] Floating + button navigates to Import
- [ ] Pull to refresh works
- [ ] Review badge appears when uncategorized transactions exist

## 4. Import Statement

- [ ] Tap + from Dashboard → Import screen
- [ ] File picker opens (Files app / document browser)
- [ ] Can select a CSV file
- [ ] Processing indicator shows during parse
- [ ] Preview appears with:
  - [ ] Total transactions found
  - [ ] Duplicate count
  - [ ] Review needed count
  - [ ] Failed rows count
  - [ ] Category distribution
- [ ] "Confirm Import" button saves transactions
- [ ] After confirm, navigates to Dashboard
- [ ] Dashboard updates with new data
- [ ] "Cancel" returns to Dashboard without importing
- [ ] Try importing a non-CSV file → error message

## 5. Sample CSV Import

- [ ] Navigate to `test_resources/sample_indian_bank_statement.csv`
- [ ] Import the file
- [ ] Verify 30 transactions parsed
- [ ] Check merchants extracted (Swiggy, Zomato, Uber, Amazon, etc.)
- [ ] Check categories assigned automatically
- [ ] Some transactions may be in review queue (low confidence)

## 6. Review Queue

- [ ] Review queue badge shows count on Dashboard
- [ ] Tap badge → Review Queue screen
- [ ] Filter chips: All, Low Confidence, Duplicates, Needs Category
- [ ] Each review item shows:
  - [ ] Date
  - [ ] Merchant name
  - [ ] Amount
  - [ ] Suggested category
  - [ ] Confidence indicator
- [ ] Swipe right → Approve (green)
- [ ] Swipe left → Reject (red)
- [ ] Tap context menu → Edit Category
- [ ] Edit sheet shows category list
- [ ] Changing category saves and removes from queue
- [ ] Tap context menu → View Details navigates to detail screen

## 7. Transaction List

- [ ] Navigate to Transactions from Dashboard
- [ ] List shows all transactions
- [ ] Each row shows: date, merchant, amount (green/red), category badge
- [ ] Search bar at top
- [ ] Type in search → filters results instantly
- [ ] Filter chips for category, direction, date range
- [ ] Sort picker: Date, Amount, Merchant, Category
- [ ] Ascending/descending toggle
- [ ] Tap transaction → navigates to detail
- [ ] Pull to refresh works
- [ ] Empty state when no transactions match filter

## 8. Transaction Detail

- [ ] Date picker works (edit date)
- [ ] Merchant name editable
- [ ] Amount editable
- [ ] Direction picker (income/expense/transfer/refund)
- [ ] Category picker (scrollable list with icons)
- [ ] Notes field editable
- [ ] Tags: add tag button
- [ ] Tags: remove tag (tap X)
- [ ] Raw description shown (read-only)
- [ ] Categorization explanation shown (read-only)
- [ ] Save button persists changes
- [ ] Cancel discards changes
- [ ] "Saved" confirmation appears briefly

## 9. Charts / Analytics

- [ ] Navigate to Charts from Dashboard
- [ ] Segmented control: Overview / Categories / Trends
- [ ] Income vs Expense bar chart (12 months)
- [ ] Category spend pie chart
- [ ] Daily spending line chart
- [ ] Top merchants horizontal bar chart
- [ ] Savings rate trend line chart
- [ ] Each chart has proper labels
- [ ] Charts are scrollable
- [ ] No chart crashes or rendering issues

## 10. Budgets

- [ ] Navigate to Budgets
- [ ] Empty state shows "No budgets yet"
- [ ] Tap + → Add budget
- [ ] Select category from list
- [ ] Enter amount
- [ ] Budget appears in list with progress bar
- [ ] At 0% spent: green, shows 0%
- [ ] At 50% spent: green, shows 50%
- [ ] At 80% spent: yellow/warning
- [ ] At 100%+: red/over-budget
- [ ] Tap budget → edit amount
- [ ] Swipe budget → delete with confirmation
- [ ] Budget recalculates when new transactions added

## 11. Recurring Payments

- [ ] Navigate to Recurring Payments
- [ ] Detected payments appear after import (Spotiify x2 should trigger)
- [ ] Each item shows: merchant, amount, frequency, confidence
- [ ] Status badge: Detected (blue), Confirmed (green), Rejected (red)
- [ ] Swipe right → Confirm
- [ ] Swipe left → Reject
- [ ] Tap → detail sheet

## 12. Import History

- [ ] Navigate to Import History
- [ ] Shows list of all import batches
- [ ] Each item: filename, date, status, counts
- [ ] Swipe to delete batch
- [ ] Delete confirmation dialog
- [ ] After delete, transactions removed from list
- [ ] Import count updates

## 13. Settings

- [ ] Navigate to Settings
- [ ] Face ID toggle works (enables/disables)
- [ ] Currency picker (INR default, USD, EUR, etc.)
- [ ] Export CSV button
- [ ] Tapping Export creates file
- [ ] Share sheet appears with CSV file
- [ ] CSV file contains all transactions
- [ ] Delete All Data button
- [ ] Confirmation dialog before delete
- [ ] After delete, app resets to onboarding
- [ ] Privacy Report shows data info
- [ ] Debug Mode toggle (enables agent logs)
- [ ] Agent Logs button (visible only in debug mode)
- [ ] About section shows version/build

## 14. Agent Logs (Debug)

- [ ] Enable Debug Mode in Settings
- [ ] Agent Logs button appears
- [ ] Tap → shows agent action logs
- [ ] Each log: agent name, action, timestamp, confidence
- [ ] Filter by agent name
- [ ] Clear old logs (30+ days)
- [ ] Explanation text visible

## 15. Privacy Report

- [ ] Tap Privacy Report in Settings
- [ ] Shows: data stored locally (Yes)
- [ ] Shows: app lock status
- [ ] Shows: network access used (No)
- [ ] Shows: cloud sync (No)
- [ ] Shows: database size
- [ ] Shows: transaction count
- [ ] Shows: import batch count
- [ ] Shows: export available (Yes)
- [ ] Shows: delete data available (Yes)

## 16. Airplane Mode

- [ ] Enable Airplane Mode
- [ ] App launches normally
- [ ] Import works (file is local)
- [ ] All screens work
- [ ] Export works
- [ ] No error messages about network

## 17. Edge Cases

- [ ] Import duplicate file → duplicates flagged
- [ ] Large CSV (100+ transactions) → imports successfully
- [ ] Empty CSV → error message
- [ ] Corrupted CSV → error message
- [ ] Rapid tapping on buttons → no crashes
- [ ] Background → foreground → app lock triggers (if enabled)
- [ ] Delete all data → app restarts onboarding
- [ ] Re-import same file after deletion → works

---

## Results

| Date | Tester | Tests Passed | Tests Failed | Notes |
|------|--------|-------------|-------------|-------|
|      |        | /80         | /80         |       |
