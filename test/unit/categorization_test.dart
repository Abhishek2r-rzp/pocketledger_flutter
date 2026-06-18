import 'package:flutter_test/flutter_test.dart';

class CategoryRule {
  final String pattern;
  final String categoryName;
  final double confidence;
  final bool isUserRule;

  const CategoryRule({
    required this.pattern,
    required this.categoryName,
    this.confidence = 0.9,
    this.isUserRule = false,
  });
}

final List<CategoryRule> builtinRules = [
  CategoryRule(pattern: 'swiggy', categoryName: 'Food Delivery', confidence: 0.9),
  CategoryRule(pattern: 'zomato', categoryName: 'Food Delivery', confidence: 0.9),
  CategoryRule(pattern: 'uber', categoryName: 'Transport', confidence: 0.9),
  CategoryRule(pattern: 'ola', categoryName: 'Transport', confidence: 0.9),
  CategoryRule(pattern: 'amazon', categoryName: 'Shopping', confidence: 0.85),
  CategoryRule(pattern: 'flipkart', categoryName: 'Shopping', confidence: 0.85),
  CategoryRule(pattern: 'myntra', categoryName: 'Shopping', confidence: 0.85),
  CategoryRule(pattern: 'netflix', categoryName: 'Entertainment', confidence: 0.95),
  CategoryRule(pattern: 'hotstar', categoryName: 'Entertainment', confidence: 0.9),
  CategoryRule(pattern: 'prime video', categoryName: 'Entertainment', confidence: 0.9),
  CategoryRule(pattern: 'salary', categoryName: 'Salary', confidence: 0.95),
  CategoryRule(pattern: 'rent', categoryName: 'Rent', confidence: 0.9),
  CategoryRule(pattern: 'electricity', categoryName: 'Utilities', confidence: 0.85),
  CategoryRule(pattern: 'water', categoryName: 'Utilities', confidence: 0.85),
  CategoryRule(pattern: 'gas', categoryName: 'Utilities', confidence: 0.85),
  CategoryRule(pattern: 'dmart', categoryName: 'Groceries', confidence: 0.85),
  CategoryRule(pattern: 'bigbasket', categoryName: 'Groceries', confidence: 0.85),
  CategoryRule(pattern: 'zepto', categoryName: 'Groceries', confidence: 0.85),
  CategoryRule(pattern: 'blinkit', categoryName: 'Groceries', confidence: 0.85),
  CategoryRule(pattern: 'jio', categoryName: 'Telecom', confidence: 0.85),
  CategoryRule(pattern: 'airtel', categoryName: 'Telecom', confidence: 0.85),
  CategoryRule(pattern: 'insurance', categoryName: 'Insurance', confidence: 0.85),
  CategoryRule(pattern: 'mutual fund', categoryName: 'Investment', confidence: 0.8),
  CategoryRule(pattern: 'stock', categoryName: 'Investment', confidence: 0.8),
  CategoryRule(pattern: 'credit card', categoryName: 'Credit Card Payment', confidence: 0.85),
  CategoryRule(pattern: 'atm', categoryName: 'Cash Withdrawal', confidence: 0.7),
];

class CategorizationResult {
  final String? categoryName;
  final double confidence;
  final String? explanation;

  const CategorizationResult({
    this.categoryName,
    this.confidence = 0.0,
    this.explanation,
  });
}

CategorizationResult categorize(String? merchantName, String description, {List<CategoryRule>? userRules}) {
  if (description.toUpperCase().contains('ATM') ||
      (merchantName != null && merchantName.toLowerCase().contains('atm'))) {
    return const CategorizationResult(
      categoryName: 'Cash Withdrawal',
      confidence: 0.7,
      explanation: 'Matched built-in rule for ATM',
    );
  }

  if (merchantName == null || merchantName.isEmpty) {
    return const CategorizationResult(
      categoryName: 'Other',
      confidence: 0.2,
      explanation: 'Unknown merchant',
    );
  }

  final text = merchantName.toUpperCase();
  final descText = description.toUpperCase();

  final allRules = <CategoryRule>[];
  if (userRules != null) allRules.addAll(userRules);
  allRules.addAll(builtinRules);

  final userRulesApplied = userRules != null && userRules.isNotEmpty;

  for (final rule in allRules) {
    if (userRulesApplied && rule.isUserRule) {
      if (text.contains(rule.pattern.toUpperCase()) ||
          descText.contains(rule.pattern.toUpperCase())) {
        return CategorizationResult(
          categoryName: rule.categoryName,
          confidence: rule.confidence,
          explanation: rule.isUserRule ? 'Matched user-defined rule' : 'Matched built-in rule',
        );
      }
    } else if (!userRulesApplied || !rule.isUserRule) {
      if (text.contains(rule.pattern.toUpperCase()) ||
          descText.contains(rule.pattern.toUpperCase())) {
        return CategorizationResult(
          categoryName: rule.categoryName,
          confidence: rule.confidence,
          explanation: 'Matched built-in rule',
        );
      }
    }
  }

  return const CategorizationResult(
    categoryName: 'Other',
    confidence: 0.3,
    explanation: 'No matching rule found',
  );
}

