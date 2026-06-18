import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/core/models/review_item.dart';
import 'package:pocketledger/core/models/enums.dart';

final reviewFilterProvider = StateProvider<ReviewReason?>((ref) => null);

class ReviewQueueNotifier extends AsyncNotifier<List<ReviewItem>> {
  @override
  Future<List<ReviewItem>> build() async {
    final repo = ref.read(dataRepositoryProvider);
    final filter = ref.watch(reviewFilterProvider);
    var items = List<ReviewItem>.from(repo.reviewItems);
    if (filter != null) {
      items = items.where((i) => i.reason == filter).toList();
    }
    return items;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }

  void approveItem(String id) {
    final repo = ref.read(dataRepositoryProvider);
    final item = repo.reviewItems.where((r) => r.id == id).firstOrNull;
    if (item != null) {
      final txn = repo.getTransaction(item.transactionId);
      if (txn != null) {
        repo.updateTransaction(txn.copyWith(
          categoryId: item.suggestedCategoryId,
          categoryName: item.suggestedCategoryName,
          needsReview: false,
        ));
      }
      repo.removeReviewItem(id);
    }
    ref.invalidateSelf();
  }

  void rejectItem(String id) {
    final repo = ref.read(dataRepositoryProvider);
    repo.removeReviewItem(id);
    ref.invalidateSelf();
  }

  void updateCategory(String itemId, String categoryId, String categoryName) {
    final repo = ref.read(dataRepositoryProvider);
    final item = repo.reviewItems.where((r) => r.id == itemId).firstOrNull;
    if (item != null) {
      final txn = repo.getTransaction(item.transactionId);
      if (txn != null) {
        repo.updateTransaction(txn.copyWith(
          categoryId: categoryId,
          categoryName: categoryName,
          needsReview: false,
        ));
      }
    }
    ref.invalidateSelf();
  }
}

final reviewQueueProvider = AsyncNotifierProvider<ReviewQueueNotifier, List<ReviewItem>>(() {
  return ReviewQueueNotifier();
});
