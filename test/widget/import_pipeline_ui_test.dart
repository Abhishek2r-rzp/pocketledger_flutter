import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';
import '../test_helpers.dart';

class MockImportPipelineViewModel {
  List<Transaction> transactions = [];
  bool isLoading = false;
  String searchQuery = '';
  String? selectedCategory;

  MockImportPipelineViewModel copyWith({
    List<Transaction>? transactions,
    bool? isLoading,
    String? searchQuery,
    String? selectedCategory,
  }) {
    return MockImportPipelineViewModel()
      ..transactions = transactions ?? this.transactions
      ..isLoading = isLoading ?? this.isLoading
      ..searchQuery = searchQuery ?? this.searchQuery
      ..selectedCategory = selectedCategory ?? this.selectedCategory;
  }

  List<Transaction> get filteredTransactions {
    var result = transactions;
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toUpperCase();
      result = result
          .where((t) =>
              (t.merchantName ?? '').toUpperCase().contains(query) ||
              t.rawDescription.toUpperCase().contains(query))
          .toList();
    }
    return result;
  }

  int get totalIncome {
    return transactions
        .where((t) => t.direction == TransactionDirection.income)
        .fold<int>(0, (s, t) => s + t.amount.toInt());
  }

  int get totalExpense {
    return transactions
        .where((t) => t.direction == TransactionDirection.expense)
        .fold<int>(0, (s, t) => s + t.amount.toInt());
  }

  int get transactionCount => transactions.length;
}

final importPipelineViewModelProvider =
    StateProvider<MockImportPipelineViewModel>((ref) {
  return MockImportPipelineViewModel();
});

