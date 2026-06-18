import 'package:flutter_test/flutter_test.dart';
import '../test_helpers.dart';

class BudgetTracker {
  final Map<String, double> _categoryLimits = {};
  final Map<String, String> _categoryNames = {};
  final Map<String, List<Transaction>> _categoryTransactions = {};

  void setBudget(String categoryId, String categoryName, double limit) {
    _categoryLimits[categoryId] = limit;
    _categoryNames[categoryId] = categoryName;
    _categoryTransactions.putIfAbsent(categoryId, () => []);
  }

  void addTransaction(Transaction txn) {
    if (txn.categoryId != null && txn.direction == TransactionDirection.expense) {
      _categoryTransactions.putIfAbsent(txn.categoryId!, () => []);
      _categoryTransactions[txn.categoryId!]!.add(txn);
    }
  }

  double getSpent(String categoryId) {
    final txns = _categoryTransactions[categoryId] ?? [];
    return txns.fold(0.0, (sum, t) => sum + t.amount);
  }

  double getPercentage(String categoryId) {
    final limit = _categoryLimits[categoryId];
    if (limit == null || limit == 0) return 0;
    return (getSpent(categoryId) / limit) * 100;
  }

  bool isWarning(String categoryId) {
    final pct = getPercentage(categoryId);
    return pct >= 80 && pct < 100;
  }

  bool isExceeded(String categoryId) {
    return getPercentage(categoryId) >= 100;
  }

  bool hasBudget(String categoryId) {
    return _categoryLimits.containsKey(categoryId);
  }
}

