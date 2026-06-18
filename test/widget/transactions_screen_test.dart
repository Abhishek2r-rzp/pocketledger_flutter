import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../test_helpers.dart';

class MockTransactionsViewModel {
  List<Transaction> transactions = [];
  bool isLoading = false;
  String searchQuery = '';
  String? selectedCategory;
  bool hasError = false;

  List<Transaction> get filteredTransactions {
    var result = transactions;
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toUpperCase();
      result = result.where((t) =>
        (t.merchantName ?? '').toUpperCase().contains(query) ||
        t.rawDescription.toUpperCase().contains(query)
      ).toList();
    }
    if (selectedCategory != null) {
      result = result.where((t) => t.categoryName == selectedCategory).toList();
    }
    return result;
  }
}

final transactionsViewModelProvider = Provider<MockTransactionsViewModel>((ref) {
  return MockTransactionsViewModel();
});

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(transactionsViewModelProvider);
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
              onChanged: (v) => ref.read(transactionsViewModelProvider).searchQuery = v,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: vm.selectedCategory == null,
                  onSelected: (_) => ref.read(transactionsViewModelProvider).selectedCategory = null,
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Food'),
                  selected: vm.selectedCategory == 'Food',
                  onSelected: (_) => ref.read(transactionsViewModelProvider).selectedCategory = 'Food',
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Transport'),
                  selected: vm.selectedCategory == 'Transport',
                  onSelected: (_) => ref.read(transactionsViewModelProvider).selectedCategory = 'Transport',
                ),
              ],
            ),
          ),
          Expanded(
            child: txns.isEmpty
                ? const Center(child: Text('No transactions found'))
                : RefreshIndicator(
                    onRefresh: () async {},
                    child: ListView.builder(
                      itemCount: txns.length,
                      itemBuilder: (context, index) {
                        final txn = txns[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(txn.amount.toStringAsFixed(0)),
                          ),
                          title: Text(txn.merchantName ?? txn.rawDescription),
                          subtitle: Text(txn.transactionDate.toString().split(' ')[0]),
                          trailing: Text(
                            '₹${txn.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: txn.direction == TransactionDirection.expense
                                  ? Colors.red : Colors.green,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

void main() {
  group('TransactionsScreen', () {
    testWidgets('transaction list renders', (tester) async {
      final vm = MockTransactionsViewModel();
      vm.transactions = [
        createTestTransaction(
          id: '1', merchantName: 'Swiggy', amount: 450.0,
          transactionDate: DateTime(2025, 3, 1),
        ),
        createTestTransaction(
          id: '2', merchantName: 'Amazon', amount: 1299.0,
          transactionDate: DateTime(2025, 3, 3),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transactionsViewModelProvider.overrideWith((ref) => vm),
          ],
          child: const MaterialApp(home: TransactionsScreen()),
        ),
      );

      expect(find.text('Swiggy'), findsOneWidget);
      expect(find.text('Amazon'), findsOneWidget);
    });

    testWidgets('search bar is visible', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const MaterialApp(home: TransactionsScreen()),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('Search transactions...'), findsOneWidget);
    });

    testWidgets('filter chips work', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const MaterialApp(home: TransactionsScreen()),
        ),
      );

      expect(find.byType(FilterChip), findsNWidgets(3));
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
      expect(find.text('Transport'), findsOneWidget);
    });

    testWidgets('empty state shows when no transactions', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const MaterialApp(home: TransactionsScreen()),
        ),
      );

      expect(find.text('No transactions found'), findsOneWidget);
    });

    testWidgets('pull to refresh exists', (tester) async {
      final vm = MockTransactionsViewModel();
      vm.transactions = [
        createTestTransaction(
          id: '1', merchantName: 'Swiggy', amount: 450.0,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transactionsViewModelProvider.overrideWith((ref) => vm),
          ],
          child: const MaterialApp(home: TransactionsScreen()),
        ),
      );

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('transactions show amount and direction', (tester) async {
      final vm = MockTransactionsViewModel();
      vm.transactions = [
        createTestTransaction(
          id: '1', merchantName: 'Swiggy', amount: 450.0,
          direction: TransactionDirection.expense,
        ),
        createTestTransaction(
          id: '2', merchantName: 'Salary', amount: 50000.0,
          direction: TransactionDirection.income,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transactionsViewModelProvider.overrideWith((ref) => vm),
          ],
          child: const MaterialApp(home: TransactionsScreen()),
        ),
      );

      expect(find.text('₹450.00'), findsOneWidget);
      expect(find.text('₹50000.00'), findsOneWidget);
    });

    testWidgets('search filters transactions', (tester) async {
      final vm = MockTransactionsViewModel();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transactionsViewModelProvider.overrideWith((ref) => vm),
          ],
          child: const MaterialApp(home: TransactionsScreen()),
        ),
      );

      expect(find.text('No transactions found'), findsOneWidget);
    });

    testWidgets('app bar shows Transactions title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const MaterialApp(home: TransactionsScreen()),
        ),
      );

      expect(find.text('Transactions'), findsOneWidget);
    });
  });
}
