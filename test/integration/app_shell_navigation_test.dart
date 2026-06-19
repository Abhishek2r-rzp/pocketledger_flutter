import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pocketledger/app.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/core/theme/app_colors.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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

  Future<void> openAppWithoutPasscode(WidgetTester tester) async {
    await completeOnboarding(tester);
    expect(find.text('Enter App'), findsOneWidget);

    await tester.tap(find.text('Enter App'));
    await tester.pumpAndSettle();
  }

  group('App shell navigation e2e', () {
    testWidgets('bottom navigation moves through the primary app sections',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dataRepositoryProvider.overrideWithValue(DataRepository()),
          ],
          child: const PocketLedgerApp(),
        ),
      );

      await openAppWithoutPasscode(tester);

      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Activity'), findsOneWidget);
      expect(find.text('Insights'), findsOneWidget);
      expect(find.text('Plans'), findsOneWidget);
      expect(find.text('More'), findsOneWidget);

      final scaffoldTheme = Theme.of(tester.element(find.text('Overview')))
          .scaffoldBackgroundColor;
      expect(scaffoldTheme, AppColors.background);

      await tester.tap(find.text('Activity'));
      await tester.pumpAndSettle();
      expect(find.text('Transactions'), findsOneWidget);

      await tester.tap(find.text('Insights'));
      await tester.pumpAndSettle();
      expect(find.text('Analytics'), findsOneWidget);

      await tester.tap(find.text('Plans'));
      await tester.pumpAndSettle();
      expect(find.text('Budgets'), findsOneWidget);

      await tester.tap(find.text('More'));
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Overview'), findsOneWidget);
    });
  });
}
