class Budget {
  final String id;
  final String categoryId;
  final String categoryName;
  final double amount;
  final int month;
  final int year;
  final DateTime createdAt;

  const Budget({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.month,
    required this.year,
    required this.createdAt,
  });

  double get spent => 0.0;
  double get progress => amount > 0 ? (spent / amount) : 0;

  Budget copyWith({
    String? id,
    String? categoryId,
    String? categoryName,
    double? amount,
    int? month,
    int? year,
    DateTime? createdAt,
  }) {
    return Budget(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      amount: amount ?? this.amount,
      month: month ?? this.month,
      year: year ?? this.year,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum WarningType { warning, exceeded }

class BudgetWarning {
  final String id;
  final String budgetId;
  final String categoryId;
  final String categoryName;
  final double budgetAmount;
  final double spentAmount;
  final double percentage;
  final WarningType type;

  const BudgetWarning({
    required this.id,
    required this.budgetId,
    required this.categoryId,
    required this.categoryName,
    required this.budgetAmount,
    required this.spentAmount,
    required this.percentage,
    required this.type,
  });
}
