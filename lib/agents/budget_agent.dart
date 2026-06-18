import 'package:uuid/uuid.dart';

import '../core/database/app_database.dart';
import '../core/models/budget.dart';
import '../core/models/transaction.dart';

const _uuid = Uuid();

class BudgetAgent {
  String get name => 'BudgetAgent';

  String get purpose =>
      'Tracks category budgets and creates warnings';

  Future<List<BudgetWarning>> recalculateBudgets(
      AgentDatabase database) async {
    final budgets = await database.getBudgets();
    final warnings = <BudgetWarning>[];

    for (final budget in budgets) {
      final progress = await budgetProgress(
        categoryId: budget.categoryId,
        month: budget.month,
        year: budget.year,
        database: database,
      );

      if (progress.percentage >= 80) {
        warnings.add(BudgetWarning(
          id: _uuid.v4(),
          budgetId: budget.id,
          categoryId: budget.categoryId,
          categoryName: budget.categoryName,
          budgetAmount: budget.amount,
          spentAmount: progress.spent,
          percentage: progress.percentage,
          type: progress.percentage >= 100
              ? WarningType.exceeded
              : WarningType.warning,
        ));
      }
    }

    return warnings;
  }

  Future<({Budget? budget, double spent, double percentage})>
      budgetProgress({
    required String categoryId,
    required int month,
    required int year,
    required AgentDatabase database,
  }) async {
    final budget =
        await database.getBudgetForCategory(categoryId, month, year);

    final startDate = DateTime(year, month, 1);
    final endDate = month < 12
        ? DateTime(year, month + 1, 0, 23, 59, 59)
        : DateTime(year + 1, 1, 0, 23, 59, 59);

    final periodTransactions =
        await database.getTransactionsForPeriod(startDate, endDate);

    double spent = 0;
    for (final tx in periodTransactions) {
      if (tx.categoryId == categoryId &&
          tx.direction == TransactionDirection.debit) {
        spent += tx.amount;
      }
    }

    final percentage =
        budget != null && budget.amount > 0 ? (spent / budget.amount) * 100 : 0.0;

    return (
      budget: budget,
      spent: spent,
      percentage: percentage,
    );
  }

  Future<List<BudgetWarning>> generateWarnings(
      AgentDatabase database) async {
    return recalculateBudgets(database);
  }
}
