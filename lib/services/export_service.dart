import 'package:pocketledger/core/models/category.dart';
import 'package:pocketledger/core/models/transaction.dart';

class ExportService {
  Future<String> exportTransactionsToCSV(
    List<Transaction> transactions,
    List<Category> categories,
  ) async {
    final buffer = StringBuffer();

    buffer.writeln('Date,Description,Merchant,Amount,Category,Direction,Notes,Tags,Confidence');

    for (final t in transactions) {
      final categoryName = categories
          .where((c) => c.id == t.categoryId)
          .map((c) => c.name)
          .firstOrNull;
      buffer.writeln(csvRow(t, categoryName));
    }

    return buffer.toString();
  }

  String csvRow(Transaction transaction, String? categoryName) {
    final fields = [
      _escapeCsvField(_formatDate(transaction.date)),
      _escapeCsvField(transaction.description),
      _escapeCsvField(transaction.merchantName ?? ''),
      transaction.amount.toStringAsFixed(2),
      _escapeCsvField(categoryName ?? 'Uncategorized'),
      transaction.direction.name,
      _escapeCsvField(transaction.notes ?? ''),
      _escapeCsvField(transaction.tags.join('; ')),
      transaction.confidence.toStringAsFixed(2),
    ];
    return fields.join(',');
  }

  String _escapeCsvField(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
