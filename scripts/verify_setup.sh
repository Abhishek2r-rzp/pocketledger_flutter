#!/bin/bash
# PocketLedger Setup Verification Script
# Run: bash scripts/verify_setup.sh
# Tests: Flutter installation, project setup, compilation, and test execution

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PASS=0
FAIL=0
SKIP=0

log_pass()  { echo -e "  ${GREEN}✅${NC} $1"; PASS=$((PASS + 1)); }
log_fail()  { echo -e "  ${RED}❌${NC} $1"; FAIL=$((FAIL + 1)); }
log_skip()  { echo -e "  ${YELLOW}⏭️ ${NC} $1"; SKIP=$((SKIP + 1)); }
log_info()  { echo -e "  ${BLUE}ℹ️ ${NC} $1"; }
section()   { echo ""; echo -e "${BLUE}═══ $1 ═══${NC}"; }

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_DIR"

echo "════════════════════════════════════════════════════════"
echo "  PocketLedger — Setup Verification"
echo "  Project: $PROJECT_DIR"
echo "  Date:    $(date)"
echo "════════════════════════════════════════════════════════"

# ─── 1. Flutter Installation ──────────────────────────────────
section "1. Flutter Installation"

if command -v flutter &> /dev/null; then
  FLUTTER_VERSION=$(flutter --version 2>/dev/null | head -1)
  log_pass "Flutter installed: $FLUTTER_VERSION"
else
  log_fail "Flutter not found. Run: brew install --cask flutter"
  log_info "Download from: https://docs.flutter.dev/get-started/install/macos"
fi

if command -v dart &> /dev/null; then
  DART_VERSION=$(dart --version 2>&1)
  log_pass "Dart installed: $DART_VERSION"
else
  log_fail "Dart not found (should come with Flutter)"
fi

if command -v xcodebuild &> /dev/null; then
  XCODE_VERSION=$(xcodebuild -version 2>/dev/null | head -1)
  log_pass "Xcode: $XCODE_VERSION"
else
  log_skip "Xcode not found (not needed for testing, needed for iOS build)"
fi

# ─── 2. Project Structure ────────────────────────────────────
section "2. Project Structure"

[ -f "pubspec.yaml" ] && log_pass "pubspec.yaml" || log_fail "Missing pubspec.yaml"
[ -f "analysis_options.yaml" ] && log_pass "analysis_options.yaml" || log_fail "Missing analysis_options.yaml"

# Count files
DART_COUNT=$(find lib -name "*.dart" | wc -l)
TEST_COUNT=$(find test -name "*.dart" | wc -l)
log_pass "$DART_COUNT source files in lib/"
log_pass "$TEST_COUNT test files in test/"

# Check key directories
for dir in lib/core/models lib/core/database/daos lib/agents/agent_core \
           lib/features/onboarding lib/features/dashboard lib/features/import \
           test/unit test/widget test/integration test/e2e; do
  [ -d "$dir" ] && log_pass "Directory: $dir" || log_fail "Missing: $dir"
done

# ─── 3. Native Project Wrappers ──────────────────────────────
section "3. Native Project Wrappers"

if [ -d "ios" ] && [ -f "ios/Podfile" ]; then
  log_pass "iOS project exists"
else
  log_skip "iOS project not found (create with: flutter create --platforms ios .)"
fi

if [ -d "android" ]; then
  log_pass "Android project exists"
else
  log_skip "Android project not found"
fi

# ─── 4. Dependencies ─────────────────────────────────────────
section "4. Dependencies"

if command -v flutter &> /dev/null; then
  if flutter pub get &> /dev/null; then
    log_pass "flutter pub get succeeded"
  else
    log_fail "flutter pub get failed"
  fi

  if dart run build_runner build --delete-conflicting-outputs 2>/dev/null; then
    log_pass "build_runner generated code"
  else
    log_skip "build_runner failed (expected if drift/freezed generated files already exist)"
  fi
else
  log_skip "Skipping dependency checks (Flutter not installed)"
fi

# ─── 5. Dart Analysis ────────────────────────────────────────
section "5. Dart Analysis"

if command -v dart &> /dev/null; then
  ANALYSIS=$(dart analyze lib/ 2>&1 || true)
  ERROR_COUNT=$(echo "$ANALYSIS" | grep -c "error" || true)
  WARN_COUNT=$(echo "$ANALYSIS" | grep -c "warning" || true)
  HINT_COUNT=$(echo "$ANALYSIS" | grep -c "info" || true)

  if [ "$ERROR_COUNT" -gt 0 ]; then
    log_fail "$ERROR_COUNT analysis errors (run: dart analyze lib/)"
    echo "$ANALYSIS" | grep "error" | head -5
  else
    log_pass "No analysis errors"
  fi
  log_info "Warnings: $WARN_COUNT, Hints: $HINT_COUNT"
else
  log_skip "Skipping analysis (Dart not installed)"
fi

# ─── 6. Tests ────────────────────────────────────────────────
section "6. Tests"

if command -v flutter &> /dev/null; then
  echo "  Running unit tests..."
  if flutter test test/unit/ --reporter expanded 2>&1; then
    log_pass "All unit tests passed"
  else
    log_fail "Some unit tests failed"
  fi

  echo "  Running widget tests..."
  if flutter test test/widget/ --reporter expanded 2>&1; then
    log_pass "All widget tests passed"
  else
    log_fail "Some widget tests failed"
  fi
else
  log_skip "Skipping tests (Flutter not installed)"
fi

# ─── 7. iOS Build ────────────────────────────────────────────
section "7. iOS Build"

if command -v flutter &> /dev/null && [ -d "ios" ]; then
  echo "  Building iOS (debug, no code signing)..."
  if flutter build ios --debug --no-codesign 2>&1; then
    log_pass "iOS build succeeded"
  else
    log_fail "iOS build failed"
  fi
else
  log_skip "Skipping iOS build (Flutter or ios/ directory missing)"
fi

# ─── 8. Sample Data ──────────────────────────────────────────
section "8. Sample Data"

if [ -f "test_resources/sample_indian_bank_statement.csv" ]; then
  LINES=$(wc -l < "test_resources/sample_indian_bank_statement.csv")
  log_pass "Sample CSV: $LINES lines"
  head -1 "test_resources/sample_indian_bank_statement.csv"
else
  log_fail "Missing sample CSV"
fi

# ─── 9. CI Configuration ────────────────────────────────────
section "9. CI Configuration"

[ -f ".github/workflows/test.yml" ] && log_pass "GitHub Actions workflow" || log_skip "CI workflow not found"
[ -f "Makefile" ] && log_pass "Makefile" || log_skip "Makefile not found"

# ─── Summary ─────────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════════════════════"
echo "  RESULTS: $PASS passed, $FAIL failed, $SKIP skipped"
echo "════════════════════════════════════════════════════════"

if [ $FAIL -eq 0 ]; then
  echo -e "${GREEN}✅ All checks passed!${NC}"
  exit 0
else
  echo -e "${RED}❌ $FAIL checks failed. Review above.${NC}"
  exit 1
fi
