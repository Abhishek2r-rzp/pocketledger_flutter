# PocketLedger — Anchored Summary

## Goal
Offline-first iPhone finance tracker in Flutter with agentic architecture, complete test coverage, and CI automation.

## Progress

### Session Jun 15 — UI Modernization
- **Premium dark theme**: Deep backgrounds (`#0A0E1A`), purple/teal accents, frosted glass cards via `BackdropFilter` + `ImageFilter.blur`, consistent typography
- **Bento grid dashboard**: Balance header (full width), Income/Expenses (side by side), Monthly bar chart (full), Category list with progress bars, Quick Actions (3-column grid), Insights section
- **Glassmorphism cards**: `GlassCard` + `GlassCardSmall` widgets with frosted backgrounds, subtle borders, glow shadows
- **Staggered animations**: List items fade+slide in with 80ms delay intervals via `flutter_animate`
- **Page transitions**: Custom `SlideTransition` + `FadeTransition` on all GoRouter routes (350ms easeOutCubic)
- **Shimmer loading**: `PremiumShimmer` + `ShimmerCard` for dashboard/loading skeletons
- **Theme system**: `AppTheme.dark` / `AppTheme.light` + `themeModeProvider` for dynamic switching
- **All screens updated**: Lock, Settings, Transactions all use glass cards, `AppColors` constants, premium styling
- **Visual Regression Testing**: 4 Playwright screenshot tests comparing on every run (`playwright-test` / `playwright-update-snapshots`)

### Test Status
- `flutter test`: **269/269 passing** (all unit + widget)
- `flutter test --platform chrome test/integration/`: **6/6 passing** (passcode lifecycle)
- `npx playwright test` (e2e_playwright): **4/4 passing** (visual regression screenshots)

### How to use
- **Web**: `make build-web && make serve-web` then open http://localhost:8080
- **Web E2E tests**: `flutter test --platform chrome test/integration/`
- **Playwright visual tests**: `make playwright-test` (compares screenshots against baselines in `e2e_playwright/*-snapshots/`)
- **Update visual baselines**: `make playwright-update-snapshots`

### Relevant Files
| File | What it does |
|------|-------------|
| `lib/core/theme/app_colors.dart` | Premium dark color palette (12 colors, 6 gradients) |
| `lib/core/theme/app_theme.dart` | Full ThemeData for dark/light with glass styling |
| `lib/core/theme/glass_card.dart` | Reusable glassmorphism card with `BackdropFilter` blur |
| `lib/core/theme/premium_shimmer.dart` | Animated shimmer loading skeleton |
| `lib/core/theme/animated_list_item.dart` | Staggered list animation helpers (fade+slide) |
| `lib/core/theme/page_transition.dart` | Custom page transition builders |
| `lib/core/theme/styled_app_bar.dart` | Glass-styled AppBar |
| `lib/app.dart` | Dark/light theme switching via `themeModeProvider` |
| `lib/router.dart` | Slide+fade transitions on all routes |
| `lib/features/dashboard/dashboard_screen.dart` | Bento grid layout: balance, income/expense, chart, categories, actions |
| `lib/features/lock/lock_screen.dart` | Glass card lock UI with premium numpad |
| `lib/features/settings/settings_screen.dart` | Glass card sections with styled list tiles |
| `lib/features/transactions/transactions_screen.dart` | Glass card transaction list with staggered animation |
| `test/integration/app_flow_test.dart` | 6 web E2E tests (updated for new UI text/selectors) |
| `e2e_playwright/app_e2e.spec.ts` | 4 visual regression screenshot tests |
| `e2e_playwright/*-snapshots/` | Baseline screenshots for visual comparison |

### Known Issues
- Web uses CanvasKit renderer (no DOM text) — Playwright text locators don't work. Use `flutter test --platform chrome` for automated E2E
- 309 analyzer errors in `lib/` (pre-existing, not from this session)
- `DataRepository` is in-memory only — not wired to drift SQLite yet
