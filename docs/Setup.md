# Setup Guide

## Prerequisites

- Flutter 3.x+ (`brew install flutter`)
- macOS (for iOS/macOS builds)
- Xcode 15+ (for iOS builds)
- Chrome (for web testing)

## Getting Started

```bash
# Clone the repo
git clone https://github.com/Abhishek2r-rzp/pocketledger_flutter.git
cd pocketledger_flutter

# Install dependencies
flutter pub get

# Generate drift database code
dart run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Run on web (for testing)
flutter run -d chrome

# Run on iOS
flutter run -d ios

# Build for web
flutter build web
```

## Available Commands

```bash
make build-web      # Build Flutter web
make serve-web      # Serve web build locally on port 8080
make playwright-test        # Run Playwright visual tests
make playwright-update-snapshots  # Update visual baselines
```

## Test Commands

```bash
# All unit + widget tests
flutter test

# Web integration tests
flutter test --platform chrome test/integration/

# Playwright visual regression tests
npx playwright test
```

## Project Scripts

```bash
# Run smoke test
dart run scripts/smoke_test.dart

# Verify setup
bash scripts/verify_setup.sh
```

The app uses an in-memory `DataRepository` for web testing (no SQLite required). For production iOS/macOS builds, it switches to `DatabaseRepository` with drift/SQLite.
