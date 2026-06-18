import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

import '../core/models/budget.dart';
import '../core/models/category.dart';
import '../core/models/enums.dart';
import '../core/models/insight.dart';
import '../core/models/recurring_payment.dart';
import '../core/models/transaction.dart';

const _uuid = Uuid();

class InsightAgent {
  String get name => 'InsightAgent';

  String get purpose =>
      'Generates dashboard insights using local deterministic rules';

  Future<List<Insight>> generateInsights({
    required List<Transaction> transactions,
    required List<Budget> budgets,
    required List<RecurringPayment> recurring,
    required List<Category> categories,
  }) async {
    final insights = <Insight>[];

    insights.addAll(compareMonthOverMonth(transactions));

    final top = topSpendingCategory(transactions, categories);
    if (top != null) insights.add(top);

    final savings = savingsRateInsight(transactions);
    if (savings != null) insights.add(savings);

    final recurringSummary = recurringPaymentSummary(recurring);
    if (recurringSummary != null) insights.add(recurringSummary);

    insights.addAll(unusualTransactionInsight(transactions));

    insights.addAll(budgetStatusInsight(budgets));

    insights.sort((a, b) => a.severity.index.compareTo(b.severity.index));

    return insights;
  }

  List<Insight> compareMonthOverMonth(List<Transaction> transactions) {
    if (transactions.length < 2) return [];

    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month, 1);
    final lastMonthStart = DateTime(now.year, now.month - 1, 1);
    final lastMonthEnd = DateTime(now.year, now.month, 0);

    double spendingInRange(List<Transaction> txs, DateTime start, DateTime end) {
      double total = 0;
      for (final tx in txs) {
        if (tx.date.isAfter(start.subtract(const Duration(days: 1))) &&
            tx.date.isBefore(end.add(const Duration(days: 1))) &&
            tx.direction == TransactionDirection.debit) {
          total += tx.amount;
        }
      }
      return total;
    }

    final thisMonthSpending = spendingInRange(transactions, thisMonth, now);
    final lastMonthSpending =
        spendingInRange(transactions, lastMonthStart, lastMonthEnd);

    if (lastMonthSpending == 0) return [];

    final change =
        ((thisMonthSpending - lastMonthSpending) / lastMonthSpending) * 100;

    final direction = change >= 0 ? 'increased' : 'decreased';
    final absChange = change.abs().toStringAsFixed(0);

