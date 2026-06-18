import 'package:pocketledger/core/models/transaction.dart';

class ParsedTransactionDraft {
  final DateTime? date;
  final String? description;
  final double? debit;
  final double? credit;
  final double? amount;
  final double? balance;
  final double confidence;
  final String? rawDescription;

  ParsedTransactionDraft({
    this.date,
    this.description,
    this.debit,
    this.credit,
    this.amount,
    this.balance,
    this.confidence = 1.0,
    this.rawDescription,
  });

  double get resolvedAmount {
    if (amount != null) return amount!;
    if (debit != null && debit! > 0) return debit!;
    if (credit != null && credit! > 0) return credit!;
    return 0;
  }

  TransactionDirection get resolvedDirection {
    if (amount != null) {
      return amount! >= 0 ? TransactionDirection.income : TransactionDirection.expense;
    }
    if (debit != null && debit! > 0) return TransactionDirection.expense;
    if (credit != null && credit! > 0) return TransactionDirection.income;
    return TransactionDirection.expense;
  }
}
