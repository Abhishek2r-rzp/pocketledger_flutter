import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/core/models/budget.dart';
import 'package:pocketledger/core/models/transaction.dart';

class BudgetsNotifier extends AsyncNotifier<List<Budget>> {
  @override
  Future<List<Budget>> build() async {
    final repo = ref.read(dataRepositoryProvider);
    final budgets = repo.budgets;
    final transactions = repo.transactions;
    final now = DateTime.now();

    return budgets.map((budget) {
      final spent = transactions
          .where((t) =>
              t.categoryId == budget.categoryId &&
              t.direction == TransactionDirection.expense &&
              t.date.month == now.month &&
              t.date.year == now.year)
          .fold<double>(0, (s, t) => s + t.amount);
      return budget;
    }).toList();
  }

  double spentForBudget(Budget budget) {
    final repo = ref.read(dataRepositoryProvider);
    final now = DateTime.now();
    return repo.transactions
        .where((t) =>
            t.categoryId == budget.categoryId &&
            t.direction == TransactionDirection.expense &&
            t.date.month == now.month &&
            t.date.year == now.year)
        .fold<double>(0, (s, t) => s + t.amount);
  }

  Future<void> addBudget(String categoryId, String categoryName, double amount) async {
    final repo = ref.read(dataRepositoryProvider);
    final now = DateTime.now();
    final budget = Budget(
      id: const Uuid().v4(),
      categoryId: categoryId,
      categoryName: categoryName,
      amount: amount,
      month: now.month,
      year: now.year,
      createdAt: now,
    );
    repo.addBudget(budget);
    ref.invalidateSelf();
  }

  Future<void> deleteBudget(String id) async {
    final repo = ref.read(dataRepositoryProvider);
    repo.deleteBudget(id);
    ref.invalidateSelf();
  }
}

final budgetsProvider = AsyncNotifierProvider<BudgetsNotifier, List<Budget>>(() {
  return BudgetsNotifier();
});
