import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

part 'database.g.dart';

class DateTimeConverter extends TypeConverter<DateTime, int> {
  const DateTimeConverter();
  @override
  DateTime fromSql(int fromDb) =>
      DateTime.fromMillisecondsSinceEpoch(fromDb);
  @override
  int toSql(DateTime value) => value.millisecondsSinceEpoch;
}

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();
  @override
  List<String> fromSql(String fromDb) =>
      List<String>.from(jsonDecode(fromDb));
  @override
  String toSql(List<String> value) => jsonEncode(value);
}

@DataClassName('TransactionEntry')
class Transactions extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get importBatchId => text().references(ImportBatches, #id)();
  TextColumn? get accountId => text().nullable()();
  IntColumn get transactionDate =>
      integer().map(const DateTimeConverter()).nullable()();
  IntColumn? get postedDate =>
      integer().map(const DateTimeConverter()).nullable()();
  TextColumn get rawDescription => text()();
  TextColumn? get merchantName => text().nullable()();
  RealColumn get amount => real()();
  TextColumn get direction => text()();
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  RealColumn? get balanceAfter => real().nullable()();
  TextColumn? get categoryId =>
      text().nullable().references(Categories, #id)();
  TextColumn? get categoryName => text().nullable()();
  RealColumn get categorizationConfidence =>
      real().withDefault(const Constant(0.0))();
  TextColumn? get categorizationExplanation => text().nullable()();
  TextColumn get tags =>
      text().map(const StringListConverter()).withDefault(const Constant('[]'))();
  TextColumn get labelIds =>
      text().map(const StringListConverter()).withDefault(const Constant('[]'))();
  TextColumn? get notes => text().nullable()();
  TextColumn get fingerprint => text()();
  IntColumn get isDuplicate => integer().withDefault(const Constant(0))();
  IntColumn get needsReview => integer().withDefault(const Constant(1))();
  IntColumn get createdAt =>
      integer().map(const DateTimeConverter()).nullable()();
  IntColumn get updatedAt =>
      integer().map(const DateTimeConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Index> get indexes => [
        Index('idx_transactions_direction', 'direction'),
        Index('idx_transactions_date', 'transaction_date'),
        Index('idx_transactions_category', 'category_id'),
        Index('idx_transactions_review', 'needs_review'),
        Index('idx_transactions_fingerprint', 'fingerprint'),
        Index('idx_transactions_batch', 'import_batch_id'),
      ];
}

@DataClassName('CategoryEntry')
class Categories extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text().unique()();
  TextColumn? get parentCategoryId =>
      text().nullable().references(Categories, #id)();
  TextColumn get icon => text()();
  TextColumn get type => text()();
  IntColumn get isSystem => integer().withDefault(const Constant(0))();
  IntColumn get createdAt =>
      integer().map(const DateTimeConverter()).nullable()();
  IntColumn get updatedAt =>
      integer().map(const DateTimeConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Index> get indexes => [
        Index('idx_categories_type', 'type'),
        Index('idx_categories_parent', 'parent_category_id'),
      ];
}

@DataClassName('ImportBatchEntry')
class ImportBatches extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get fileName => text()();
  TextColumn get fileType => text()();
  IntColumn get importedAt =>
      integer().map(const DateTimeConverter()).nullable()();
  TextColumn get parserVersion => text()();
  TextColumn get status => text()();
  IntColumn get totalRows => integer().withDefault(const Constant(0))();
  IntColumn get importedCount => integer().withDefault(const Constant(0))();
  IntColumn get duplicateCount => integer().withDefault(const Constant(0))();
  IntColumn get failedCount => integer().withDefault(const Constant(0))();
  IntColumn get reviewCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Index> get indexes => [
        Index('idx_batches_status', 'status'),
        Index('idx_batches_imported_at', 'imported_at'),
      ];
}

@DataClassName('CategorizationRuleEntry')
class CategorizationRules extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get pattern => text()();
  TextColumn get matchType => text()();
  TextColumn get categoryId => text()();
  TextColumn? get categoryName => text().nullable()();
  TextColumn? get merchantName => text().nullable()();
  IntColumn get priority => integer().withDefault(const Constant(0))();
  IntColumn get createdByUser => integer().withDefault(const Constant(0))();
  IntColumn get usageCount => integer().withDefault(const Constant(0))();
  IntColumn get createdAt =>
      integer().map(const DateTimeConverter()).nullable()();
  IntColumn get updatedAt =>
      integer().map(const DateTimeConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Index> get indexes => [
        Index('idx_rules_match_type', 'match_type'),
        Index('idx_rules_category', 'category_id'),
        Index('idx_rules_priority', 'priority'),
      ];
}

@DataClassName('BudgetEntry')
class Budgets extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get categoryId => text()();
  TextColumn? get categoryName => text().nullable()();
  IntColumn get month => integer()();
  IntColumn get year => integer()();
  RealColumn get amount => real()();
  RealColumn get spent => real().withDefault(const Constant(0.0))();
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  IntColumn get createdAt =>
      integer().map(const DateTimeConverter()).nullable()();
  IntColumn get updatedAt =>
      integer().map(const DateTimeConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Index> get indexes => [
        Index('idx_budgets_month_year', 'month, year'),
        Index('idx_budgets_category', 'category_id'),
      ];
}

@DataClassName('RecurringPaymentEntry')
class RecurringPayments extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get merchantName => text()();
  TextColumn? get categoryId => text().nullable()();
  TextColumn? get categoryName => text().nullable()();
  RealColumn get expectedAmount => real()();
  TextColumn get frequency => text()();
  RealColumn get confidence => real().withDefault(const Constant(0.0))();
  TextColumn get status => text()();
  IntColumn? get nextExpectedDate =>
      integer().map(const DateTimeConverter()).nullable()();
  IntColumn? get lastTransactionDate =>
      integer().map(const DateTimeConverter()).nullable()();
  IntColumn get createdAt =>
      integer().map(const DateTimeConverter()).nullable()();
  IntColumn get updatedAt =>
      integer().map(const DateTimeConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Index> get indexes => [
        Index('idx_recurring_status', 'status'),
        Index('idx_recurring_merchant', 'merchant_name'),
      ];
}

@DataClassName('AgentActionLogEntry')
class AgentActionLogs extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get agentName => text()();
  TextColumn get actionType => text()();
  TextColumn? get inputSummary => text().nullable()();
  TextColumn? get outputSummary => text().nullable()();
  RealColumn get confidence => real().withDefault(const Constant(0.0))();
  TextColumn? get explanation => text().nullable()();
  TextColumn? get relatedTransactionId => text().nullable()();
  TextColumn? get relatedImportBatchId => text().nullable()();
  IntColumn get createdAt =>
      integer().map(const DateTimeConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Index> get indexes => [
        Index('idx_agent_logs_agent', 'agent_name'),
        Index('idx_agent_logs_action', 'action_type'),
        Index('idx_agent_logs_created', 'created_at'),
        Index('idx_agent_logs_txn', 'related_transaction_id'),
      ];
}

@DataClassName('ReviewItemsEntry')
class ReviewItems extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get transactionId => text()();
  TextColumn get reason => text()();
  TextColumn? get suggestedCategoryId => text().nullable()();
  TextColumn? get suggestedCategoryName => text().nullable()();
  TextColumn? get suggestedMerchant => text().nullable()();
  RealColumn get confidence => real().withDefault(const Constant(0.0))();
  TextColumn? get explanation => text().nullable()();
  IntColumn get createdAt =>
      integer().map(const DateTimeConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Index> get indexes => [
        Index('idx_review_transaction', 'transaction_id'),
        Index('idx_review_reason', 'reason'),
      ];
}

@DataClassName('TransactionLabelEntry')
class TransactionLabels extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text()();
  IntColumn get color => integer().withDefault(const Constant(0xFF9E9E9E))();
  IntColumn get isSystem => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CreditCardEntry')
class CreditCards extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text()();
  TextColumn? get issuer => text().nullable()();
  TextColumn get lastFour => text()();
  RealColumn get creditLimit => real()();
  RealColumn get availableCredit => real().withDefault(const Constant(0.0))();
  IntColumn get billingDay => integer().withDefault(const Constant(1))();
  IntColumn get dueDay => integer().withDefault(const Constant(15))();
  IntColumn get isActive => integer().withDefault(const Constant(1))();
  IntColumn get createdAt =>
      integer().map(const DateTimeConverter()).nullable()();
  IntColumn get updatedAt =>
      integer().map(const DateTimeConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AccountEntry')
class Accounts extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text()();
  TextColumn? get bankName => text().nullable()();
  TextColumn get type => text()();
  RealColumn get balance => real().withDefault(const Constant(0.0))();
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  TextColumn? get lastFour => text().nullable()();
  IntColumn get isActive => integer().withDefault(const Constant(1))();
  IntColumn get createdAt =>
      integer().map(const DateTimeConverter()).nullable()();
  IntColumn get updatedAt =>
      integer().map(const DateTimeConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('UserSettingsEntry')
class UserSettingsTable extends Table {
  TextColumn get id => text().clientDefault(() => 'default')();
  IntColumn get appLockEnabled => integer().withDefault(const Constant(0))();
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  IntColumn get firstLaunchCompleted =>
      integer().withDefault(const Constant(0))();
  IntColumn get privacyModeEnabled =>
      integer().withDefault(const Constant(0))();
  IntColumn get debugModeEnabled =>
      integer().withDefault(const Constant(0))();
  IntColumn get createdAt =>
      integer().map(const DateTimeConverter()).nullable()();
  IntColumn get updatedAt =>
      integer().map(const DateTimeConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Transactions,
    Categories,
    ImportBatches,
    CategorizationRules,
    Budgets,
    RecurringPayments,
    ReviewItems,
    AgentActionLogs,
    UserSettingsTable,
    TransactionLabels,
    CreditCards,
    Accounts,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
      );

  static Future<AppDatabase> create() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = p.join(dir.path, 'pocketledger.db');
    return AppDatabase(NativeDatabase(File(file)));
  }
}
