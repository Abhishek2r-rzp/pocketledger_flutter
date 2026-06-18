import 'package:uuid/uuid.dart';

import '../core/database/app_database.dart';
import '../core/models/categorization_rule.dart';
import '../core/models/transaction.dart';

const _uuid = Uuid();

class LearningAgent {
  String get name => 'LearningAgent';

  String get purpose =>
      'Creates local rules from user correction patterns';

  Future<void> processCorrection({
    required Transaction transaction,
    String? originalCategoryId,
    required String newCategoryId,
    String? originalMerchant,
    String? newMerchant,
    required AgentDatabase database,
  }) async {
    final merchant = newMerchant ?? transaction.merchantName;
    final description = transaction.description;

    if (merchant != null && originalCategoryId != newCategoryId) {
      final shouldCreate = await shouldCreateRule(
          merchant, newCategoryId, database);
      if (shouldCreate) {
        final categories = await database.getAllCategories();
        final category =
            categories.where((c) => c.id == newCategoryId).firstOrNull;

        await createRule(
          merchant: merchant,
          description: null,
          categoryId: newCategoryId,
          categoryName: category?.name ?? 'Unknown',
          database: database,
        );
      }
    }

    if (merchant == null && description.isNotEmpty) {
      final descKeywords = description
          .split(RegExp(r'\s+'))
          .where((w) => w.length > 3)
          .take(3)
          .join(' ');

      if (descKeywords.isNotEmpty) {
        final categories = await database.getAllCategories();
        final category =
            categories.where((c) => c.id == newCategoryId).firstOrNull;

        final existingRules = await database.getAllRules();
        final hasRule = existingRules.any(
          (r) =>
              r.descriptionPattern != null &&
              description.toLowerCase().contains(
                  r.descriptionPattern!.toLowerCase()),
        );

        if (!hasRule) {
          await createRule(
            merchant: null,
            description: descKeywords,
            categoryId: newCategoryId,
            categoryName: category?.name ?? 'Unknown',
            database: database,
          );
        }
      }
    }
  }

  Future<bool> shouldCreateRule(
    String? merchant,
    String categoryId,
    AgentDatabase database,
  ) async {
    if (merchant == null) return false;

    final existingRules = await database.getAllRules();
    final alreadyExists = existingRules.any(
      (r) =>
          r.merchantPattern != null &&
          r.merchantPattern!.toUpperCase() == merchant.toUpperCase(),
    );
    if (alreadyExists) return false;

    final allTransactions = await database.getAllTransactions();
    final merchantTxs = allTransactions
        .where((t) =>
            t.merchantName != null &&
            t.merchantName!.toUpperCase() == merchant.toUpperCase())
        .toList();

    return merchantTxs.length >= 2;
  }

  Future<void> createRule({
    required String? merchant,
    String? description,
    required String categoryId,
    required String categoryName,
    required AgentDatabase database,
  }) async {
    final rule = CategorizationRule(
      id: _uuid.v4(),
      merchantPattern: merchant,
      descriptionPattern: description,
      categoryId: categoryId,
      categoryName: categoryName,
      usageCount: 0,
      createdAt: DateTime.now(),
    );

    await database.insertRule(rule);
  }

  Future<void> updateRuleUsage(
      String ruleId, AgentDatabase database) async {
    await database.updateRuleUsage(ruleId);
  }
}
