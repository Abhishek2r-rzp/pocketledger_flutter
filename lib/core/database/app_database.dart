import '../models/agent_action_log.dart';
import '../models/budget.dart';
import '../models/categorization_rule.dart';
import '../models/category.dart';
import '../models/import_batch.dart';
import '../models/recurring_payment.dart';
import '../models/review_item.dart';
import '../models/transaction.dart';
import '../models/user_settings.dart';

abstract class AgentDatabase {
  Future<List<Transaction>> getExistingTransactions();
  Future<List<Transaction>> getTransactionsByBatch(String batchId);
  Future<List<Transaction>> getAllTransactions();
  Future<void> insertTransactions(List<Transaction> transactions);
  Future<void> updateTransaction({
    required String id,
    String? categoryId,
    String? categoryName,
    String? merchantName,
    String? notes,
    List<String>? tags,
  });
  Future<List<Transaction>> getUncategorizedTransactions();
  Future<List<Transaction>> getTransactionsForPeriod(DateTime start, DateTime end);

  Future<List<Category>> getAllCategories();
  Future<Category?> getCategoryById(String id);

  Future<List<CategorizationRule>> getAllRules();
  Future<void> insertRule(CategorizationRule rule);
  Future<void> updateRuleUsage(String ruleId);

  Future<List<Budget>> getBudgets();
  Future<Budget?> getBudgetForCategory(String categoryId, int month, int year);
  Future<void> upsertBudget(Budget budget);

  Future<List<RecurringPayment>> getActiveRecurring();
  Future<void> insertRecurring(RecurringPayment payment);

  Future<void> insertBatch(ImportBatch batch);
  Future<ImportBatch?> getBatch(String id);
  Future<void> updateBatch(String id,
      {int? importedRows, int? duplicateRows, int? failedRows});

  Future<void> insertActionLog(AgentActionLog log);

  Future<void> insertReviewItems(List<ReviewItem> items);
  Future<List<ReviewItem>> getReviewItems();
  Future<void> deleteReviewItem(String id);

  Future<UserSettings?> getUserSettings();
}