void main() {
  late BudgetTracker tracker;

  setUp(() {
    tracker = BudgetTracker();
  });

  group('Budget - spent calculation', () {
    test('calculates spent for a category with single transaction', () {
      tracker.setBudget('cat_food', 'Food & Dining', 10000);
      tracker.addTransaction(createTestTransaction(
        categoryId: 'cat_food', amount: 450.0,
        direction: TransactionDirection.expense,
      ));

      expect(tracker.getSpent('cat_food'), 450.0);
    });

    test('aggregates multiple transactions for same category', () {
      tracker.setBudget('cat_food', 'Food & Dining', 10000);
      for (int i = 0; i < 5; i++) {
        tracker.addTransaction(createTestTransaction(
          categoryId: 'cat_food', amount: 450.0,
          direction: TransactionDirection.expense,
        ));
      }

      expect(tracker.getSpent('cat_food'), 2250.0);
    });

    test('income transactions do not affect budget', () {
      tracker.setBudget('cat_salary', 'Salary', 100000);
      tracker.addTransaction(createTestTransaction(
        categoryId: 'cat_salary', amount: 50000.0,
        direction: TransactionDirection.income,
      ));

      expect(tracker.getSpent('cat_salary'), 0.0);
    });

    test('zero spent for category with no transactions', () {
      tracker.setBudget('cat_food', 'Food & Dining', 10000);
      expect(tracker.getSpent('cat_food'), 0.0);
    });

    test('transactions from different categories do not mix', () {
      tracker.setBudget('cat_food', 'Food', 10000);
      tracker.setBudget('cat_transport', 'Transport', 5000);

      tracker.addTransaction(createTestTransaction(
        categoryId: 'cat_food', amount: 450.0,
      ));
      tracker.addTransaction(createTestTransaction(
        categoryId: 'cat_transport', amount: 320.0,
      ));

      expect(tracker.getSpent('cat_food'), 450.0);
      expect(tracker.getSpent('cat_transport'), 320.0);
    });
  });

  group('Budget - percentage calculation', () {
    test('calculates correct percentage', () {
      tracker.setBudget('cat_food', 'Food', 10000);
      tracker.addTransaction(createTestTransaction(
        categoryId: 'cat_food', amount: 2500.0,
      ));

      expect(tracker.getPercentage('cat_food'), 25.0);
    });

    test('returns 0 for category with 0 budget limit', () {
      tracker.setBudget('cat_food', 'Food', 0);
      expect(tracker.getPercentage('cat_food'), 0);
    });

    test('returns 0 for non-existent category', () {
      expect(tracker.getPercentage('nonexistent'), 0);
    });
  });

  group('Budget - 80% threshold triggers warning', () {
    test('spent exactly 80% triggers warning', () {
      tracker.setBudget('cat_food', 'Food', 10000);
      tracker.addTransaction(createTestTransaction(
        categoryId: 'cat_food', amount: 8000.0,
      ));
      expect(tracker.getPercentage('cat_food'), 80.0);
      expect(tracker.isWarning('cat_food'), isTrue);
    });

    test('spent 90% triggers warning', () {
      tracker.setBudget('cat_food', 'Food', 10000);
      tracker.addTransaction(createTestTransaction(
        categoryId: 'cat_food', amount: 9000.0,
      ));
      expect(tracker.isWarning('cat_food'), isTrue);
    });

    test('spent 79% does NOT trigger warning', () {
      tracker.setBudget('cat_food', 'Food', 10000);
      tracker.addTransaction(createTestTransaction(
        categoryId: 'cat_food', amount: 7900.0,
      ));
      expect(tracker.isWarning('cat_food'), isFalse);
    });

    test('spent 99% triggers warning but not exceeded', () {
      tracker.setBudget('cat_food', 'Food', 10000);
      tracker.addTransaction(createTestTransaction(
        categoryId: 'cat_food', amount: 9900.0,
      ));
      expect(tracker.isWarning('cat_food'), isTrue);
      expect(tracker.isExceeded('cat_food'), isFalse);
    });
  });

  group('Budget - 100% threshold triggers exceeded', () {
    test('spent exactly 100% triggers exceeded', () {
      tracker.setBudget('cat_food', 'Food', 10000);
      tracker.addTransaction(createTestTransaction(
        categoryId: 'cat_food', amount: 10000.0,
      ));
      expect(tracker.isExceeded('cat_food'), isTrue);
    });

    test('spent 110% triggers exceeded', () {
      tracker.setBudget('cat_food', 'Food', 10000);
      tracker.addTransaction(createTestTransaction(
        categoryId: 'cat_food', amount: 11000.0,
      ));
      expect(tracker.isExceeded('cat_food'), isTrue);
    });

    test('exceeded should NOT also show warning', () {
      tracker.setBudget('cat_food', 'Food', 10000);
      tracker.addTransaction(createTestTransaction(
        categoryId: 'cat_food', amount: 15000.0,
      ));
      expect(tracker.isWarning('cat_food'), isFalse);
      expect(tracker.isExceeded('cat_food'), isTrue);
    });

    test('multiple transactions that exceed budget', () {
      tracker.setBudget('cat_food', 'Food', 10000);
      tracker.addTransaction(createTestTransaction(
        categoryId: 'cat_food', amount: 5000.0,
      ));
      tracker.addTransaction(createTestTransaction(
        categoryId: 'cat_food', amount: 6000.0,
      ));
      expect(tracker.isExceeded('cat_food'), isTrue);
    });
  });

  group('Budget - no budget', () {
    test('category without budget has no warnings', () {
      expect(tracker.hasBudget('cat_nonexistent'), isFalse);
    });

    test('no budget set returns false for all checks', () {
      expect(tracker.isWarning('cat_nonexistent'), isFalse);
      expect(tracker.isExceeded('cat_nonexistent'), isFalse);
    });
  });

  group('Budget - multiple categories aggregate correctly', () {
    test('multiple budgets track independently', () {
      tracker.setBudget('cat_food', 'Food', 10000);
      tracker.setBudget('cat_transport', 'Transport', 5000);
      tracker.setBudget('cat_shopping', 'Shopping', 20000);

      tracker.addTransaction(createTestTransaction(categoryId: 'cat_food', amount: 8500.0));
      tracker.addTransaction(createTestTransaction(categoryId: 'cat_transport', amount: 3000.0));
      tracker.addTransaction(createTestTransaction(categoryId: 'cat_shopping', amount: 5000.0));

      expect(tracker.isWarning('cat_food'), isTrue);
      expect(tracker.isWarning('cat_transport'), isFalse);
      expect(tracker.isWarning('cat_shopping'), isFalse);
      expect(tracker.getSpent('cat_food'), 8500.0);
      expect(tracker.getSpent('cat_transport'), 3000.0);
      expect(tracker.getSpent('cat_shopping'), 5000.0);
    });

    test('adding transaction updates spent correctly', () {
      tracker.setBudget('cat_food', 'Food', 10000);
      tracker.addTransaction(createTestTransaction(categoryId: 'cat_food', amount: 3000.0));
      expect(tracker.getSpent('cat_food'), 3000.0);

      tracker.addTransaction(createTestTransaction(categoryId: 'cat_food', amount: 2000.0));
      expect(tracker.getSpent('cat_food'), 5000.0);
    });
  });
}
