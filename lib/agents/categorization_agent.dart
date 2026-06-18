import '../core/models/categorization_rule.dart';
import '../core/models/category.dart';
import '../core/models/transaction.dart';
import 'agent_core/agent_protocol.dart';

class CategorizationInput {
  final List<Transaction> transactions;
  final List<CategorizationRule> userRules;
  final List<Category> categories;

  const CategorizationInput({
    required this.transactions,
    required this.userRules,
    required this.categories,
  });
}

class CategorizationOutput {
  final List<Transaction> categorizedTransactions;

  const CategorizationOutput({required this.categorizedTransactions});
}

class CategorizationAgent
    implements Agent<CategorizationInput, CategorizationOutput> {
  @override
  String get name => 'CategorizationAgent';

  @override
  String get purpose =>
      'Applies local categorization rules to transactions';

  static const Map<String, String> builtInRules = {
    'Swiggy': 'cat_food_delivery',
    'Zomato': 'cat_food_delivery',
    'Uber': 'cat_transport',
    'Ola': 'cat_transport',
    'Amazon': 'cat_shopping',
    'Flipkart': 'cat_shopping',
    'Myntra': 'cat_shopping',
    'BigBasket': 'cat_groceries',
    'Zepto': 'cat_groceries',
    'Blinkit': 'cat_groceries',
    'Netflix': 'cat_entertainment',
    'Spotify': 'cat_entertainment',
    'Prime Video': 'cat_entertainment',
    'Airtel': 'cat_bills',
    'Jio': 'cat_bills',
    'DMart': 'cat_groceries',
    'Reliance Fresh': 'cat_groceries',
    'IndianOil': 'cat_fuel',
    'BPCL': 'cat_fuel',
    'HPCL': 'cat_fuel',
    'IRCTC': 'cat_travel',
    'MakeMyTrip': 'cat_travel',
    'Zerodha': 'cat_investments',
    'Groww': 'cat_investments',
    'Apollo': 'cat_health',
    '1mg': 'cat_health',
    'Practo': 'cat_health',
    'Urban Company': 'cat_shopping',
    'Salary': 'cat_salary',
    'Rent': 'cat_rent',
    'Google Pay': 'cat_transfer',
    'PhonePe': 'cat_transfer',
    'Paytm': 'cat_transfer',
    'Google Play': 'cat_entertainment',
    'Apple': 'cat_shopping',
    "McDonald's": 'cat_food_delivery',
    "Domino's": 'cat_food_delivery',
    'Pizza Hut': 'cat_food_delivery',
    'KFC': 'cat_food_delivery',
    'Starbucks': 'cat_food_delivery',
    "Dunkin'": 'cat_food_delivery',
    'Subway': 'cat_food_delivery',
    'Nykaa': 'cat_shopping',
    'Ajio': 'cat_shopping',
    'Meesho': 'cat_shopping',
    'Tata CLiQ': 'cat_shopping',
    'HDFC': 'cat_banking',
    'ICICI': 'cat_banking',
    'SBI': 'cat_banking',
    'Axis': 'cat_banking',
    'Kotak': 'cat_banking',
    'Yes Bank': 'cat_banking',
    'LIC': 'cat_insurance',
    'Tata': 'cat_shopping',
    'Reliance': 'cat_shopping',
  };

  static const Map<String, String> heuristicCategories = {
    'salary': 'cat_salary',
    'rent': 'cat_rent',
    'electricity': 'cat_bills',
    'water': 'cat_bills',
    'gas': 'cat_bills',
    'internet': 'cat_bills',
    'insurance': 'cat_insurance',
    'school': 'cat_education',
    'college': 'cat_education',
    'tuition': 'cat_education',
    'hospital': 'cat_health',
    'clinic': 'cat_health',
    'doctor': 'cat_health',
    'pharmacy': 'cat_health',
    'grocery': 'cat_groceries',
    'vegetables': 'cat_groceries',
    'restaurant': 'cat_food_delivery',
    'cafe': 'cat_food_delivery',
    'hotel': 'cat_travel',
    'flight': 'cat_travel',
    'bus': 'cat_transport',
    'train': 'cat_transport',
    'metro': 'cat_transport',
    'fuel': 'cat_fuel',
    'petrol': 'cat_fuel',
    'diesel': 'cat_fuel',
    'investment': 'cat_investments',
    'mutual fund': 'cat_investments',
    'stocks': 'cat_investments',
    'dividend': 'cat_investments',
    'interest': 'cat_income',
    'refund': 'cat_refund',
    'cashback': 'cat_refund',
    'transfer': 'cat_transfer',
    'withdrawal': 'cat_transfer',
    'deposit': 'cat_income',
  };

  ({String? categoryId, String? categoryName, double confidence,
      String? explanation})
  categorizeTransaction({
    required Transaction transaction,
    required List<CategorizationRule> userRules,
    required List<Category> categories,
  }) {
    final merchant = transaction.merchantName;
    final description = transaction.description.toLowerCase();

    for (final rule in userRules) {
      if (rule.merchantPattern != null && merchant != null) {
        if (merchant
            .toUpperCase()
            .contains(rule.merchantPattern!.toUpperCase())) {
          final cat = categories.where((c) => c.id == rule.categoryId).firstOrNull;
          return (
            categoryId: rule.categoryId,
            categoryName: cat?.name ?? rule.categoryName,
            confidence: 0.95,
            explanation:
                'User rule matched merchant "${rule.merchantPattern}"',
          );
        }
      }
      if (rule.descriptionPattern != null) {
        if (description.contains(rule.descriptionPattern!.toLowerCase())) {
          final cat = categories.where((c) => c.id == rule.categoryId).firstOrNull;
          return (
            categoryId: rule.categoryId,
            categoryName: cat?.name ?? rule.categoryName,
            confidence: 0.9,
            explanation:
                'User rule matched description "${rule.descriptionPattern}"',
          );
        }
      }
    }

    if (merchant != null) {
      for (final entry in builtInRules.entries) {
        if (merchant.toUpperCase().contains(entry.key.toUpperCase())) {
          final cat = categories.where((c) => c.id == entry.value).firstOrNull;
          return (
            categoryId: entry.value,
            categoryName: cat?.name ?? entry.key,
            confidence: 0.85,
            explanation:
                'Built-in rule matched merchant "$merchant"',
          );
        }
      }
    }

    for (final entry in heuristicCategories.entries) {
      if (description.contains(entry.key)) {
        final cat = categories.where((c) => c.id == entry.value).firstOrNull;
        return (
          categoryId: entry.value,
          categoryName: cat?.name ?? entry.key,
          confidence: 0.6,
          explanation:
              'Heuristic matched keyword "${entry.key}" in description',
        );
      }
    }

    if (transaction.direction == TransactionDirection.credit) {
      final salaryKeywords = ['salary', 'payroll', 'wage', 'income'];
      for (final kw in salaryKeywords) {
        if (description.contains(kw)) {
          final cat = categories.where((c) => c.id == 'cat_salary').firstOrNull;
          return (
            categoryId: 'cat_salary',
            categoryName: cat?.name ?? 'Salary',
            confidence: 0.7,
            explanation: 'Credit transaction matched salary heuristic',
          );
        }
      }
    }

    return (
      categoryId: null,
      categoryName: null,
      confidence: 0.0,
      explanation: 'No categorization rule matched',
    );
  }

  @override
  Future<AgentResult<CategorizationOutput>> run(
      CategorizationInput input) async {
    try {
      final categorized = <Transaction>[];
      int matched = 0;
      int lowConfidence = 0;

      for (final tx in input.transactions) {
        if (tx.categoryId != null) {
          categorized.add(tx);
          matched++;
          continue;
        }

        final result = categorizeTransaction(
          transaction: tx,
          userRules: input.userRules,
          categories: input.categories,
        );

        if (result.categoryId != null && result.confidence >= 0.6) {
          categorized.add(tx.copyWith(
            categoryId: result.categoryId,
            categoryName: result.categoryName,
          ));
          matched++;
        } else if (result.categoryId != null) {
          categorized.add(tx.copyWith(
            categoryId: result.categoryId,
            categoryName: result.categoryName,
          ));
          lowConfidence++;
        } else {
          categorized.add(tx);
        }
      }

      final matchRate = input.transactions.isEmpty
          ? 1.0
          : matched / input.transactions.length;

      return AgentResult(
        status: lowConfidence > 0
            ? AgentTaskStatus.needsUserReview
            : AgentTaskStatus.completed,
        output: CategorizationOutput(categorizedTransactions: categorized),
        confidence: matchRate,
        explanation:
            'Categorized $matched of ${input.transactions.length} transactions ($lowConfidence low confidence)',
        needsReview: lowConfidence > 0,
      );
    } catch (e) {
      return AgentResult(
        status: AgentTaskStatus.failed,
        confidence: 0,
        explanation: 'Categorization error: $e',
      );
    }
  }
}
