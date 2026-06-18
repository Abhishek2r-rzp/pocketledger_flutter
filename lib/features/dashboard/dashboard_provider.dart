import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/core/models/category.dart';
import 'package:pocketledger/core/models/transaction.dart';

class DashboardData {
  final double totalIncome;
  final double totalExpenses;
  final double savings;
  final double savingsRate;
  final int needsReviewCount;
  final List<({int month, double income, double expense})> monthlyData;
  final List<({String categoryId, double amount})> categoryTotals;
  final List<({String icon, String title, String description})> insights;
  final List<Category> categories;

  DashboardData({
    required this.totalIncome,
    required this.totalExpenses,
    required this.savings,
    required this.savingsRate,
    required this.needsReviewCount,
    required this.monthlyData,
    required this.categoryTotals,
    required this.insights,
    required this.categories,
  });
}

class DashboardDataNotifier extends AsyncNotifier<DashboardData> {
  @override
  Future<DashboardData> build() async {
    return _loadData();
  }

  Future<DashboardData> _loadData() async {
    final repo = ref.read(dataRepositoryProvider);
    final transactions = repo.transactions;
    final categories = repo.categories;
    final reviewCount = repo.reviewItems.length;

    final now = DateTime.now();
    final thisMonth = transactions.where((t) =>
        t.date.month == now.month && t.date.year == now.year);

    final totalIncome = thisMonth
        .where((t) => t.direction == TransactionDirection.income)
        .fold<double>(0, (s, t) => s + t.amount);

    final totalExpenses = thisMonth
        .where((t) => t.direction == TransactionDirection.expense)
        .fold<double>(0, (s, t) => s + t.amount);

    final savings = totalIncome - totalExpenses;
    final savingsRate = totalIncome > 0 ? (savings / totalIncome) * 100 : 0.0;

    final monthlyData = _computeMonthlyData(transactions);

    final categoryTotals = _computeCategoryTotals(transactions);

    final insights = _generateInsights(
      transactions,
      categories,
      totalIncome,
      totalExpenses,
      savingsRate,
    );

    return DashboardData(
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      savings: savings,
      savingsRate: savingsRate,
      needsReviewCount: reviewCount,
      monthlyData: monthlyData,
      categoryTotals: categoryTotals,
      insights: insights,
      categories: categories,
    );
  }

  List<({int month, double income, double expense})> _computeMonthlyData(List<Transaction> transactions) {
    final now = DateTime.now();
    final result = <({int month, double income, double expense})>[];

    for (int i = 5; i >= 0; i--) {
      final month = now.month - i;
      final year = now.year + (month <= 0 ? -1 : 0);
      final m = month <= 0 ? month + 12 : month;
      final y = month <= 0 ? year : now.year;

      final monthTxns = transactions.where((t) => t.date.month == m && t.date.year == y).toList();

      final income = monthTxns
          .where((t) => t.direction == TransactionDirection.income)
          .fold<double>(0, (s, t) => s + t.amount);

      final expense = monthTxns
          .where((t) => t.direction == TransactionDirection.expense)
          .fold<double>(0, (s, t) => s + t.amount);

      result.add((month: m, income: income, expense: expense));
    }

    return result;
  }

  List<({String categoryId, double amount})> _computeCategoryTotals(List<Transaction> transactions) {
    final now = DateTime.now();
    final currentMonth = transactions.where((t) =>
        t.date.month == now.month && t.date.year == now.year);

    final groups = currentMonth
        .where((t) => t.direction == TransactionDirection.expense)
        .groupListsBy((t) => t.categoryId ?? 'uncategorized');

    return groups.entries
        .map((e) => (
              categoryId: e.key,
              amount: e.value.fold<double>(0, (s, t) => s + t.amount),
            ))
        .sorted((a, b) => b.amount.compareTo(a.amount))
        .toList();
  }

  List<({String icon, String title, String description})> _generateInsights(
    List<Transaction> transactions,
    List<Category> categories,
    double income,
    double expenses,
    double savingsRate,
  ) {
    final insights = <({String icon, String title, String description})>[];

    if (savingsRate < 0) {
      insights.add((
        icon: 'warning',
        title: 'Spending exceeds income',
        description: 'Your expenses are higher than your income this month. Consider reviewing your spending.',
      ));
    } else if (savingsRate < 20) {
      insights.add((
        icon: 'info',
        title: 'Low savings rate',
        description: 'Your savings rate is ${savingsRate.toStringAsFixed(0)}%. Aim for at least 20%.',
      ));
    }

    final topCategory = _computeCategoryTotals(transactions).firstOrNull;
    if (topCategory != null) {
      final cat = categories.where((c) => c.id == topCategory.categoryId).firstOrNull;
      insights.add((
        icon: 'trending_up',
        title: 'Top spending category',
        description: 'Your highest spend this month is ${cat?.name ?? 'Unknown'} at ₹${topCategory.amount.toStringAsFixed(0)}.',
      ));
    }

    if (transactions.length > 10) {
      insights.add((
        icon: 'receipt',
        title: '${transactions.length} total transactions',
        description: 'You have ${transactions.length} tracked transactions. Keep your financial records up to date.',
      ));
    }

    return insights;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadData());
  }
}

final dashboardDataProvider = AsyncNotifierProvider<DashboardDataNotifier, DashboardData>(() {
  return DashboardDataNotifier();
});