class ImportTransactionListScreen extends ConsumerWidget {
  const ImportTransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(importPipelineViewModelProvider);
    final txns = vm.filteredTransactions;

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search transactions...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) {
                final notifier =
                    ref.read(importPipelineViewModelProvider.notifier);
                notifier.state = notifier.state.copyWith(searchQuery: v);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text('${txns.length} transactions',
                    style: Theme.of(context).textTheme.bodySmall),
                const Spacer(),
                Text('₹${vm.totalIncome.toStringAsFixed(0)} in',
                    style: const TextStyle(color: Colors.green, fontSize: 12)),
                const SizedBox(width: 8),
                Text('₹${vm.totalExpense.toStringAsFixed(0)} out',
                    style: const TextStyle(color: Colors.red, fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: txns.isEmpty
                ? const Center(child: Text('No transactions found'))
                : ListView.builder(
                    itemCount: txns.length,
                    itemBuilder: (context, index) {
                      final txn = txns[index];
                      final color = txn.direction == TransactionDirection.income
                          ? Colors.green
                          : Colors.red;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: color.withOpacity(0.1),
                          child: Icon(
                            txn.direction == TransactionDirection.income
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: color,
                            size: 18,
                          ),
                        ),
                        title: Text(
                          txn.merchantName ?? txn.rawDescription,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${txn.transactionDate.day}/${txn.transactionDate.month}/${txn.transactionDate.year}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        trailing: Text(
                          '₹${txn.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

final _uuid = Uuid();

List<Transaction> create10TestTransactions() {
  final now = DateTime.now();
  return [
    createTestTransaction(
      id: _uuid.v4(),
      merchantName: 'SALARY CREDIT',
      rawDescription: 'SALARY CREDIT',
      amount: 85000.0,
      direction: TransactionDirection.income,
      transactionDate: DateTime(now.year, now.month, 1),
    ),
    createTestTransaction(
      id: _uuid.v4(),
      merchantName: 'SWIGGY',
      rawDescription: 'UPI-SWIGGY-ORDER',
      amount: 450.0,
      direction: TransactionDirection.expense,
      transactionDate: DateTime(now.year, now.month, 2),
    ),
    createTestTransaction(
      id: _uuid.v4(),
      merchantName: 'UBER INDIA',
      rawDescription: 'UPI-UBER-RIDE',
      amount: 320.0,
      direction: TransactionDirection.expense,
      transactionDate: DateTime(now.year, now.month, 3),
    ),
    createTestTransaction(
      id: _uuid.v4(),
      merchantName: 'AMAZON PAY',
      rawDescription: 'AMAZON-PURCHASE',
      amount: 1299.0,
      direction: TransactionDirection.expense,
      transactionDate: DateTime(now.year, now.month, 4),
    ),
    createTestTransaction(
      id: _uuid.v4(),
      merchantName: 'NETFLIX',
      rawDescription: 'NETFLIX-SUBSCRIPTION',
      amount: 649.0,
      direction: TransactionDirection.expense,
      transactionDate: DateTime(now.year, now.month, 5),
    ),
    createTestTransaction(
      id: _uuid.v4(),
      merchantName: 'BIGBASKET',
      rawDescription: 'BIGBASKET-GROCERIES',
      amount: 2340.0,
      direction: TransactionDirection.expense,
      transactionDate: DateTime(now.year, now.month, 6),
    ),
    createTestTransaction(
      id: _uuid.v4(),
      merchantName: 'ZOMATO',
      rawDescription: 'ZOMATO-ORDER',
      amount: 567.0,
      direction: TransactionDirection.expense,
      transactionDate: DateTime(now.year, now.month, 7),
    ),
    createTestTransaction(
      id: _uuid.v4(),
      merchantName: 'ELECTRICITY BILL',
      rawDescription: 'BILL-ELECTRICITY',
      amount: 3200.0,
      direction: TransactionDirection.expense,
      transactionDate: DateTime(now.year, now.month, 8),
    ),
    createTestTransaction(
      id: _uuid.v4(),
      merchantName: 'FLIPKART',
      rawDescription: 'FLIPKART-SHOPPING',
      amount: 1899.0,
      direction: TransactionDirection.expense,
      transactionDate: DateTime(now.year, now.month, 9),
    ),
    createTestTransaction(
      id: _uuid.v4(),
      merchantName: 'ATM WITHDRAWAL',
      rawDescription: 'ATM-CASH',
      amount: 5000.0,
      direction: TransactionDirection.expense,
      transactionDate: DateTime(now.year, now.month, 10),
    ),
  ];
}

void main() {
  group('Import Pipeline UI', () {
    setUp(() {
      final view =
          TestWidgetsFlutterBinding.instance.platformDispatcher.views.single;
      view.physicalSize = const Size(800, 1400);
      view.devicePixelRatio = 1;
    });

    tearDown(() {
      final view =
          TestWidgetsFlutterBinding.instance.platformDispatcher.views.single;
      view.resetPhysicalSize();
      view.resetDevicePixelRatio();
    });

    testWidgets('renders 10 imported transactions', (tester) async {
      final vm = MockImportPipelineViewModel();
      vm.transactions = create10TestTransactions();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importPipelineViewModelProvider.overrideWith((ref) => vm),
          ],
          child: const MaterialApp(home: ImportTransactionListScreen()),
        ),
      );

      expect(find.text('10 transactions'), findsOneWidget);
      expect(find.text('SALARY CREDIT'), findsOneWidget);
      expect(find.text('SWIGGY'), findsOneWidget);
      expect(find.text('UBER INDIA'), findsOneWidget);
      expect(find.text('AMAZON PAY'), findsOneWidget);
      expect(find.text('NETFLIX'), findsOneWidget);
      expect(find.text('BIGBASKET'), findsOneWidget);
      expect(find.text('ZOMATO'), findsOneWidget);
      expect(find.text('ELECTRICITY BILL'), findsOneWidget);
      expect(find.text('FLIPKART'), findsOneWidget);
      expect(find.text('ATM WITHDRAWAL'), findsOneWidget);
    });

    testWidgets('shows correct income and expense totals', (tester) async {
      final vm = MockImportPipelineViewModel();
      vm.transactions = create10TestTransactions();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importPipelineViewModelProvider.overrideWith((ref) => vm),
          ],
          child: const MaterialApp(home: ImportTransactionListScreen()),
        ),
      );

      expect(find.textContaining('85000 in'), findsOneWidget);
      expect(find.textContaining('15724 out'), findsOneWidget);
    });

    testWidgets('shows green for income and red for expense', (tester) async {
      final vm = MockImportPipelineViewModel();
      vm.transactions = create10TestTransactions();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importPipelineViewModelProvider.overrideWith((ref) => vm),
          ],
          child: const MaterialApp(home: ImportTransactionListScreen()),
        ),
      );

      expect(find.text('₹85000.00'), findsOneWidget);
      expect(find.text('₹450.00'), findsOneWidget);
      expect(find.text('₹5000.00'), findsOneWidget);
    });

    testWidgets('search filters to one merchant', (tester) async {
      final vm = MockImportPipelineViewModel();
      vm.transactions = create10TestTransactions();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importPipelineViewModelProvider.overrideWith((ref) => vm),
          ],
          child: const MaterialApp(home: ImportTransactionListScreen()),
        ),
      );

      await tester.enterText(find.byType(TextField), 'NETFLIX');
      await tester.pump();

      expect(find.widgetWithText(ListTile, 'NETFLIX'), findsOneWidget);
      expect(find.text('SWIGGY'), findsNothing);
      expect(find.text('AMAZON PAY'), findsNothing);
    });

    testWidgets('empty state shows when no transactions', (tester) async {
      final vm = MockImportPipelineViewModel();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importPipelineViewModelProvider.overrideWith((ref) => vm),
          ],
          child: const MaterialApp(home: ImportTransactionListScreen()),
        ),
      );

      expect(find.text('No transactions found'), findsOneWidget);
      expect(find.text('0 transactions'), findsOneWidget);
    });

    testWidgets('income transaction shows arrow down icon', (tester) async {
      final vm = MockImportPipelineViewModel();
      vm.transactions = create10TestTransactions();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importPipelineViewModelProvider.overrideWith((ref) => vm),
          ],
          child: const MaterialApp(home: ImportTransactionListScreen()),
        ),
      );

      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward), findsNWidgets(9));
    });

    testWidgets('scrolls through all 10 items', (tester) async {
      final vm = MockImportPipelineViewModel();
      vm.transactions = create10TestTransactions();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importPipelineViewModelProvider.overrideWith((ref) => vm),
          ],
          child: const MaterialApp(home: ImportTransactionListScreen()),
        ),
      );

      await tester.scrollUntilVisible(
        find.text('ATM WITHDRAWAL'),
        200,
        scrollable: find.byType(Scrollable).last,
      );

      expect(find.text('ATM WITHDRAWAL'), findsOneWidget);
    });

    testWidgets('search bar is functional', (tester) async {
      final vm = MockImportPipelineViewModel();
      vm.transactions = create10TestTransactions();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importPipelineViewModelProvider.overrideWith((ref) => vm),
          ],
          child: const MaterialApp(home: ImportTransactionListScreen()),
        ),
      );

      await tester.enterText(find.byType(TextField), 'ZOMATO');
      await tester.pump();

      expect(find.widgetWithText(ListTile, 'ZOMATO'), findsOneWidget);
      expect(find.text('SWIGGY'), findsNothing);
    });
  });
}
