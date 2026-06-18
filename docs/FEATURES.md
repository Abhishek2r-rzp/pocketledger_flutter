# PocketLedger — Complete Feature Documentation

> Offline-first personal finance tracker with local agentic architecture.
> Built with Flutter, Riverpod, GoRouter, Drift (SQLite), and fl_chart.

---

## Architecture Overview

| Layer | Technology | Status |
|---|---|---|
| **State Management** | Riverpod (`flutter_riverpod` + `riverpod_annotation`) | ✅ |
| **Routing** | GoRouter (12 routes, custom transitions) | ✅ |
| **Database** | Drift (SQLite) — 8 tables, full DAO layer | ✅ |
| **Theme** | Custom dark/light with AppColors, GlassCard components | ✅ |
| **Agents** | 12 local agents + orchestrator (deterministic rules, no ML) | ✅ |
| **Parsers** | CSV, PDF statement parser | ✅ |
| **Security** | Passcode + biometric auth via `local_auth` | ✅ |
| **Testing** | 269 unit/widget tests, 6 web E2E, 4 Playwright visual | ✅ |

---

## 1. Core Infrastructure

### 1.1 Entry Point (`lib/main.dart`)
- Riverpod `ProviderScope` wrapping `PocketLedgerApp`
- Initializes theme provider, passes router

### 1.2 App Shell (`lib/app.dart`)
- `MaterialApp.router` with GoRouter
- Dark/light theme switching via `themeModeProvider`
- Custom `ScrollBehavior` (glow-free on desktop)

### 1.3 Routing (`lib/router.dart`)
- 12 named routes with custom slide+fade transitions (350ms easeOutCubic)
- Routes: Onboarding → Lock → Dashboard → Import → Review → Transactions → Transaction Detail → Charts → Budgets → Recurring → Import History → Settings → Agent Logs

### 1.4 Theme System (`lib/core/theme/`)

| Component | File | Description |
|---|---|---|
| **AppColors** | `app_colors.dart` | 12 semantic colors, 6 gradients (primary, accent, income, expense, warning, info, background, surface, text, glass) |
| **AppTheme** | `app_theme.dart` | `ThemeData` for dark/light — deep backgrounds (`#0A0E1A`), purple/teal accents, custom card themes |
| **GlassCard** | `glass_card.dart` | `GlassCard` + `GlassCardSmall` — `BackdropFilter` with `ImageFilter.blur`, frosted borders, glow shadows |
| **PremiumShimmer** | `premium_shimmer.dart` | Animated shimmer loading skeleton with gradient sweep |
| **PageTransition** | `page_transition.dart` | `premiumPageTransition()` / `glassPageTransition()` factory functions |
| **StyledAppBar** | `styled_app_bar.dart` | Glass-styled AppBar with blur |
| **AnimatedListItem** | `animated_list_item.dart` | Staggered animation helpers (fade + slide, 80ms intervals) |

---

## 2. Screens

### 2.1 Onboarding (`/onboarding`)
- **Status**: ✅ Complete
- **Files**: `onboarding_screen.dart`, `onboarding_provider.dart`
- **Features**:
  - 3-page PageView with illustrations and copy
  - Page indicator dots with animation
  - "Get Started" button to mark `firstLaunchCompleted`
  - Auto-skips if already completed

### 2.2 Lock Screen (`/lock`)
- **Status**: ✅ Complete
- **Files**: `lock_screen.dart`, `lock_provider.dart`
- **Features**:
  - 4-digit passcode numpad with premium glass styling
  - Biometric authentication button (Face ID / Touch ID)
  - State machine: `initial → available/unavailable → authenticating → authenticated/failed`
  - "Enter App" fallback when biometric unavailable
  - Passcode set, verify, change, remove flows

### 2.3 Dashboard (`/`) — Premium Bento Grid
- **Status**: ✅ Complete
- **Files**: `dashboard_screen.dart`, `dashboard_provider.dart`
- **Features**:
  - **Balance Header**: Total balance, savings rate badge (trending up/down)
  - **Income/Expense Row**: Side-by-side glass cards with percentage change
  - **Monthly Chart**: 6-month bar chart (fl_chart) — income vs expense
  - **Top Categories**: Progress bars for top 5 spending categories
  - **Quick Actions**: 3-column grid (Transactions, Analytics, Budgets, Recurring, History, Review)
  - **Review Badge**: Count of items needing review, tappable
  - **Insights**: Dynamic insight cards (month-over-month, top category, savings rate, recurring summary, anomalies, budget status)
  - **Shimmer Loading**: Premium skeleton while data loads
  - **Staggered Animations**: All sections fade+slide in with 80ms cascade delays
  - **Pull-to-Refresh**: Refresh indicator

