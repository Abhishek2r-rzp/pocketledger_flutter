import 'package:flutter_test/flutter_test.dart';
import '../test_helpers.dart';

class InMemoryDatabase {
  final List<Transaction> _transactions = [];
  final List<ImportBatch> _batches = [];

  void addTransaction(Transaction t) => _transactions.add(t);
  void addBatch(ImportBatch b) => _batches.add(b);

  List<Transaction> getTransactionsByBatchId(String batchId) {
    return _transactions.where((t) => t.importBatchId == batchId).toList();
  }

  List<Transaction> getAllTransactions() => List.unmodifiable(_transactions);
  List<ImportBatch> getAllBatches() => List.unmodifiable(_batches);

  int deleteBatch(String batchId) {
    final beforeCount = _transactions.length;
    _transactions.removeWhere((t) => t.importBatchId == batchId);
    _batches.removeWhere((b) => b.id == batchId);
    return beforeCount - _transactions.length;
  }

  void deleteAllData() {
    _transactions.clear();
    _batches.clear();
  }

  int get transactionCount => _transactions.length;
  int get batchCount => _batches.length;
}

void main() {
  late InMemoryDatabase db;
  late ImportBatch batch1;
  late ImportBatch batch2;
  late Transaction txn1;
  late Transaction txn2;
  late Transaction txn3;

  setUp(() {
    db = InMemoryDatabase();

    batch1 = createTestImportBatch(id: 'batch_001', fileName: 'march.csv');
    batch2 = createTestImportBatch(id: 'batch_002', fileName: 'april.csv');

    txn1 = createTestTransaction(
      id: 'txn_001', importBatchId: 'batch_001',
      rawDescription: 'UPI-SWIGGY-ORDER', amount: 450.0,
    );
    txn2 = createTestTransaction(
      id: 'txn_002', importBatchId: 'batch_001',
      rawDescription: 'AMAZON PAY', amount: 1299.0,
    );
    txn3 = createTestTransaction(
      id: 'txn_003', importBatchId: 'batch_002',
      rawDescription: 'SALARY CREDIT', amount: 50000.0,
    );

    db.addBatch(batch1);
    db.addBatch(batch2);
    db.addTransaction(txn1);
    db.addTransaction(txn2);
    db.addTransaction(txn3);
  });

  group('ImportBatchDeletion - delete batch', () {
    test('deleteBatch removes all associated transactions', () {
      expect(db.transactionCount, 3);

      final deleted = db.deleteBatch('batch_001');

      expect(deleted, 2);
      expect(db.transactionCount, 1);
      expect(db.getTransactionsByBatchId('batch_001'), isEmpty);
    });

    test('deleteBatch removes the import_batch record', () {
      expect(db.batchCount, 2);

      db.deleteBatch('batch_001');

      expect(db.batchCount, 1);
      expect(db.getAllBatches().any((b) => b.id == 'batch_001'), isFalse);
    });

    test('deleteBatch removes both batch record and transactions', () {
      db.deleteBatch('batch_001');

      expect(db.getAllBatches().length, 1);
      expect(db.getAllBatches().first.id, 'batch_002');
      expect(db.getAllTransactions().length, 1);
      expect(db.getAllTransactions().first.id, 'txn_003');
    });

    test('deleting non-existent batch does nothing', () {
      final deleted = db.deleteBatch('nonexistent');

      expect(deleted, 0);
      expect(db.transactionCount, 3);
      expect(db.batchCount, 2);
    });
  });

  group('ImportBatchDeletion - other batches preserved', () {
    test('deleting batch_001 preserves batch_002 transactions', () {
      db.deleteBatch('batch_001');

      final remaining = db.getAllTransactions();
      expect(remaining.length, 1);
      expect(remaining.first.id, 'txn_003');
      expect(remaining.first.importBatchId, 'batch_002');
    });

    test('deleting batch_002 preserves batch_001 data', () {
      db.deleteBatch('batch_002');

      expect(db.transactionCount, 2);
      expect(db.batchCount, 1);
      expect(db.getTransactionsByBatchId('batch_001').length, 2);
    });

    test('multiple batches can exist simultaneously', () {
      expect(db.getAllBatches().length, 2);
      expect(db.getTransactionsByBatchId('batch_001').length, 2);
      expect(db.getTransactionsByBatchId('batch_002').length, 1);
    });
  });

  group('ImportBatchDeletion - deleteAllData', () {
    test('deleteAllData removes everything', () {
      expect(db.transactionCount, 3);
      expect(db.batchCount, 2);

      db.deleteAllData();

      expect(db.transactionCount, 0);
      expect(db.batchCount, 0);
    });

    test('deleteAllData resets database to empty state', () {
      db.deleteAllData();

      expect(db.getAllTransactions(), isEmpty);
      expect(db.getAllBatches(), isEmpty);
    });

    test('deleteAllData on already empty database is safe', () {
      db.deleteAllData();
      db.deleteAllData();

      expect(db.transactionCount, 0);
      expect(db.batchCount, 0);
    });
  });

  group('ImportBatchDeletion - isolation and integrity', () {
    test('deleting transactions only affects target batch', () {
      db.deleteBatch('batch_001');

      final remainingTxns = db.getAllTransactions();
      expect(remainingTxns.every((t) => t.importBatchId == 'batch_002'), isTrue);
    });

    test('deleted transactions are completely removed', () {
      db.deleteBatch('batch_001');

      for (final txn in [txn1, txn2]) {
        expect(db.getAllTransactions().any((t) => t.id == txn.id), isFalse);
      }
      expect(db.getAllTransactions().any((t) => t.id == txn3.id), isTrue);
    });
  });
}
