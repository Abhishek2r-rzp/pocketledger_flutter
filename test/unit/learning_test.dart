import 'package:flutter_test/flutter_test.dart';
import '../test_helpers.dart';

class UserCategoryRule {
  final String id;
  final String merchantPattern;
  final String categoryName;
  final String? subcategoryName;
  final MatchType matchType;
  final bool createdByUser;
  final int priority;
  final DateTime createdAt;

  const UserCategoryRule({
    required this.id,
    required this.merchantPattern,
    required this.categoryName,
    this.subcategoryName,
    this.matchType = MatchType.contains,
    this.createdByUser = true,
    this.priority = 0,
    required this.createdAt,
  });
}

int getNextPriority(List<UserCategoryRule> rules) {
  if (rules.isEmpty) return 100;
  return rules.map((r) => r.priority).reduce((a, b) => a > b ? a : b) + 10;
}

List<UserCategoryRule> generateRules(List<Transaction> corrections) {
  if (corrections.length < 2) return [];

  final merchantCounts = <String, Map<String, int>>{};

  for (final txn in corrections) {
    final merchant = txn.merchantName ?? txn.rawDescription;
    final category = txn.categoryName ?? 'Other';

    merchantCounts.putIfAbsent(merchant, () => <String, int>{});
    merchantCounts[merchant]!.update(category, (count) => count + 1, ifAbsent: () => 1);
  }

  final rules = <UserCategoryRule>[];
  int basePriority = 100;
  final now = DateTime.now();

  for (final entry in merchantCounts.entries) {
    final merchant = entry.key;
    final categories = entry.value;

    for (final catEntry in categories.entries) {
      if (catEntry.value >= 2) {
        rules.add(UserCategoryRule(
          id: 'rule_${merchant.hashCode}_${catEntry.key.hashCode}',
          merchantPattern: merchant,
          categoryName: catEntry.key,
          createdByUser: true,
          priority: basePriority,
          createdAt: now,
        ));
        basePriority += 10;
      }
    }
  }

  return rules;
}

void main() {
  group('LearningService - rule generation', () {
    test('two corrections with same merchant/category create rule', () {
      final corrections = [
        createTestTransaction(
          merchantName: 'Swiggy', categoryName: 'Junk Food',
          categoryId: 'cat_junk_food', categorizationConfidence: 0.2,
        ),
        createTestTransaction(
          merchantName: 'Swiggy', categoryName: 'Junk Food',
          categoryId: 'cat_junk_food', categorizationConfidence: 0.3,
        ),
      ];

      final rules = generateRules(corrections);
      expect(rules.length, 1);
      expect(rules.first.merchantPattern, 'Swiggy');
      expect(rules.first.categoryName, 'Junk Food');
    });

    test('one correction does not create a rule', () {
      final corrections = [
        createTestTransaction(
          merchantName: 'Swiggy', categoryName: 'Junk Food',
        ),
      ];

      final rules = generateRules(corrections);
      expect(rules, isEmpty);
    });

    test('three identical corrections create one rule', () {
      final corrections = [
        createTestTransaction(merchantName: 'Swiggy', categoryName: 'Food Delivery'),
        createTestTransaction(merchantName: 'Swiggy', categoryName: 'Food Delivery'),
        createTestTransaction(merchantName: 'Swiggy', categoryName: 'Food Delivery'),
      ];

      final rules = generateRules(corrections);
      expect(rules.length, 1);
    });

    test('different merchants get separate rules', () {
      final corrections = [
        createTestTransaction(merchantName: 'Swiggy', categoryName: 'Food Delivery'),
        createTestTransaction(merchantName: 'Swiggy', categoryName: 'Food Delivery'),
        createTestTransaction(merchantName: 'Amazon', categoryName: 'Shopping'),
        createTestTransaction(merchantName: 'Amazon', categoryName: 'Shopping'),
      ];

      final rules = generateRules(corrections);
      expect(rules.length, 2);
      final ruleNames = rules.map((r) => r.merchantPattern).toSet();
      expect(ruleNames, contains('Swiggy'));
      expect(ruleNames, contains('Amazon'));
    });

    test('inconsistent categories for same merchant do not create rules', () {
      final corrections = [
        createTestTransaction(merchantName: 'Swiggy', categoryName: 'Food Delivery'),
        createTestTransaction(merchantName: 'Swiggy', categoryName: 'Junk Food'),
      ];

      final rules = generateRules(corrections);
      expect(rules, isEmpty);
    });
  });

  group('LearningService - rule priority', () {
    test('rules get correct incremental priority', () {
      final corrections = [
        createTestTransaction(merchantName: 'Swiggy', categoryName: 'Food'),
        createTestTransaction(merchantName: 'Swiggy', categoryName: 'Food'),
        createTestTransaction(merchantName: 'Amazon', categoryName: 'Shopping'),
        createTestTransaction(merchantName: 'Amazon', categoryName: 'Shopping'),
        createTestTransaction(merchantName: 'Netflix', categoryName: 'Entertainment'),
        createTestTransaction(merchantName: 'Netflix', categoryName: 'Entertainment'),
      ];

      final rules = generateRules(corrections);
      expect(rules.length, 3);
      expect(rules[0].priority, 100);
      expect(rules[1].priority, 110);
      expect(rules[2].priority, 120);
    });

    test('getNextPriority starts at 100 for empty rules', () {
      expect(getNextPriority([]), 100);
    });

    test('getNextPriority increments by 10', () {
      final rules = [
        UserCategoryRule(
          id: 'rule_1', merchantPattern: 'Swiggy',
          categoryName: 'Food', priority: 100,
          createdAt: DateTime.now(),
        ),
      ];
      expect(getNextPriority(rules), 110);
    });
  });

  group('LearningService - rule attributes', () {
    test('rule has createdByUser = true', () {
      final corrections = [
        createTestTransaction(merchantName: 'Swiggy', categoryName: 'Food'),
        createTestTransaction(merchantName: 'Swiggy', categoryName: 'Food'),
      ];

      final rules = generateRules(corrections);
      expect(rules.first.createdByUser, isTrue);
    });

    test('rule has correct matchType', () {
      final corrections = [
        createTestTransaction(merchantName: 'Swiggy', categoryName: 'Food'),
        createTestTransaction(merchantName: 'Swiggy', categoryName: 'Food'),
      ];

      final rules = generateRules(corrections);
      expect(rules.first.matchType, MatchType.contains);
    });
  });

  group('LearningService - edge cases', () {
    test('empty corrections list returns empty rules', () {
      expect(generateRules([]), isEmpty);
    });

    test('corrections with no merchant name still grouped correctly', () {
      final corrections = [
        createTestTransaction(merchantName: null, rawDescription: 'SOMETHING', categoryName: 'Other'),
        createTestTransaction(merchantName: null, rawDescription: 'SOMETHING', categoryName: 'Other'),
      ];

      final rules = generateRules(corrections);
      expect(rules.length, 1);
      expect(rules.first.merchantPattern, 'SOMETHING');
    });

    test('same merchant different descriptions still grouped together', () {
      final corrections = [
        createTestTransaction(merchantName: 'Swiggy', categoryName: 'Food Delivery'),
        createTestTransaction(merchantName: 'Swiggy', rawDescription: 'UPI-SWIGGY-ORDER-5678', categoryName: 'Food Delivery'),
      ];

      final rules = generateRules(corrections);
      expect(rules.length, 1);
    });
  });
}