### 2.4 Transactions (`/transactions`)
- **Status**: ✅ Complete
- **Files**: `transactions_screen.dart`, `transactions_provider.dart`, `transaction_detail_screen.dart`, `transaction_detail_provider.dart`
- **Features**:
  - Glass card transaction list with staggered animations
  - Search bar with real-time filtering
  - Direction filter chips (All / Income / Expense / Transfer)
  - Sort dropdown (Date / Amount / Description / Confidence)
  - **Detail Screen**:
    - Date picker, merchant, description, amount, direction
    - Category dropdown with colored icon
    - Notes text field, tags input
    - Raw description view
    - Categorization explanation display
    - Delete with confirmation

### 2.5 Charts / Analytics (`/charts`)
- **Status**: ✅ Complete
- **Files**: `charts_screen.dart`, `charts_provider.dart`
- **Features**:
  - **Segmented Control**: Overview / Categories / Trends
  - **Overview Tab**: Grouped bar chart (income vs expense by month)
  - **Categories Tab**: Pie chart (spending by category)
  - **Trends Tab**: Line chart (daily 30-day spending), Bar chart (top merchants), Line chart (savings rate 12-month)

### 2.6 Budgets (`/budgets`)
- **Status**: ✅ Complete
- **Files**: `budgets_screen.dart`, `budgets_provider.dart`
- **Features**:
  - List of category budgets with progress bars
  - Visual over-budget / near-limit indicators
  - Swipe-to-delete with confirmation dialog
  - FAB to add budget via bottom sheet (category picker + amount input)
  - Dynamic spend calculation from in-memory transactions

### 2.7 Recurring Payments (`/recurring`)
- **Status**: ✅ Complete
- **Files**: `recurring_payments_screen.dart`, `recurring_payments_provider.dart`
- **Features**:
  - List with status badges (Detected / Confirmed / Rejected)
  - Swipe to confirm or reject
  - Detail bottom sheet with payment info
  - Detection runs via `RecurringPaymentAgent`
  - Average amount, frequency, occurrences displayed

### 2.8 Import (`/import`)
- **Status**: ✅ Complete
- **Files**: `import_screen.dart`, `import_provider.dart`
- **Features**:
  - File picker (CSV, PDF) via `file_picker` package
  - Comprehensive import state machine: Idle → Processing → Preview → Success / Error
  - Preview screen: total, new, duplicate, review counts + category distribution chart
  - Confirm / Cancel actions
  - Supported formats card (CSV, PDF, more coming)
  - XLSX noted as "Coming soon"

### 2.9 Import History (`/import-history`)
- **Status**: ✅ Complete
- **Files**: `import_history_screen.dart`, `import_history_provider.dart`
- **Features**:
  - List of past imports with status badges
  - Shows: total rows, imported, duplicates, failed
  - Swipe-to-delete with confirmation
  - Reverse chronological order

### 2.10 Review Queue (`/review`)
- **Status**: ✅ Complete
- **Files**: `review_queue_screen.dart`, `review_queue_provider.dart`
- **Features**:
  - Dismissible list (swipe to approve / reject)
  - Filter by review reason (Low Confidence / Possible Duplicate)
  - Confidence badges (color-coded)
  - Edit bottom sheet for reassigning category
  - 3-dot menu (Edit / Approve / Reject)
  - Auto-updates transaction category on approve

### 2.11 Settings (`/settings`)
- **Status**: ✅ Complete
- **Files**: `settings_screen.dart`, `settings_provider.dart`
- **Features**:
  - **Security**: Biometric toggle, Passcode set/change/remove
  - **Preferences**: Currency picker
  - **Data**: Export CSV (via share_plus), Delete all data
  - **Privacy**: Privacy report
  - **Developer**: Agent logs link
  - **About**: App info

### 2.12 Agent Logs (`/agent-logs`)
- **Status**: ✅ Complete
- **Files**: `agent_logs_screen.dart`, `agent_logs_provider.dart`
- **Features**:
  - Filterable list by agent name
  - Confidence badges, timestamps
  - Expandable explanation rows
  - Clear all logs button

---

## 3. Data Layer

### 3.1 Models (`lib/core/models/` — 14 files)

