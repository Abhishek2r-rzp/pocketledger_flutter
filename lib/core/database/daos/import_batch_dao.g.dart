// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_batch_dao.dart';

// ignore_for_file: type=lint
mixin _$ImportBatchDaoMixin on DatabaseAccessor<AppDatabase> {
  $ImportBatchesTable get importBatches => attachedDatabase.importBatches;
  $CategoriesTable get categories => attachedDatabase.categories;
  $TransactionsTable get transactions => attachedDatabase.transactions;
  ImportBatchDaoManager get managers => ImportBatchDaoManager(this);
}

class ImportBatchDaoManager {
  final _$ImportBatchDaoMixin _db;
  ImportBatchDaoManager(this._db);
  $$ImportBatchesTableTableManager get importBatches =>
      $$ImportBatchesTableTableManager(_db.attachedDatabase, _db.importBatches);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db.attachedDatabase, _db.transactions);
}
