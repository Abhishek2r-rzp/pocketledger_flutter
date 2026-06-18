import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/core/models/transaction.dart';
import 'package:pocketledger/services/search_service.dart';

final transactionSearchProvider = StateProvider<String>((ref) => '');
final transactionSortProvider = StateProvider<String>((ref) => 'date');
final transactionDirectionFilterProvider = StateProvider<TransactionDirection?>((ref) => null);

class TransactionsNotifier extends AsyncNotifier<List<Transaction>> {
  final _searchService = SearchService();

  @override
  Future<List<Transaction>> build() async {
    final repo = ref.read(dataRepositoryProvider);
    final searchQuery = ref.watch(transactionSearchProvider);
    final sortBy = ref.watch(transactionSortProvider);
    final directionFilter = ref.watch(transactionDirectionFilterProvider);

    var transactions = repo.transactions;

    if (searchQuery.isNotEmpty) {
      transactions = _searchService.search(transactions, searchQuery);
    }

    if (directionFilter != null) {
      transactions = _searchService.filter(
        transactions,
        direction: directionFilter,
      );
    }

    transactions = _searchService.filter(
      transactions,
      sortBy: sortBy,
      ascending: false,
    );

    return transactions;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

final transactionsProvider = AsyncNotifierProvider<TransactionsNotifier, List<Transaction>>(() {
  return TransactionsNotifier();
});
