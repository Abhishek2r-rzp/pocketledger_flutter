import 'package:pocketledger/core/models/transaction.dart';

class SearchService {
  List<Transaction> search(List<Transaction> transactions, String query) {
    if (query.trim().isEmpty) return transactions;

    final q = query.toLowerCase().trim();
    return transactions.where((t) {
      return t.description.toLowerCase().contains(q) ||
          (t.merchantName?.toLowerCase().contains(q) ?? false) ||
          t.amount.toString().contains(q) ||
          (t.notes?.toLowerCase().contains(q) ?? false) ||
          t.tags.any((tag) => tag.toLowerCase().contains(q));
    }).toList();
  }

  List<Transaction> filter(
    List<Transaction> transactions, {
    String? categoryId,
    TransactionDirection? direction,
    DateTime? dateFrom,
    DateTime? dateTo,
    String sortBy = 'date',
    bool ascending = false,
  }) {
    var result = List<Transaction>.from(transactions);

    if (categoryId != null) {
      result = result.where((t) => t.categoryId == categoryId).toList();
    }

    if (direction != null) {
      result = result.where((t) => t.direction == direction).toList();
    }

    if (dateFrom != null) {
      result = result.where((t) => t.date.isAfter(dateFrom.subtract(const Duration(days: 1)))).toList();
    }

    if (dateTo != null) {
      result = result.where((t) => t.date.isBefore(dateTo.add(const Duration(days: 1)))).toList();
    }

    result.sort((a, b) {
      int cmp;
      switch (sortBy) {
        case 'amount':
          cmp = a.amount.compareTo(b.amount);
          break;
        case 'description':
          cmp = a.description.compareTo(b.description);
          break;
        case 'confidence':
          cmp = a.confidence.compareTo(b.confidence);
          break;
        default:
          cmp = (a.date ?? DateTime(0)).compareTo(b.date ?? DateTime(0));
      }
      return ascending ? cmp : -cmp;
    });

    return result;
  }
}
