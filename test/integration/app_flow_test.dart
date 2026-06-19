import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/integration_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketledger/features/onboarding/onboarding_screen.dart';
import 'package:pocketledger/features/lock/lock_screen.dart';
import 'package:pocketledger/features/dashboard/dashboard_screen.dart';
import 'package:pocketledger/features/settings/settings_screen.dart';
import 'package:pocketledger/features/transactions/transactions_screen.dart';
import 'package:pocketledger/features/import/import_screen.dart';
import 'package:pocketledger/core/data_repository.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  GoRouter createRouter() {
    return GoRouter(
      initialLocation: '/onboarding',
      routes: [
        GoRoute(
            path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
        GoRoute(path: '/lock', builder: (_, __) => const LockScreen()),
        GoRoute(path: '/', builder: (_, __) => const DashboardScreen()),
        GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
        GoRoute(
            path: '/transactions',
            builder: (_, __) => const TransactionsScreen()),
        GoRoute(path: '/import', builder: (_, __) => const ImportScreen()),
      ],
    );
  }

  Future<void> completeOnboarding(WidgetTester tester) async {
    await tester.pumpAndSettle();
    expect(find.text('Your Data Stays on iPhone'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Import Bank Statements'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Smart Categorization'), findsOneWidget);
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
  }

  Future<void> enterDigits(WidgetTester tester, String code) async {
    for (final char in code.split('')) {
      await tester.tap(find.text(char));
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  group('Web E2E', () {
    testWidgets('onboarding → lock → dashboard', (tester) async {
      final repo = DataRepository();
      final router = createRouter();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [dataRepositoryProvider.overrideWithValue(repo)],
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      await completeOnboarding(tester);
      expect(find.textContaining('No passcode configured'), findsOneWidget);
      expect(find.text('Enter App'), findsOneWidget);

      await tester.tap(find.text('Enter App'));
      await tester.pumpAndSettle();
      expect(find.text('Overview'), findsOneWidget);
    });

    testWidgets('set passcode, lock, unlock', (tester) async {
      final repo = DataRepository();
      final router = createRouter();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [dataRepositoryProvider.overrideWithValue(repo)],
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      await completeOnboarding(tester);
      await tester.tap(find.text('Enter App'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Passcode Lock'), 200);
      await tester.tap(find.text('Passcode Lock'));
      await tester.pumpAndSettle();
      await enterDigits(tester, '1234');
      await tester.pumpAndSettle();
      await enterDigits(tester, '1234');
      await tester.pumpAndSettle();
      expect(find.text('Passcode is set'), findsOneWidget);

      router.go('/lock');
      await tester.pumpAndSettle();
      await enterDigits(tester, '1234');
      await tester.pumpAndSettle();
      expect(find.text('Overview'), findsWidgets);
    });

    testWidgets('wrong passcode shows error', (tester) async {
      final repo = DataRepository();
      final router = createRouter();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [dataRepositoryProvider.overrideWithValue(repo)],
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      await completeOnboarding(tester);
      await tester.tap(find.text('Enter App'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Passcode Lock'), 200);
      await tester.tap(find.text('Passcode Lock'));
      await tester.pumpAndSettle();
      await enterDigits(tester, '1234');
      await tester.pumpAndSettle();
      await enterDigits(tester, '1234');
      await tester.pumpAndSettle();

      router.go('/lock');
      await tester.pumpAndSettle();

      await enterDigits(tester, '0000');
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Incorrect passcode'), findsOneWidget);

      await enterDigits(tester, '1234');
      await tester.pumpAndSettle();
      expect(find.text('Overview'), findsWidgets);
    });

    testWidgets('change passcode', (tester) async {
      final repo = DataRepository();
      final router = createRouter();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [dataRepositoryProvider.overrideWithValue(repo)],
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      await completeOnboarding(tester);
      await tester.tap(find.text('Enter App'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Passcode Lock'), 200);
      await tester.tap(find.text('Passcode Lock'));
      await tester.pumpAndSettle();
      await enterDigits(tester, '1234');
      await tester.pumpAndSettle();
      await enterDigits(tester, '1234');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Passcode Lock'));
      await tester.pumpAndSettle();
      await enterDigits(tester, '1234');
      await tester.pumpAndSettle();
      await enterDigits(tester, '5678');
      await tester.pumpAndSettle();
      await enterDigits(tester, '5678');
      await tester.pumpAndSettle();
      expect(find.text('Passcode is set'), findsOneWidget);

      router.go('/lock');
      await tester.pumpAndSettle();
      await enterDigits(tester, '5678');
      await tester.pumpAndSettle();
      expect(find.text('Overview'), findsWidgets);
    });

    testWidgets('remove passcode', (tester) async {
      final repo = DataRepository();
      final router = createRouter();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [dataRepositoryProvider.overrideWithValue(repo)],
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      await completeOnboarding(tester);
      await tester.tap(find.text('Enter App'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Passcode Lock'), 200);
      await tester.tap(find.text('Passcode Lock'));
      await tester.pumpAndSettle();
      await enterDigits(tester, '1234');
      await tester.pumpAndSettle();
      await enterDigits(tester, '1234');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Passcode Lock'));
      await tester.pumpAndSettle();
      await enterDigits(tester, '1234');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Remove passcode'));
      await tester.pumpAndSettle();

      expect(repo.settings.passcode, isNull);

      router.go('/lock');
      await tester.pump();
      await tester
          .runAsync(() => Future.delayed(const Duration(milliseconds: 100)));
      await tester.pumpAndSettle();

      expect(find.textContaining('No passcode configured'), findsOneWidget);
      expect(find.text('Enter App'), findsOneWidget);
    });

    testWidgets('dashboard quick actions', (tester) async {
      final repo = DataRepository();
      final router = createRouter();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [dataRepositoryProvider.overrideWithValue(repo)],
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      await completeOnboarding(tester);
      await tester.tap(find.text('Enter App'));
      await tester.pumpAndSettle();
      expect(find.text('Overview'), findsOneWidget);

      router.go('/transactions');
      await tester.pumpAndSettle();
      expect(find.text('Search transactions...'), findsOneWidget);
      expect(find.text('No transactions found'), findsOneWidget);
      expect(
          find.text('Import a bank statement to get started'), findsOneWidget);
    });
  });
}