void main() {
  group('CategorizationService - known merchants', () {
    test('Swiggy maps to Food Delivery', () {
      final result = categorize('Swiggy', 'UPI-SWIGGY-ORDER-1234');
      expect(result.categoryName, 'Food Delivery');
      expect(result.confidence, greaterThanOrEqualTo(0.9));
    });

    test('Zomato maps to Food Delivery', () {
      final result = categorize('Zomato', 'ZOMATO ORDER');
      expect(result.categoryName, 'Food Delivery');
    });

    test('Uber maps to Transport', () {
      final result = categorize('Uber', 'UPI-UBER-INDIA');
      expect(result.categoryName, 'Transport');
    });

    test('Amazon maps to Shopping', () {
      final result = categorize('Amazon', 'AMAZON PAY INDIA');
      expect(result.categoryName, 'Shopping');
    });

    test('Netflix maps to Entertainment', () {
      final result = categorize('Netflix', 'NETFLIX SUBSCRIPTION');
      expect(result.categoryName, 'Entertainment');
      expect(result.confidence, greaterThanOrEqualTo(0.95));
    });

    test('Salary maps to Salary', () {
      final result = categorize('Salary', 'SALARY CREDIT');
      expect(result.categoryName, 'Salary');
      expect(result.confidence, greaterThanOrEqualTo(0.95));
    });

    test('Rent maps to Rent', () {
      final result = categorize('Rent', 'RENT PAYMENT');
      expect(result.categoryName, 'Rent');
    });

    test('DMart maps to Groceries', () {
      final result = categorize('DMart', 'DMART GROCERY');
      expect(result.categoryName, 'Groceries');
    });
  });

  group('CategorizationService - ATM and special cases', () {
    test('ATM withdrawal maps to Cash Withdrawal', () {
      final result = categorize(null, 'ATM CASH WITHDRAWAL');
      expect(result.categoryName, 'Cash Withdrawal');
    });

    test('ATM in description maps to Cash Withdrawal', () {
      final result = categorize(null, 'ATM CASH');
      expect(result.categoryName, 'Cash Withdrawal');
      expect(result.confidence, 0.7);
    });
  });

  group('CategorizationService - unknown merchants', () {
    test('null merchant returns Other with low confidence', () {
      final result = categorize(null, 'RANDOM DESCRIPTION');
      expect(result.categoryName, 'Other');
      expect(result.confidence, lessThan(0.5));
    });

    test('empty string merchant returns Other with low confidence', () {
      final result = categorize('', 'SOME TEXT');
      expect(result.categoryName, 'Other');
      expect(result.confidence, lessThan(0.5));
    });

    test('unknown merchant returns Other with low confidence', () {
      final result = categorize('UnknownVendor', 'UNKNOWN VENDOR');
      expect(result.categoryName, 'Other');
      expect(result.confidence, lessThan(0.5));
    });
  });

  group('CategorizationService - user rules take priority', () {
    test('user rule overrides built-in rule', () {
      final userRules = [
        CategoryRule(
          pattern: 'swiggy',
          categoryName: 'Junk Food',
          confidence: 1.0,
          isUserRule: true,
        ),
      ];

      final result = categorize('Swiggy', 'UPI-SWIGGY-ORDER', userRules: userRules);
      expect(result.categoryName, 'Junk Food');
      expect(result.confidence, 1.0);
    });

    test('user rule for custom merchant works', () {
      final userRules = [
        CategoryRule(
          pattern: 'localcafe',
          categoryName: 'Food & Drinks',
          confidence: 0.9,
          isUserRule: true,
        ),
      ];

      final result = categorize('LocalCafe', 'LOCALCAFE ORDER', userRules: userRules);
      expect(result.categoryName, 'Food & Drinks');
      expect(result.explanation, 'Matched user-defined rule');
    });

    test('multiple user rules select correct one', () {
      final userRules = [
        CategoryRule(
          pattern: 'swiggy', categoryName: 'Junk Food',
          confidence: 1.0, isUserRule: true,
        ),
        CategoryRule(
          pattern: 'zomato', categoryName: 'Food Delivery',
          confidence: 1.0, isUserRule: true,
        ),
      ];

      final result = categorize('Zomato', 'ZOMATO ORDER', userRules: userRules);
      expect(result.categoryName, 'Food Delivery');
    });
  });

  group('CategorizationService - edge cases', () {
    test('description based matching when merchant is generic', () {
      final result = categorize('Merchant', 'NETFLIX SUBSCRIPTION');
      expect(result.categoryName, 'Entertainment');
    });

    test('case insensitive matching works', () {
      final result = categorize('netflix', 'netflix subscription');
      expect(result.categoryName, 'Entertainment');
    });

    test('partial merchant name matching works', () {
      final result = categorize('AMAZON PAY INDIA PVT LTD', 'AMAZON PAY');
      expect(result.categoryName, 'Shopping');
    });

    test('electricity bill categorization', () {
      final result = categorize('Tata Power', 'NEFT-ELECTRICITY-BILL');
      expect(result.categoryName, 'Utilities');
    });
  });
}
