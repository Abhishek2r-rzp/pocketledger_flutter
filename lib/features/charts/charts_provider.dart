import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:collection/collection.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/core/models/transaction.dart';

final chartsSegmentProvider = StateProvider<String>((ref) => 'overview');

class ChartsData {
  final List<({int month, double income, double expense})> monthlyIncomeExpense;
  final List<({String categoryId, double amount})> categorySpend;
  final List<({DateTime date, double amount})> dailySpending;
  final List<({String name, double amount})> topMerchants;
  final List<({int month, double rate})> savingsRateTrend;

  ChartsData({
    required this.monthlyIncomeExpense,
    required this.categorySpend,
    required this.dailySpending,
    required this.topMerchants,
    required this.savingsRateTrend,
  });
}

class ChartsDataNotifier extends AsyncNotifier<ChartsData> {
  @override
  Future<ChartsData> build() async {
    return _loadData();
  }

  ChartsData _loadData() {
    final repo = ref.read(dataRepositoryProvider);
    final transactions = repo.transactions;

    return ChartsData(
      monthlyIncomeExpense: _computeMonthlyIncomeExpense(transactions),
      categorySpend: _computeCategorySpend(transactions),
      dailySpending: _computeDailySpending(transactions),
      topMerchants: _computeTopMerchants(transactions),
      savingsRateTrend: _computeSavingsRateTrend(transactions),
    );
  }

  List<({int month, double income, double expense})> _computeMonthlyIncomeExpense(List<Transaction> transactions) {
    final now = DateTime.now();
    final result = <({int month, double income, double expense})>[];

    for (int i = 11; i >= 0; i--) {
      final month = now.month - i;
      final y = now.year + (month <= 0 ? -1 : 0);
      final m = month <= 0 ? month + 12 : month;

      final monthTxns = transactions.where((t) => t.date.month == m && t.date.year == y).toList();

      result.add((
        month: m,
        income: monthTxns.where((t) => t.direction == TransactionDirection.income).fold<double>(0, (s, t) => s + t.amount),
        expense: monthTxns.where((t) => t.direction == TransactionDirection.expense).fold<double>(0, (s, t) => s + t.amount),
      ));
    }

    return result;
  }

  List<({String categoryId, double amount})> _computeCategorySpend(List<Transaction> transactions) {
    final now = DateTime.now();
    final currentMonth = transactions.where((t) =>
        t.date.month == now.month && t.date.year == now.year && t.direction == TransactionDirection.expense);

    final groups = currentMonth.groupListsBy((t) => t.categoryId ?? 'uncategorized');

    return groups.entries
        .map((e) => (categoryId: e.key, amount: e.value.fold<double>(0, (s, t) => s + t.amount)))
        .sorted((a, b) => b.amount.compareTo(a.amount))
        .toList();
  }

  List<({DateTime date, double amount})> _computeDailySpending(List<Transaction> transactions) {
    final now = DateTime.now();
    final result = <({DateTime date, double amount})>[];

    for (int i = 29; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final dayTxns = transactions.where((t) =>
          t.date.year == day.year &&
          t.date.month == day.month &&
          t.date.day == day.day &&
          t.direction == TransactionDirection.expense);

      final total = dayTxns.fold<double>(0, (s, t) => s + t.amount);
      result.add((date: day, amount: total));
    }

    return result;
  }

  List<({String name, double amount})> _computeTopMerchants(List<Transaction> transactions) {
    final now = DateTime.now();
    final currentMonth = transactions.where((t) =>
        t.date.month == now.month && t.date.year == now.year && t.direction == TransactionDirection.expense);

    final groups = currentMonth.groupListsBy((t) => t.merchantName ?? 'Unknown');

    return groups.entries
        .map((e) => (name: e.key, amount: e.value.fold<double>(0, (s, t) => s + t.amount)))
        .sorted((a, b) => b.amount.compareTo(a.amount))
        .take(6)
        .toList();
  }

  List<({int month, double rate})> _computeSavingsRateTrend(List<Transaction> transactions) {
    final now = DateTime.now();
    final result = <({int month, double rate})>[];

    for (int i = 11; i >= 0; i--) {
      final month = now.month - i;
      final y = now.year + (month <= 0 ? -1 : 0);
      final m = month <= 0 ? month + 12 : month;

      final monthTxns = transactions.where((t) => t.date.month == m && t.date.year == y).toList();

      final income = monthTxns.where((t) => t.direction == TransactionDirection.income).fold<double>(0, (s, t) => s + t.amount);
      final expense = monthTxns.where((t) => t.direction == TransactionDirection.expense).fold<double>(0, (s, t) => s + t.amount);
      final rate = income > 0 ? ((income - expense) / income * 100) : 0.0;

      result.add((month: m, rate: rate));
    }

    return result;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => Future.value(_loadData()));
  }
}

final chartsDataProvider = AsyncNotifierProvider<ChartsDataNotifier, ChartsData>(() {
  return ChartsDataNotifier();
});
