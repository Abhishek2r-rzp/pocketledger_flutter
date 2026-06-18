class CategorizationRule {
  final String id;
  final String? merchantPattern;
  final String? descriptionPattern;
  final String categoryId;
  final String categoryName;
  final int usageCount;
  final DateTime createdAt;

  const CategorizationRule({
    required this.id,
    this.merchantPattern,
    this.descriptionPattern,
    required this.categoryId,
    required this.categoryName,
    this.usageCount = 0,
    required this.createdAt,
  });
}
