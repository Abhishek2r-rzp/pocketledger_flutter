enum TransactionDirection { income, expense, transfer, refund, unknown, debit, credit }

class Transaction {
  final String id;
  final DateTime date;
  final double amount;
  final TransactionDirection direction;
  final String description;
  final String? merchantName;
  final String? categoryId;
  final String? categoryName;
  final double? balance;
  final String currency;
  final String fingerprint;
  final String importBatchId;
  final String? notes;
  final List<String> tags;
  final List<String> labelIds;
  final double confidence;
  final bool needsReview;
  final String? rawDescription;
  final String? categorizationExplanation;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Transaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.direction,
    required this.description,
    this.merchantName,
    this.categoryId,
    this.categoryName,
    this.balance,
    required this.currency,
    required this.fingerprint,
    required this.importBatchId,
    this.notes,
    this.tags = const [],
    this.labelIds = const [],
    this.confidence = 1.0,
    this.needsReview = false,
    this.rawDescription,
    this.categorizationExplanation,
    required this.createdAt,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? createdAt;

  Transaction copyWith({
    String? id,
    DateTime? date,
    double? amount,
    TransactionDirection? direction,
    String? description,
    String? merchantName,
    String? categoryId,
    bool clearCategory = false,
    String? categoryName,
    double? balance,
    String? currency,
    String? fingerprint,
    String? importBatchId,
    String? notes,
    List<String>? tags,
    List<String>? labelIds,
    double? confidence,
    bool? needsReview,
    String? rawDescription,
    String? categorizationExplanation,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      direction: direction ?? this.direction,
      description: description ?? this.description,
      merchantName: merchantName ?? this.merchantName,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      categoryName: categoryName ?? this.categoryName,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      fingerprint: fingerprint ?? this.fingerprint,
      importBatchId: importBatchId ?? this.importBatchId,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      labelIds: labelIds ?? this.labelIds,
      confidence: confidence ?? this.confidence,
      needsReview: needsReview ?? this.needsReview,
      rawDescription: rawDescription ?? this.rawDescription,
      categorizationExplanation: categorizationExplanation ?? this.categorizationExplanation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