| Model | Fields | Used By |
|---|---|---|
| **Transaction** | id, date, amount, direction, description, merchantName, categoryId/Name, balance, currency, fingerprint, importBatchId, notes, tags, confidence, needsReview, rawDescription, categorizationExplanation, createdAt, updatedAt | Core entity |
| **Category** | id, name, icon, colorValue, parentCategoryId, type, isSystem, createdAt | Categorization |
| **Budget** | id, categoryId/Name, amount, month, year, createdAt | Budget tracking |
| **RecurringPayment** | id, merchantName, amount, frequency, categoryId/Name, lastDetected, occurrences, averageAmount, active, createdAt | Recurring detection |
| **ImportBatch** | id, fileName, fileType, filePath, totalRows, importedRows, duplicateRows, failedRows, createdAt | Import tracking |
| **ReviewItem** | id, transactionId, reason, suggestedCategoryId/Name/Merchant, confidence, explanation, createdAt | Review queue |
| **Insight** | id, title, description, type, severity, relatedCategoryId, relatedAmount, createdAt | Dashboard insights |
| **AgentActionLog** | id, agentName, actionType, inputSummary, outputSummary, confidence, explanation, transactionId, batchId, createdAt | Agent audit trail |
| **CategorizationRule** | id, merchantPattern, descriptionPattern, categoryId/Name, usageCount, createdAt | Learning agent |
| **UserSettings** | appLockEnabled, currency, firstLaunchCompleted, privacyModeEnabled, exportEnabled, cloudSyncEnabled, themeMode | Settings |
| **ParsedTransactionDraft** | rowNumber, rawDate/Description/Debit/Credit/Amount/Balance, parsedDate/Amount/Direction/Balance, currency | CSV/PDF import |
| **Enums** | TransactionDirection, CategoryType, ImportBatchStatus, MatchType, RecurringStatus, ReviewReason, PaymentFrequency, WarningType, InsightType, InsightSeverity | Everywhere |

### 3.2 Database — Drift (`lib/core/database/`)

| Table | DAO | Key Queries |
|---|---|---|
| **Transactions** | `TransactionDao` | CRUD, search, filter by batch/category/date, monthly summary, category spend, daily spend, top merchants |
| **Categories** | `CategoryDao` | CRUD, by type, system/custom, parent-child |
| **ImportBatches** | `ImportBatchDao` | CRUD, by status, totals |
| **CategorizationRules** | `RuleDao` | CRUD, by user/system, match type, category |
| **Budgets** | `BudgetDao` | CRUD, by month/year/category, total budgeted/spent |
| **RecurringPayments** | `RecurringPaymentDao` | CRUD, by status, upcoming, by merchant |
| **AgentActionLogs** | `AgentLogDao` | CRUD, by agent/action/transaction/batch, summary, cleanup |
| **UserSettings** | `SettingsDao` | CRUD, first-launch check, toggles |

- SQLite via `NativeDatabase` (no network)
- `DateTimeConverter` (stores as milliseconds since epoch)
- `StringListConverter` (JSON-encoded lists)
- Foreign keys: Transactions → ImportBatches, Transactions → Categories, Categories → Categories (self-ref)
- Indexes on all query-critical columns

### 3.3 Data Repository (`lib/core/data_repository.dart`)
- **Status**: Currently in-memory only (temporary until SQLite wiring)
- Will be replaced with DAO-backed persistence
- Provides: transactions, review items, import batches, budgets, recurring payments, agent logs, settings, categories

---

## 4. Agent System (`lib/agents/`)

### 4.1 Architecture

```
Agent<Input, Output>
  ├── run(Input) → AgentResult<Output>
  │     ├── status: pending | running | completed | needsUserReview | failed
  │     ├── output: Output?
  │     ├── confidence: 0.0–1.0
  │     ├── explanation: String?
  │     └── auditLogs: List<AgentActionLog>
  │
  AgentOrchestrator (singleton)
      ├── executeImportPipeline()
      ├── executeCategorizationPipeline()
      ├── executeRecurringDetectionPipeline()
      ├── executeInsightsPipeline()
      └── processUserCorrection()
```

### 4.2 Agent Inventory (12 agents)

| Agent | Input | Output | Purpose |
|---|---|---|---|
| **FileImportAgent** | filePath, fileName | ImportBatch + local copy path | Copies file to secure storage |
| **StatementParserAgent** | filePath, fileType | ParsedTransactionDraft[] | CSV/PDF → raw rows |
| **TransactionNormalizerAgent** | drafts, batchId | Transaction[] | Raw rows → normalized txns |
| **DeduplicationAgent** | new + existing txns | unique, exact dupes, possible dupes | Fingerprint + fuzzy match |
| **MerchantCleanerAgent** | transactions | cleaned transactions | 80 merchant patterns mapped |
| **CategorizationAgent** | txns, rules, categories | categorized txns | 40 built-in rules, 30+ heuristics |
| **ReviewQueueAgent** | AgentDatabase | ReviewItem[] | Collects low-confidence items |
| **RecurringPaymentAgent** | txns, existing recurring | detected payments | Interval + amount similarity |
| **BudgetAgent** | AgentDatabase | BudgetWarning[] | ≥80% threshold alerts |
| **InsightAgent** | txns, budgets, recurring, categories | Insight[] | MoM, top category, savings rate, anomalies |
| **LearningAgent** | correction + AgentDatabase | void | Creates rules from user corrections |
| **PrivacyGuardAgent** | settings | PrivacyReport | Reports data residency |

