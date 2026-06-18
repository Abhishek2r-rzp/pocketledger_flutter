import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../test_helpers.dart';

class MockDashboardViewModel {
  double totalIncome = 50000.0;
  double totalExpenses = 22535.0;
  double balance = 133426.0;
  int reviewCount = 3;
  bool isLoading = false;
  bool hasError = false;
  String? errorMessage;

  List<_CategorySummaryItem> categoryBreakdown = [];
}

class _CategorySummaryItem {
  final String name;
  final double amount;
  final String icon;
  final double percentage;

  const _CategorySummaryItem({
    required this.name,
    required this.amount,
    required this.icon,
    required this.percentage,
  });
}

final dashboardViewModelProvider = Provider<MockDashboardViewModel>((ref) {
  return MockDashboardViewModel();
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(dashboardViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PocketLedger'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed('/import'),
            tooltip: 'Import',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Dashboard', style: theme.textTheme.headlineSmall),
            ),
            if (vm.reviewCount > 0)
              Card(
                color: Colors.orange.shade50,
                child: ListTile(
                  leading: const Icon(Icons.rate_review, color: Colors.orange),
                  title: Text('${vm.reviewCount} items to review'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).pushNamed('/review-queue'),
                ),
              ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _SummaryCard(
                          title: 'Income',
                          amount: vm.totalIncome,
                          icon: Icons.arrow_downward,
                          color: Colors.green,
                        ),
                        _SummaryCard(
                          title: 'Expenses',
                          amount: vm.totalExpenses,
                          icon: Icons.arrow_upward,
                          color: Colors.red,
                        ),
                        _SummaryCard(
                          title: 'Balance',
                          amount: vm.balance,
                          icon: Icons.account_balance,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Spending Breakdown', style: theme.textTheme.titleMedium),
            ),
            const SizedBox(
              height: 200,
              child: Center(child: Text('Chart area')),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          '₹${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

void main() {
  group('DashboardScreen', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const DashboardScreen(),
          ),
        ),
      );
      expect(find.byType(DashboardScreen), findsOneWidget);
    });

    testWidgets('summary cards are displayed', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const DashboardScreen(),
          ),
        ),
      );

      expect(find.text('Income'), findsOneWidget);
      expect(find.text('Expenses'), findsOneWidget);
      expect(find.text('Balance'), findsOneWidget);
      expect(find.text('₹50000'), findsOneWidget);
      expect(find.text('₹22535'), findsOneWidget);
      expect(find.text('₹133426'), findsOneWidget);
    });

    testWidgets('import button exists', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const DashboardScreen(),
          ),
        ),
      );

      expect(find.byTooltip('Import'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('review badge shows when there are items to review', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const DashboardScreen(),
          ),
        ),
      );

      expect(find.text('3 items to review'), findsOneWidget);
      expect(find.byIcon(Icons.rate_review), findsOneWidget);
    });

    testWidgets('review badge is absent when review count is zero', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardViewModelProvider.overrideWith((ref) {
              final vm = MockDashboardViewModel();
              vm.reviewCount = 0;
              return vm;
            }),
          ],
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      expect(find.text('0 items to review'), findsNothing);
      expect(find.byIcon(Icons.rate_review), findsNothing);
    });

    testWidgets('charts section renders', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const DashboardScreen(),
          ),
        ),
      );

      expect(find.text('Spending Breakdown'), findsOneWidget);
      expect(find.text('Chart area'), findsOneWidget);
    });

    testWidgets('pressing import navigates to import screen', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const DashboardScreen(),
            routes: {
              '/import': (_) => const Scaffold(body: Text('ImportScreen')),
            },
          ),
        ),
      );

      await tester.tap(find.byTooltip('Import'));
      await tester.pumpAndSettle();

      expect(find.text('ImportScreen'), findsOneWidget);
    });

    testWidgets('pressing review navigates to review queue', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const DashboardScreen(),
            routes: {
              '/review-queue': (_) => const Scaffold(body: Text('ReviewQueueScreen')),
            },
          ),
        ),
      );

      await tester.tap(find.text('3 items to review'));
      await tester.pumpAndSettle();

      expect(find.text('ReviewQueueScreen'), findsOneWidget);
    });

    testWidgets('pull to refresh is available', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const DashboardScreen(),
          ),
        ),
      );

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });
  });
}
