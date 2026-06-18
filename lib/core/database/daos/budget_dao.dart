import 'package:drift/drift.dart';
import '../database.dart';

part 'budget_dao.g.dart';

@DriftAccessor(tables: [Budgets])
class BudgetDao extends DatabaseAccessor<AppDatabase> with _$BudgetDaoMixin {
  BudgetDao(super.db);

  Future<List<BudgetEntry>> getAllBudgets() => select(budgets).get();

  Future<BudgetEntry?> getBudgetById(String id) {
    return (select(budgets)..where((b) => b.id.equals(id))).getSingleOrNull();
  }

  Future<List<BudgetEntry>> getBudgetsForMonth(int month, int year) {
    return (select(budgets)
          ..where((b) => b.month.equals(month) & b.year.equals(year)))
        .get();
  }

  Future<BudgetEntry?> getBudgetForCategory(
      String categoryId, int month, int year) {
    return (select(budgets)
          ..where((b) =>
              b.categoryId.equals(categoryId) &
              b.month.equals(month) &
              b.year.equals(year)))
        .getSingleOrNull();
  }

  Future<int> insertBudget(BudgetEntry entry) {
    return into(budgets).insert(entry);
  }

  Future<int> updateBudget(BudgetEntry entry) {
    return (update(budgets)..whereSamePrimaryKey(entry)).write(entry);
  }

  Future<void> updateSpent(String budgetId, double spent) {
    return customUpdate(
      'UPDATE budgets SET spent = ?, updated_at = ? WHERE id = ?',
      variables: [
        Variable(spent),
        Variable(DateTime.now().millisecondsSinceEpoch),
        Variable(budgetId),
      ],
    );
  }

  Future<int> deleteBudget(String id) {
    return (delete(budgets)..where((b) => b.id.equals(id))).go();
  }

  Future<List<BudgetEntry>> getBudgetsByYear(int year) {
    return (select(budgets)..where((b) => b.year.equals(year))).get();
  }

  Future<int> clearAll() async {
    return delete(budgets).go();
  }

  Future<double> getTotalBudgetedForMonth(int month, int year) {
    return customSelect(
      'SELECT COALESCE(SUM(amount), 0) AS total FROM budgets WHERE month = ? AND year = ?',
      variables: [Variable(month), Variable(year)],
    ).map((row) => row.read<double>('total')).getSingle();
  }

  Future<double> getTotalSpentForMonth(int month, int year) {
    return customSelect(
      'SELECT COALESCE(SUM(spent), 0) AS total FROM budgets WHERE month = ? AND year = ?',
      variables: [Variable(month), Variable(year)],
    ).map((row) => row.read<double>('total')).getSingle();
  }
}
