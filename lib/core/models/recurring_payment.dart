import 'package:pocketledger/core/models/enums.dart';

class RecurringPayment {
  final String id;
  final String merchantName;
  final double? amount;
  final PaymentFrequency? frequency;
  final String? categoryId;
  final String? categoryName;
  final DateTime lastDetected;
  final int occurrences;
  final double averageAmount;
  final bool active;
  final DateTime createdAt;

  const RecurringPayment({
    required this.id,
    required this.merchantName,
    this.amount,
    this.frequency,
    this.categoryId,
    this.categoryName,
    required this.lastDetected,
    this.occurrences = 0,
    this.averageAmount = 0.0,
    this.active = true,
    required this.createdAt,
  });

  RecurringPayment copyWith({
    String? id,
    String? merchantName,
    double? amount,
    PaymentFrequency? frequency,
    String? categoryId,
    String? categoryName,
    DateTime? lastDetected,
    int? occurrences,
    double? averageAmount,
    bool? active,
    DateTime? createdAt,
  }) {
    return RecurringPayment(
      id: id ?? this.id,
      merchantName: merchantName ?? this.merchantName,
      amount: amount ?? this.amount,
      frequency: frequency ?? this.frequency,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      lastDetected: lastDetected ?? this.lastDetected,
      occurrences: occurrences ?? this.occurrences,
      averageAmount: averageAmount ?? this.averageAmount,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
