import 'package:drift/drift.dart';
import '../database.dart';

part 'import_batch_dao.g.dart';

@DriftAccessor(tables: [ImportBatches, Transactions])
class ImportBatchDao extends DatabaseAccessor<AppDatabase>
    with _$ImportBatchDaoMixin {
  ImportBatchDao(super.db);

  Future<List<ImportBatchEntry>> getAllBatches() {
    return (select(importBatches)
          ..orderBy([(b) => OrderingTerm(expression: b.importedAt, mode: OrderingMode.desc)]))
        .get();
  }

  Future<ImportBatchEntry?> getBatchById(String id) {
    return (select(importBatches)..where((b) => b.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<ImportBatchEntry>> getBatchesByStatus(String status) {
    return (select(importBatches)
          ..where((b) => b.status.equals(status))
          ..orderBy([(b) => OrderingTerm(expression: b.importedAt, mode: OrderingMode.desc)]))
        .get();
  }

  Future<int> insertBatch(ImportBatchEntry entry) {
    return into(importBatches).insert(entry);
  }

  Future<int> updateBatch(ImportBatchEntry entry) {
    return (update(importBatches)..whereSamePrimaryKey(entry)).write(entry);
  }

  Future<int> deleteBatch(String id) async {
    await (delete(transactions)..where((t) => t.importBatchId.equals(id))).go();
    return (delete(importBatches)..where((b) => b.id.equals(id))).go();
  }

  Future<int> clearAll() async {
    return delete(importBatches).go();
  }

  Future<int> getBatchesCount() {
    return customSelect(
      'SELECT COUNT(*) AS count FROM import_batches',
    ).map((row) => row.read<int>('count')).getSingle();
  }

  Future<int> getTotalImportedCount() {
    return customSelect(
      'SELECT COALESCE(SUM(imported_count), 0) AS total FROM import_batches',
    ).map((row) => row.read<int>('total')).getSingle();
  }
}
