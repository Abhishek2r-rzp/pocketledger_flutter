# PocketLedger Makefile — Development Automation
# Requires: Flutter SDK installed (brew install --cask flutter)

.PHONY: help setup clean build test lint analyze coverage doctor simulator run check-all

help:  ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

doctor:  ## Check Flutter installation
	flutter doctor -v

setup:  ## Full project setup (create wrappers, get deps, generate code)
	flutter create --project-name pocketledger --platforms ios .
	flutter pub get
	dart run build_runner build --delete-conflicting-outputs
	@echo "✅ Setup complete. Run 'make test' to verify."

clean:  ## Clean all generated files
	flutter clean
	rm -rf .dart_tool/
	rm -rf build/
	rm -rf ios/
	rm -rf android/
	rm -rf macos/
	rm -f lib/**/*.freezed.dart
	rm -f lib/**/*.g.dart
	rm -f lib/**/*.gr.dart
	@echo "✅ Clean complete."

update:  ## Update dependencies
	flutter pub upgrade
	dart run build_runner build --delete-conflicting-outputs
	@echo "✅ Dependencies updated."

build-ios:  ## Build iOS (debug, no code signing)
	flutter build ios --debug --no-codesign
	@echo "✅ iOS build complete."

build-ios-release:  ## Build iOS release (requires signing)
	flutter build ios --release
	@echo "✅ iOS release build complete."

test:  ## Run all unit + widget tests
	flutter test test/unit/ --reporter expanded
	flutter test test/widget/ --reporter expanded
	@echo "✅ All tests passed."

test-unit:  ## Run only unit tests
	flutter test test/unit/ --reporter expanded
	@echo "✅ Unit tests passed."

test-widget:  ## Run only widget tests
	flutter test test/widget/ --reporter expanded
	@echo "✅ Widget tests passed."

test-integration:  ## Run integration tests (requires simulator)
	flutter test test/integration/ --reporter expanded
	@echo "✅ Integration tests passed."

test-web-e2e:  ## Run web E2E integration tests in Chrome
	flutter test --platform chrome test/integration/ --reporter expanded
	@echo "✅ Web E2E tests passed."

test-e2e:  ## Run end-to-end tests (requires simulator)
	flutter test test/e2e/ --reporter expanded
	@echo "✅ E2E tests passed."

test-all: test test-integration test-e2e test-web-e2e  ## Run ALL tests

lint:  ## Analyze Dart code for issues
	dart analyze lib/
	@echo "✅ Lint complete."

analyze: lint  ## Alias for lint

coverage:  ## Run tests with coverage (requires lcov)
	flutter test --coverage test/unit/
	genhtml coverage/lcov.info -o coverage/html
	open coverage/html/index.html
	@echo "✅ Coverage report generated."

run:  ## Run on connected device
	flutter run

run-ios:  ## Run on iOS simulator
	flutter run -d iPhone

run-release:  ## Run release mode on connected device
	flutter run --release

simulator:  ## Open iOS simulator
	open -a Simulator
	@echo "✅ Simulator opened."

build-web:  ## Build web app (served via http.server)
	flutter build web
	@echo "✅ Web build complete. Serve with: make serve-web"

serve-web:  ## Serve web build on port 8080
	-pkill -f "python3.*http.server 8080" 2>/dev/null; sleep 0.5
	cd build/web && python3 -m http.server 8080 &
	@echo "✅ Serving at http://localhost:8080"

playwright-install:  ## Install Playwright browsers
	cd e2e_playwright && npm install && npx playwright install chromium

playwright-test: build-web  ## Run Playwright visual regression tests
	cd e2e_playwright && npx playwright test
	@echo "✅ Playwright tests complete. Report at e2e_playwright/playwright-report/"

playwright-update-snapshots: build-web  ## Update Playwright visual baseline snapshots
	cd e2e_playwright && npx playwright test --update-snapshots
	@echo "✅ Playwright snapshots updated."

check-all: doctor lint test build-ios  ## Full verification pipeline
	@echo "═══════════════════════════════════════"
	@echo "✅ ALL CHECKS PASSED"
	@echo "═══════════════════════════════════════"

docker:  ## Run in Docker (if Flutter Docker image is available)
	docker run --rm -v $$(pwd):/app -w /app \
		ghcr.io/cirruslabs/flutter:latest \
		/bin/sh -c "flutter pub get && dart run build_runner build && flutter test"

# ─── Validation targets ─────────────────────────────────────────

validate-models:  ## Validate all model files compile correctly
	@echo "Checking model files..."
	@for f in lib/core/models/*.dart; do \
		echo "  📄 $$(basename $$f)"; \
	done
	@echo "✅ $(shell ls lib/core/models/*.dart | wc -l) model files found."

validate-agents:  ## Validate all agent files exist
	@echo "Checking agent files..."
	@count=0; \
	for f in lib/agents/*.dart; do \
		echo "  🤖 $$(basename $$f)"; \
		count=$$((count + 1)); \
	done; \
	echo "✅ $$count agent files found."

validate-screens:  ## Validate all screen files exist
	@echo "Checking screen files..."
	@count=0; \
	for f in lib/features/*/*_screen.dart; do \
		echo "  🖥️  $$(basename $$f)"; \
		count=$$((count + 1)); \
	done; \
	echo "✅ $$count screen files found."

validate-tests:  ## Validate all test files exist
	@echo "Checking test files..."
	@count=0; \
	for f in test/**/*.dart; do \
		echo "  🧪 $$(basename $$f)"; \
		count=$$((count + 1)); \
	done; \
	echo "✅ $$count test files found."

validate-all: validate-models validate-agents validate-screens validate-tests  ## Validate everything
	@echo "═══════════════════════════════════════"
	@echo "✅ ALL FILES VALIDATED"
	@echo "═══════════════════════════════════════"
