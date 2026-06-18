import 'package:pocketledger/core/models/enums.dart';

class Account {
  const Account({
    required this.id,
    required this.name,
    this.bankName,
    this.type = AccountType.savings,
    this.balance = 0,
    this.currency = 'INR',
    this.lastFour,
    this.isActive = true,
    required this.createdAt,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? createdAt;

  final String id;
  final String name;
  final String? bankName;
  final AccountType type;
  final double balance;
  final String currency;
  final String? lastFour;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Account copyWith({
    String? id,
    String? name,
    String? bankName,
    AccountType? type,
    double? balance,
    String? currency,
    String? lastFour,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearBankName = false,
    bool clearLastFour = false,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      bankName: clearBankName ? null : (bankName ?? this.bankName),
      type: type ?? this.type,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      lastFour: clearLastFour ? null : (lastFour ?? this.lastFour),
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
