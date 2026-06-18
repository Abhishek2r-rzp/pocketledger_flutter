import 'dart:convert';
import 'package:drift/drift.dart';
import '../database.dart';
import 'package:uuid/uuid.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [Transactions, Categories, ImportBatches])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.db);

  Future<List<TransactionEntry>> getAllTransactions() =>
      select(transactions).get();

  Future<TransactionEntry?> getTransactionById(String id) {
    return (select(transactions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<TransactionEntry>> getTransactionsByBatch(String batchId) {
    return (select(transactions)
          ..where((t) => t.importBatchId.equals(batchId))
          ..orderBy([(t) => OrderingTerm(expression: t.transactionDate, mode: OrderingMode.desc)]))
        .get();
  }

  Future<List<TransactionEntry>> getTransactionsNeedingReview() {
    return (select(transactions)
          ..where((t) => t.needsReview.equals(1))
          ..orderBy([(t) => OrderingTerm(expression: t.transactionDate, mode: OrderingMode.desc)]))
        .get();
  }

  Future<List<TransactionEntry>> getUncategorizedTransactions() {
    return (select(transactions)
          ..where((t) => t.categoryId.isNull())
          ..orderBy([(t) => OrderingTerm(expression: t.transactionDate, mode: OrderingMode.desc)]))
        .get();
  }

  Future<List<TransactionEntry>> searchTransactions(String query) {
    return (select(transactions)
          ..where((t) =>
              t.rawDescription.like('%$query%') |
              (t.merchantName?.like('%$query%') ?? const Constant(false)) |
              (t.notes?.like('%$query%') ?? const Constant(false)))
          ..orderBy([(t) => OrderingTerm(expression: t.transactionDate, mode: OrderingMode.desc)]))
        .get();
  }

  Future<int> insertTransaction(TransactionEntry entry) {
    return into(transactions).insert(entry);
  }

  Future<void> insertTransactions(List<TransactionEntry> entries) {
    return batch((b) {
      b.insertAll(transactions, entries);
    });
  }

  Future<int> updateTransaction(TransactionEntry entry) {
    return (update(transactions)..whereSamePrimaryKey(entry)).write(entry);
  }

  Future<int> deleteAll() async {
    return delete(transactions).go();
  }

  Future<int> deleteTransaction(String id) {
    return (delete(transactions)..where((t) => t.id.equals(id))).go();
  }

  Future<MonthlySummary?> getMonthlySummary(int month, int year) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    final startMs = start.millisecondsSinceEpoch;
    final endMs = end.millisecondsSinceEpoch;

    return customSelect(
      '''
      SELECT
        COALESCE(SUM(CASE WHEN direction = 'income' THEN amount ELSE 0 END), 0) AS total_income,
        COALESCE(SUM(CASE WHEN direction = 'expense' THEN amount ELSE 0 END), 0) AS total_expense,
        COALESCE(SUM(CASE WHEN direction = 'transfer' THEN amount ELSE 0 END), 0) AS total_transfer,
        COUNT(*) AS transaction_count,
        COUNT(CASE WHEN needs_review = 1 THEN 1 END) AS review_count
      FROM transactions
      WHERE transaction_date >= ? AND transaction_date < ?
      ''',
      variables: [Variable(startMs), Variable(endMs)],
    ).map((row) {
      return MonthlySummary(
        totalIncome: row.read<double>('total_income'),
        totalExpense: row.read<double>('total_expense'),
        totalTransfer: row.read<double>('total_transfer'),
        transactionCount: row.read<int>('transaction_count'),
        reviewCount: row.read<int>('review_count'),
      );
    }).getSingleOrNull();
  }

  Future<List<CategorySpend>> getCategorySpend(int month, int year) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    final startMs = start.millisecondsSinceEpoch;
    final endMs = end.millisecondsSinceEpoch;

    return customSelect(
      '''
      SELECT
        COALESCE(category_id, 'uncategorized') AS category_id,
        COALESCE(category_name, 'Uncategorized') AS category_name,
        SUM(amount) AS total_amount,
        COUNT(*) AS transaction_count
      FROM transactions
      WHERE transaction_date >= ? AND transaction_date < ?
        AND direction = 'expense'
      GROUP BY category_id
      ORDER BY total_amount DESC
      ''',
      variables: [Variable(startMs), Variable(endMs)],
    ).map((row) {
      return CategorySpend(
        categoryId: row.read<String>('category_id'),
        categoryName: row.read<String>('category_name'),
        totalAmount: row.read<double>('total_amount'),
        transactionCount: row.read<int>('transaction_count'),
      );
    }).get();
  }

  Future<List<DailySpend>> getDailySpend(int month, int year) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    final startMs = start.millisecondsSinceEpoch;
    final endMs = end.millisecondsSinceEpoch;

    return customSelect(
      '''
      SELECT
        transaction_date / 86400000 AS day_timestamp,
        SUM(CASE WHEN direction = 'expense' THEN amount ELSE 0 END) AS total_expense,
        SUM(CASE WHEN direction = 'income' THEN amount ELSE 0 END) AS total_income,
        COUNT(*) AS transaction_count
      FROM transactions
      WHERE transaction_date >= ? AND transaction_date < ?
      GROUP BY day_timestamp
      ORDER BY day_timestamp ASC
      ''',
      variables: [Variable(startMs), Variable(endMs)],
    ).map((row) {
      return DailySpend(
        dayTimestamp: row.read<int>('day_timestamp') * 86400000,
        totalExpense: row.read<double>('total_expense'),
        totalIncome: row.read<double>('total_income'),
        transactionCount: row.read<int>('transaction_count'),
      );
    }).get();
  }

  Future<List<MerchantSpend>> getTopMerchants(
    int month,
    int year, {
    int limit = 10,
  }) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    final startMs = start.millisecondsSinceEpoch;
    final endMs = end.millisecondsSinceEpoch;

    return customSelect(
      '''
      SELECT
        COALESCE(merchant_name, 'Unknown') AS merchant_name,
        SUM(amount) AS total_amount,
        COUNT(*) AS transaction_count
      FROM transactions
      WHERE transaction_date >= ? AND transaction_date < ?
        AND direction = 'expense'
        AND merchant_name IS NOT NULL
      GROUP BY merchant_name
      ORDER BY total_amount DESC
      LIMIT ?
      ''',
      variables: [Variable(startMs), Variable(endMs), Variable(limit)],
    ).map((row) {
      return MerchantSpend(
        merchantName: row.read<String>('merchant_name'),
        totalAmount: row.read<double>('total_amount'),
        transactionCount: row.read<int>('transaction_count'),
      );
    }).get();
  }

  Future<int> getTransactionsCount() {
    return customSelect(
      'SELECT COUNT(*) AS count FROM transactions',
    ).map((row) => row.read<int>('count')).getSingle();
  }
}

class MonthlySummary {
  final double totalIncome;
  final double totalExpense;
  final double totalTransfer;
  final int transactionCount;
  final int reviewCount;

  MonthlySummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.totalTransfer,
    required this.transactionCount,
    required this.reviewCount,
  });

  double get netFlow => totalIncome - totalExpense;
}

class CategorySpend {
  final String categoryId;
  final String categoryName;
  final double totalAmount;
  final int transactionCount;

  CategorySpend({
    required this.categoryId,
    required this.categoryName,
    required this.totalAmount,
    required this.transactionCount,
  });
}

class DailySpend {
  final int dayTimestamp;
  final double totalExpense;
  final double totalIncome;
  final int transactionCount;

  DailySpend({
    required this.dayTimestamp,
    required this.totalExpense,
    required this.totalIncome,
    required this.transactionCount,
  });

  DateTime get date => DateTime.fromMillisecondsSinceEpoch(dayTimestamp);
}

class MerchantSpend {
  final String merchantName;
  final double totalAmount;
  final int transactionCount;

  MerchantSpend({
    required this.merchantName,
    required this.totalAmount,
    required this.transactionCount,
  });
}