### 4.3 Pipelines

| Pipeline | Agents | When Run |
|---|---|---|
| **Import** | FileImport → StatementParser → Normalizer → Dedup → MerchantCleaner → Categorization | On file import |
| **Categorization** | Categorization (on uncategorized) | On-demand / schedule |
| **Recurring Detection** | RecurringPayment | After import |
| **Insights** | InsightAgent | On dashboard load |

---

## 5. Services

| Service | File | Capabilities |
|---|---|---|
| **ExportService** | `services/export_service.dart` | CSV export with proper header escaping, share via `share_plus` |
| **SearchService** | `services/search_service.dart` | Search by merchant/description, filter by category/direction/date range, sort by amount/description/confidence/date |

---

## 6. Security & Privacy

| Component | File | Capabilities |
|---|---|---|
| **BiometricManager** | `core/security/biometric_manager.dart` | Face ID / Touch ID via `local_auth`, availability check, authenticate |
| **PrivacyManager** | `core/privacy/privacy_manager.dart` | PII redaction — email, card numbers, UPI IDs, IFSC codes, phone numbers, Aadhaar, PAN |

---

## 7. Parsers

| Parser | File | Status |
|---|---|---|
| **CSV Parser** | `parsers/csv_parser.dart` | Robust, multi-format date parsing, column detection |
| **PDF Parser** | `parsers/pdf_parser.dart` | Regex-based, date + amount + description extraction |
| **XLSX Parser** | `parsers/xlsx_parser.dart` | Stub — throws `UnsupportedError` |

---

## 8. Helpers

| Helper | File | Utilities |
|---|---|---|
| **Date Helpers** | `helpers/date_helpers.dart` | `formatDate()`, `daysSince()`, `sameDay()` |
| **String Helpers** | `helpers/string_helpers.dart` | `capitalize()`, `truncate()`, `cleanWhitespace()` |
| **Currency Helpers** | `helpers/currency_helpers.dart` | `formatINR()`, `parseAmount()` |
| **Constants** | `helpers/constants.dart` | Default currency, app name, version |

---

## 9. Testing

| Test Suite | Command | Count | Status |
|---|---|---|---|
| **Unit Tests** | `flutter test test/unit/` | — | ✅ |
| **Widget Tests** | `flutter test test/widget/` | — | ✅ |
| **Integration (Web E2E)** | `flutter test --platform chrome test/integration/` | 6 | ✅ |
| **Playwright Visual** | `cd e2e_playwright && npx playwright test` | 4 | ✅ |
| **All Tests** | `make test` | 269 | ✅ Passing |

### Playwright Visual Regression (4 tests)
- Homepage (bento dashboard)
- Transactions list with search/filter
- Settings screen
- Lock screen

---

## 10. Development Commands

| Command | Description |
|---|---|
| `make setup` | Full project setup |
| `make test` | All unit + widget tests |
| `make lint` | Dart analysis |
| `make coverage` | Test coverage report |
| `make build-web` | Build for web |
| `make serve-web` | Serve at localhost:8080 |
| `make playwright-test` | Visual regression tests |
| `make check-all` | Doctor + lint + test + build |
| `flutter run` | Run on device/simulator |

---

## 11. Environment

- **Flutter**: 3.44.2 (stable)
- **Dart**: SDK >=3.2.0 <4.0.0
- **Platforms**: iOS, Web (CanvasKit), Android, macOS (planned)
- **Deps**: 15 direct dependencies (flutter_riverpod, go_router, drift, fl_chart, local_auth, file_picker, csv, share_plus, freezed_annotation, json_annotation, flutter_animate, collection, uuid, intl)

---

## 12. Known Issues & Roadmap

### Current Issues
- `DataRepository` is in-memory only — SQLite schema and DAOs are ready but not wired
- ~512 analyzer info-level issues (deprecated `withOpacity`, sorting, unused imports)
- XLSX parser is a stub
- Web uses CanvasKit renderer (no DOM text) — Playwright text locators don't work

### Planned Features
- [ ] Wire Drift SQLite persistence
- [ ] Budget alerts & notifications
- [ ] Recurring payment auto-detection reminders
- [ ] Multi-currency conversion
- [ ] Transaction search/filter UI refinements
- [ ] Widget/iOS home screen quick balance
- [ ] iCloud / platform backup
- [ ] Dark/light mode persisted toggle
- [ ] Haptic feedback on key interactions
- [ ] Export to PDF
- [ ] Analytics category management
- [ ] Agent pipeline scheduling