    return [
      Insight(
        id: _uuid.v4(),
        title: 'Spending ${change >= 0 ? 'Up' : 'Down'} $absChange%',
        description:
            'Your spending has $direction by $absChange% compared to last month '
            '(₹${thisMonthSpending.toStringAsFixed(0)} vs ₹${lastMonthSpending.toStringAsFixed(0)})',
        type: InsightType.comparison,
        severity: change > 20
            ? InsightSeverity.warning
            : InsightSeverity.info,
        relatedAmount: thisMonthSpending,
        createdAt: DateTime.now(),
      ),
    ];
  }

  Insight? topSpendingCategory(
      List<Transaction> transactions, List<Category> categories) {
    final debitTxs =
        transactions.where((t) => t.direction == TransactionDirection.debit).toList();
    if (debitTxs.isEmpty) return null;

    final categorySpending = <String, double>{};
    for (final tx in debitTxs) {
      final catId = tx.categoryId ?? 'uncategorized';
      categorySpending[catId] =
          (categorySpending[catId] ?? 0) + tx.amount;
    }

    if (categorySpending.isEmpty) return null;

    final topEntry = categorySpending.entries
        .reduce((a, b) => a.value > b.value ? a : b);

    final category =
        categories.where((c) => c.id == topEntry.key).firstOrNull;
    final categoryName = category?.name ?? 'Uncategorized';

    final totalSpending = categorySpending.values.sum;
    final percentage =
        totalSpending > 0 ? (topEntry.value / totalSpending) * 100 : 0;

    return Insight(
      id: _uuid.v4(),
      title: 'Top Category: $categoryName',
      description:
          'You spent ₹${topEntry.value.toStringAsFixed(0)} on $categoryName '
          '(${percentage.toStringAsFixed(0)}% of total spending)',
      type: InsightType.spending,
      severity: InsightSeverity.info,
      relatedCategoryId: topEntry.key,
      relatedAmount: topEntry.value,
      createdAt: DateTime.now(),
    );
  }

  Insight? savingsRateInsight(List<Transaction> transactions) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    double totalIncome = 0;
    double totalSpending = 0;

    for (final tx in transactions) {
      if (tx.date.isBefore(monthStart)) continue;
      if (tx.direction == TransactionDirection.credit) {
        totalIncome += tx.amount;
      } else {
        totalSpending += tx.amount;
      }
    }

    if (totalIncome == 0) return null;

    final savingsRate =
        ((totalIncome - totalSpending) / totalIncome) * 100;

    final severity = savingsRate < 0
        ? InsightSeverity.alert
        : savingsRate < 10
            ? InsightSeverity.warning
            : InsightSeverity.info;

    return Insight(
      id: _uuid.v4(),
      title: savingsRate >= 0
          ? 'Savings Rate: ${savingsRate.toStringAsFixed(0)}%'
          : 'Overspending This Month',
      description: savingsRate >= 0
          ? 'You saved ${savingsRate.toStringAsFixed(0)}% of your income this month '
              '(₹${(totalIncome - totalSpending).toStringAsFixed(0)})'
          : 'You spent ₹${(totalSpending - totalIncome).toStringAsFixed(0)} more than you earned this month',
      type: InsightType.saving,
      severity: severity,
      relatedAmount: totalIncome - totalSpending,
      createdAt: DateTime.now(),
    );
  }

  Insight? recurringPaymentSummary(List<RecurringPayment> recurring) {
    if (recurring.isEmpty) return null;

    final monthlyTotal = recurring
        .where((r) =>
            r.frequency == PaymentFrequency.monthly ||
            r.frequency == PaymentFrequency.weekly)
        .map((r) {
          if (r.frequency == PaymentFrequency.weekly && r.amount != null) {
            return r.amount! * 4.33;
          }
          return r.amount ?? 0;
        })
        .sum;

    return Insight(
      id: _uuid.v4(),
      title: '${recurring.length} Recurring Payments',
      description:
          'You have ${recurring.length} recurring payments totaling '
          '~₹${monthlyTotal.toStringAsFixed(0)}/month',
      type: InsightType.recurring,
      severity: monthlyTotal > 50000
          ? InsightSeverity.warning
          : InsightSeverity.info,
      relatedAmount: monthlyTotal,
      createdAt: DateTime.now(),
    );
  }

  List<Insight> unusualTransactionInsight(List<Transaction> transactions) {
    final insights = <Insight>[];
    final debitTxs =
        transactions.where((t) => t.direction == TransactionDirection.debit).toList();

    if (debitTxs.length < 3) return insights;

    final amounts = debitTxs.map((t) => t.amount).toList();
    final avg = amounts.sum / amounts.length;
    final threshold = avg * 3;

    for (final tx in debitTxs) {
      if (tx.amount > threshold) {
        insights.add(Insight(
          id: _uuid.v4(),
          title: 'Unusual Transaction: ₹${tx.amount.toStringAsFixed(0)}',
          description:
              'A transaction of ₹${tx.amount.toStringAsFixed(0)} to '
              '"${tx.merchantName ?? tx.description}" is '
              '${(tx.amount / avg).toStringAsFixed(1)}x your average transaction',
          type: InsightType.anomaly,
          severity: tx.amount > threshold * 2
              ? InsightSeverity.alert
              : InsightSeverity.warning,
          relatedCategoryId: tx.categoryId,
          relatedAmount: tx.amount,
          createdAt: DateTime.now(),
        ));
      }
    }

    return insights;
  }

  List<Insight> budgetStatusInsight(List<Budget> budgets) {
    final insights = <Insight>[];

    for (final budget in budgets) {
      insights.add(Insight(
        id: _uuid.v4(),
        title: 'Budget: ${budget.categoryName}',
        description:
            'Budget of ₹${budget.amount.toStringAsFixed(0)} for ${budget.categoryName}',
        type: InsightType.summary,
        severity: InsightSeverity.info,
        relatedCategoryId: budget.categoryId,
        relatedAmount: budget.amount,
        createdAt: DateTime.now(),
      ));
    }

    return insights;
  }
}
