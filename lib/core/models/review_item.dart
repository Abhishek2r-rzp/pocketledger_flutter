import 'package:pocketledger/core/models/enums.dart';

class ReviewItem {
  final String id;
  final String transactionId;
  final ReviewReason reason;
  final String? suggestedCategoryId;
  final String? suggestedCategoryName;
  final String? suggestedMerchant;
  final double confidence;
  final String? explanation;
  final DateTime createdAt;

  const ReviewItem({
    required this.id,
    required this.transactionId,
    required this.reason,
    this.suggestedCategoryId,
    this.suggestedCategoryName,
    this.suggestedMerchant,
    required this.confidence,
    this.explanation,
    required this.createdAt,
  });
}
