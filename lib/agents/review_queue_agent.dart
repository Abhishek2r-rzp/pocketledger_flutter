import '../core/database/app_database.dart';
import '../core/models/review_item.dart';

class ReviewQueueAgent {
  String get name => 'ReviewQueueAgent';

  String get purpose =>
      'Collects low-confidence transactions and possible duplicates for review';

  Future<List<ReviewItem>> collectReviewItems(AgentDatabase database) async {
    final items = await database.getReviewItems();
    items.sort((a, b) => a.confidence.compareTo(b.confidence));
    return items;
  }

  Future<void> applyCorrection({
    required String transactionId,
    String? categoryId,
    String? merchantName,
    String? notes,
    List<String>? tags,
    required AgentDatabase database,
  }) async {
    await database.updateTransaction(
      id: transactionId,
      categoryId: categoryId,
      categoryName: null,
      merchantName: merchantName,
      notes: notes,
      tags: tags,
    );

    final reviewItems = await database.getReviewItems();
    for (final item in reviewItems) {
      if (item.transactionId == transactionId) {
        await database.deleteReviewItem(item.id);
      }
    }
  }

  Future<void> approveSuggestion(
      String transactionId, AgentDatabase database) async {
    final reviewItems = await database.getReviewItems();
    for (final item in reviewItems) {
      if (item.transactionId == transactionId) {
        if (item.suggestedCategoryId != null) {
          await database.updateTransaction(
            id: transactionId,
            categoryId: item.suggestedCategoryId,
            categoryName: item.suggestedCategoryName,
            merchantName: item.suggestedMerchant,
          );
        }
        await database.deleteReviewItem(item.id);
      }
    }
  }
}
