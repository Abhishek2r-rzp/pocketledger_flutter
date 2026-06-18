import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';
import 'package:pocketledger/core/repository.dart';
import 'package:pocketledger/core/models/account.dart';
import 'package:pocketledger/core/models/agent_action_log.dart';
import 'package:pocketledger/core/models/budget.dart';
import 'package:pocketledger/core/models/category.dart';
import 'package:pocketledger/core/models/credit_card.dart';
import 'package:pocketledger/core/models/import_batch.dart';
import 'package:pocketledger/core/models/parsed_transaction_draft.dart';
import 'package:pocketledger/core/models/recurring_payment.dart';
import 'package:pocketledger/core/models/review_item.dart';
import 'package:pocketledger/core/models/transaction.dart';
import 'package:pocketledger/core/models/transaction_label.dart';
import 'package:pocketledger/core/models/user_settings.dart';
import 'package:pocketledger/core/models/enums.dart';
import 'package:pocketledger/core/database/database.dart';
import 'package:pocketledger/core/database/daos/transaction_dao.dart';
import 'package:pocketledger/core/database/daos/category_dao.dart';
import 'package:pocketledger/core/database/daos/budget_dao.dart';
import 'package:pocketledger/core/database/daos/import_batch_dao.dart';
import 'package:pocketledger/core/database/daos/recurring_payment_dao.dart';
import 'package:pocketledger/core/database/daos/agent_log_dao.dart';
import 'package:pocketledger/core/database/daos/settings_dao.dart';
import 'package:pocketledger/core/database/seed_data.dart';

final _uuid = Uuid();

class DatabaseRepository extends Repository {
  final AppDatabase _db;
  late final TransactionDao _transactionDao;
  late final CategoryDao _categoryDao;
  late final BudgetDao _budgetDao;
  late final ImportBatchDao _importBatchDao;
  late final RecurringPaymentDao _recurringPaymentDao;
  late final AgentLogDao _agentLogDao;
  late final SettingsDao _settingsDao;

  List<Transaction> _transactions = [];
  List<ReviewItem> _reviewItems = [];
  List<ImportBatch> _importBatches = [];
  List<Budget> _budgets = [];
  List<RecurringPayment> _recurringPayments = [];
  List<AgentActionLog> _agentLogs = [];
  UserSettings _settings = const UserSettings();
  List<Category> _categories = [];
  List<TransactionLabel> _labels = [];
  List<CreditCard> _creditCards = [];
  List<Account> _accounts = [];
  List<ParsedTransactionDraft> importDrafts = [];
  int _txnCounter = 0;

  DatabaseRepository({required AppDatabase db}) : _db = db {
    _transactionDao = TransactionDao(db);
    _categoryDao = CategoryDao(db);
    _budgetDao = BudgetDao(db);
    _importBatchDao = ImportBatchDao(db);
    _recurringPaymentDao = RecurringPaymentDao(db);
    _agentLogDao = AgentLogDao(db);
    _settingsDao = SettingsDao(db);
  }

  Future<void> init() async {
    await SeedData.seedIfEmpty(_categoryDao);
    await _loadAll();
  }

  Future<void> _loadAll() async {
    _categories = (await _categoryDao.getAllCategories()).map(_mapCategoryEntry).toList();
    if (_categories.isEmpty) {
      _categories = List.from(Category.defaults);
    }

    _transactions = (await _transactionDao.getAllTransactions()).map(_mapTransactionEntry).toList();
    _txnCounter = _transactions.length;

    _importBatches = (await _importBatchDao.getAllBatches()).map(_mapImportBatchEntry).toList();
    _budgets = (await _budgetDao.getAllBudgets()).map(_mapBudgetEntry).toList();
    _recurringPayments = (await _recurringPaymentDao.getAllPayments()).map(_mapRecurringPaymentEntry).toList();
    _agentLogs = (await _agentLogDao.getAllLogs()).map(_mapAgentLogEntry).toList();

    final settingsEntry = await _settingsDao.getOrCreateSettings();
    _settings = _mapSettingsEntry(settingsEntry);

    final reviewEntries = await _db.reviewItemsQuery().get();
    _reviewItems = reviewEntries.map(_mapReviewItemEntry).toList();

    final labelEntries = await _db.transactionLabelsQuery().get();
    _labels = labelEntries.map(_mapLabelEntry).toList();

    final cardEntries = await _db.creditCardsQuery().get();
    _creditCards = cardEntries.map(_mapCreditCardEntry).toList();

    final accountEntries = await _db.accountsQuery().get();
    _accounts = accountEntries.map(_mapAccountEntry).toList();

    if (_transactions.isEmpty) {
      _seedSampleData();
    }
  }

  void _seedSampleData() {
    final now = DateTime.now();
    final merchants = [
      'Amazon', 'Swiggy', 'Uber', 'Zomato', 'Flipkart',
      'BigBasket', 'Netflix', 'Reliance Digital', 'Myntra', 'DMart',
    ];
    for (int i = 0; i < 20; i++) {
      final day = now.subtract(Duration(days: i));
      final isCredit = i % 5 == 0;
      final cat = _categories[i % (_categories.length - 1)];
      final txn = Transaction(
        id: _uuid.v4(),
        date: day,
        amount: isCredit ? 50000.0 + (i * 100) : (200.0 + (i * 50)),
        direction: isCredit ? TransactionDirection.income : TransactionDirection.expense,
        description: isCredit ? 'Salary deposit' : 'Payment to ${merchants[i % merchants.length]}',
        merchantName: isCredit ? 'Employer Inc.' : merchants[i % merchants.length],
        categoryId: isCredit ? 'salary' : cat.id,
        categoryName: isCredit ? 'Salary & Income' : cat.name,
        balance: 50000.0 - (i * 2000),
        currency: 'INR',
        fingerprint: 'fp_$_txnCounter',
        importBatchId: 'seed_batch',
        notes: null,
        tags: [],
        createdAt: day,
      );
      _addTransaction(txn);
    }
    _importBatches.add(ImportBatch(
      id: 'seed_batch',
      fileName: 'sample_data.csv',
      fileType: 'csv',
      filePath: '',
      totalRows: 20,
      importedRows: 20,
      duplicateRows: 0,
      failedRows: 0,
      createdAt: now,
    ));
  }

  void _addTransaction(Transaction t) {
    _transactions.add(t);
    _txnCounter++;
  }

  List<Transaction> get transactions => List.unmodifiable(_transactions);
  List<ReviewItem> get reviewItems => List.unmodifiable(_reviewItems);
  List<ImportBatch> get importBatches => List.unmodifiable(_importBatches);
  List<Budget> get budgets => List.unmodifiable(_budgets);
  List<RecurringPayment> get recurringPayments => List.unmodifiable(_recurringPayments);
  List<AgentActionLog> get agentLogs => List.unmodifiable(_agentLogs);
  UserSettings get settings => _settings;
  List<Category> get categories => List.unmodifiable(_categories);
  List<TransactionLabel> get labels => List.unmodifiable(_labels);
  List<CreditCard> get creditCards => List.unmodifiable(_creditCards);
  List<Account> get accounts => List.unmodifiable(_accounts);

  void addTransaction(Transaction t) {
    _addTransaction(t);
    _transactionDao.insertTransaction(_toTransactionEntry(t));
  }

  void updateTransaction(Transaction t) {
    final idx = _transactions.indexWhere((e) => e.id == t.id);
    if (idx >= 0) _transactions[idx] = t;
    _transactionDao.updateTransaction(_toTransactionEntry(t));
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
    _transactionDao.deleteTransaction(id);
  }

  Transaction? getTransaction(String id) {
    try {
      return _transactions.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  int addTransactions(List<Transaction> transactions) {
    for (final t in transactions) {
      _addTransaction(t);
    }
    _transactionDao.insertTransactions(transactions.map(_toTransactionEntry).toList());
    return transactions.length;
  }

  void addImportBatch(ImportBatch batch) {
    _importBatches.add(batch);
    _importBatchDao.insertBatch(_toImportBatchEntry(batch));
  }

  void deleteImportBatch(String id) {
    _importBatches.removeWhere((b) => b.id == id);
    _importBatchDao.deleteBatch(id);
  }

  void addReviewItem(ReviewItem item) {
    _reviewItems.add(item);
    _db.into(_db.reviewItems).insert(_toReviewItemEntry(item));
  }

  void removeReviewItem(String id) {
    _reviewItems.removeWhere((r) => r.id == id);
    _db.reviewItemsQuery().deleteReviewItem(id);
  }

  void addBudget(Budget budget) {
    _budgets.add(budget);
    _budgetDao.insertBudget(_toBudgetEntry(budget));
  }

  void deleteBudget(String id) {
    _budgets.removeWhere((b) => b.id == id);
    _budgetDao.deleteBudget(id);
  }

  void addRecurringPayment(RecurringPayment p) {
    _recurringPayments.add(p);
    _recurringPaymentDao.insertPayment(_toRecurringPaymentEntry(p));
  }

  void updateRecurringPayment(RecurringPayment p) {
    final idx = _recurringPayments.indexWhere((r) => r.id == p.id);
    if (idx >= 0) _recurringPayments[idx] = p;
    _recurringPaymentDao.updatePayment(_toRecurringPaymentEntry(p));
  }

  void deleteRecurringPayment(String id) {
    _recurringPayments.removeWhere((r) => r.id == id);
    _recurringPaymentDao.deletePayment(id);
  }

  void addAgentLog(AgentActionLog log) {
    _agentLogs.add(log);
    _agentLogDao.insertLog(_toAgentLogEntry(log));
  }

  void clearAgentLogs() {
    _agentLogs.clear();
    _agentLogDao.clearAllLogs();
  }

  void updateSettings(UserSettings s) {
    _settings = s;
    _settingsDao.updateAppLock(s.appLockEnabled);
    _settingsDao.updateCurrency(s.currency);
    if (s.firstLaunchCompleted) {
      _settingsDao.completeFirstLaunch();
    }
    if (s.privacyModeEnabled) {
      _settingsDao.togglePrivacyMode();
    }
    if (s.debugModeEnabled) {
      _settingsDao.toggleDebugMode();
    }
  }

  Category? getCategory(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  void addLabel(TransactionLabel label) {
    _labels.add(label);
    _db.into(_db.transactionLabels).insert(_toLabelEntry(label));
  }

  void updateLabel(TransactionLabel label) {
    final idx = _labels.indexWhere((l) => l.id == label.id);
    if (idx >= 0) _labels[idx] = label;
    _db.transactionLabelsQuery().replace(_toLabelEntry(label));
  }

  void deleteLabel(String id) {
    _labels.removeWhere((l) => l.id == id);
    (_db.transactionLabelsQuery()..where((tbl) => tbl.id.equals(id))).delete();
  }

  void addCreditCard(CreditCard card) {
    _creditCards.add(card);
    _db.into(_db.creditCards).insert(_toCreditCardEntry(card));
  }

  void updateCreditCard(CreditCard card) {
    final idx = _creditCards.indexWhere((c) => c.id == card.id);
    if (idx >= 0) _creditCards[idx] = card;
    _db.creditCardsQuery().replace(_toCreditCardEntry(card));
  }

  void deleteCreditCard(String id) {
    _creditCards.removeWhere((c) => c.id == id);
    (_db.creditCardsQuery()..where((tbl) => tbl.id.equals(id))).delete();
  }

  void addAccount(Account account) {
    _accounts.add(account);
    _db.into(_db.accounts).insert(_toAccountEntry(account));
  }

  void updateAccount(Account account) {
    final idx = _accounts.indexWhere((a) => a.id == account.id);
    if (idx >= 0) _accounts[idx] = account;
    _db.accountsQuery().replace(_toAccountEntry(account));
  }

  void deleteAccount(String id) {
    _accounts.removeWhere((a) => a.id == id);
    (_db.accountsQuery()..where((tbl) => tbl.id.equals(id))).delete();
  }

  void clearAllData() {
    _transactions.clear();
    _reviewItems.clear();
    _importBatches.clear();
    _budgets.clear();
    _recurringPayments.clear();
    _agentLogs.clear();
    _labels.clear();
    _creditCards.clear();
    _accounts.clear();
    _transactionDao.deleteAll();
    _importBatchDao.clearAll();
    _budgetDao.clearAll();
    _recurringPaymentDao.clearAll();
    _agentLogDao.clearAllLogs();
    (_db.transactionLabelsQuery()..where((tbl) => tbl.id.isNotNull())).delete();
    (_db.creditCardsQuery()..where((tbl) => tbl.id.isNotNull())).delete();
    (_db.accountsQuery()..where((tbl) => tbl.id.isNotNull())).delete();
  }

  TransactionEntry _toTransactionEntry(Transaction t) {
    return TransactionEntry(
      id: t.id,
      importBatchId: t.importBatchId,
      transactionDate: t.date,
      rawDescription: t.description,
      merchantName: t.merchantName,
      amount: t.amount,
      direction: t.direction.name,
      currency: t.currency,
      balanceAfter: t.balance,
      categoryId: t.categoryId,
      categoryName: t.categoryName,
      categorizationConfidence: t.confidence,
      tags: t.tags,
      labelIds: t.labelIds,
      notes: t.notes,
      fingerprint: t.fingerprint,
      needsReview: t.needsReview ? 1 : 0,
      createdAt: t.createdAt,
      updatedAt: t.updatedAt,
    );
  }

  Transaction _mapTransactionEntry(TransactionEntry e) {
    return Transaction(
      id: e.id,
      date: e.transactionDate ?? DateTime.now(),
      amount: e.amount,
      direction: TransactionDirection.values.firstWhere(
        (d) => d.name == e.direction,
        orElse: () => TransactionDirection.unknown,
      ),
      description: e.rawDescription,
      merchantName: e.merchantName,
      categoryId: e.categoryId,
      categoryName: e.categoryName,
      balance: e.balanceAfter,
      currency: e.currency,
      fingerprint: e.fingerprint,
      importBatchId: e.importBatchId,
      tags: e.tags,
      labelIds: e.labelIds,
      notes: e.notes,
      confidence: e.categorizationConfidence,
      needsReview: e.needsReview == 1,
      createdAt: e.createdAt ?? DateTime.now(),
      updatedAt: e.updatedAt,
    );
  }

  Category _mapCategoryEntry(CategoryEntry e) {
    return Category(
      id: e.id,
      name: e.name,
      icon: e.icon,
      isSystem: e.isSystem == 1,
    );
  }

  ImportBatch _mapImportBatchEntry(ImportBatchEntry e) {
    return ImportBatch(
      id: e.id,
      fileName: e.fileName,
      fileType: e.fileType,
      filePath: '',
      totalRows: e.totalRows,
      importedRows: e.importedCount,
      duplicateRows: e.duplicateCount,
      failedRows: e.failedCount,
      createdAt: e.importedAt ?? DateTime.now(),
    );
  }

  ImportBatchEntry _toImportBatchEntry(ImportBatch b) {
    return ImportBatchEntry(
      id: b.id,
      fileName: b.fileName,
      fileType: b.fileType,
      status: 'completed',
      parserVersion: '1.0',
      importedAt: b.createdAt,
      totalRows: b.totalRows,
      importedCount: b.importedRows,
      duplicateCount: b.duplicateRows,
      failedCount: b.failedRows,
    );
  }

  Budget _mapBudgetEntry(BudgetEntry e) {
    return Budget(
      id: e.id,
      categoryId: e.categoryId,
      categoryName: e.categoryName ?? '',
      amount: e.amount,
      month: e.month,
      year: e.year,
      createdAt: e.createdAt ?? DateTime.now(),
    );
  }

  BudgetEntry _toBudgetEntry(Budget b) {
    return BudgetEntry(
      id: b.id,
      categoryId: b.categoryId,
      categoryName: b.categoryName,
      month: b.month,
      year: b.year,
      amount: b.amount,
      createdAt: b.createdAt,
    );
  }

  RecurringPayment _mapRecurringPaymentEntry(RecurringPaymentEntry e) {
    return RecurringPayment(
      id: e.id,
      merchantName: e.merchantName,
      amount: e.expectedAmount,
      frequency: PaymentFrequency.values.firstWhere(
        (f) => f.name == e.frequency,
        orElse: () => PaymentFrequency.monthly,
      ),
      categoryId: e.categoryId,
      categoryName: e.categoryName,
      lastDetected: e.lastTransactionDate ?? DateTime.now(),
      occurrences: 0,
      averageAmount: e.expectedAmount,
      active: e.status == 'confirmed',
      createdAt: e.createdAt ?? DateTime.now(),
    );
  }

  RecurringPaymentEntry _toRecurringPaymentEntry(RecurringPayment p) {
    return RecurringPaymentEntry(
      id: p.id,
      merchantName: p.merchantName,
      expectedAmount: p.amount ?? 0,
      frequency: p.frequency?.name ?? 'monthly',
      categoryId: p.categoryId,
      categoryName: p.categoryName,
      status: p.active ? 'confirmed' : 'detected',
      confidence: 0.8,
      lastTransactionDate: p.lastDetected,
      createdAt: p.createdAt,
    );
  }

  AgentActionLog _mapAgentLogEntry(AgentActionLogEntry e) {
    return AgentActionLog(
      id: e.id,
      agentName: e.agentName,
      actionType: e.actionType,
      inputSummary: e.inputSummary,
      outputSummary: e.outputSummary,
      confidence: e.confidence,
      explanation: e.explanation,
      transactionId: e.relatedTransactionId,
      batchId: e.relatedImportBatchId,
      createdAt: e.createdAt ?? DateTime.now(),
    );
  }

  AgentActionLogEntry _toAgentLogEntry(AgentActionLog l) {
    return AgentActionLogEntry(
      id: l.id,
      agentName: l.agentName,
      actionType: l.actionType,
      inputSummary: l.inputSummary,
      outputSummary: l.outputSummary,
      confidence: l.confidence,
      explanation: l.explanation,
      relatedTransactionId: l.transactionId,
      relatedImportBatchId: l.batchId,
      createdAt: l.createdAt,
    );
  }

  UserSettings _mapSettingsEntry(UserSettingsEntry e) {
    return UserSettings(
      appLockEnabled: e.appLockEnabled == 1,
      currency: e.currency,
      firstLaunchCompleted: e.firstLaunchCompleted == 1,
      privacyModeEnabled: e.privacyModeEnabled == 1,
      debugModeEnabled: e.debugModeEnabled == 1,
    );
  }

  ReviewItem _mapReviewItemEntry(ReviewItemsEntry e) {
    return ReviewItem(
      id: e.id,
      transactionId: e.transactionId,
      reason: ReviewReason.values.firstWhere(
        (r) => r.name == e.reason,
        orElse: () => ReviewReason.lowConfidence,
      ),
      suggestedCategoryId: e.suggestedCategoryId,
      suggestedCategoryName: e.suggestedCategoryName,
      suggestedMerchant: e.suggestedMerchant,
      confidence: e.confidence,
      explanation: e.explanation,
      createdAt: e.createdAt ?? DateTime.now(),
    );
  }

  ReviewItemsEntry _toReviewItemEntry(ReviewItem r) {
    return ReviewItemsEntry(
      id: r.id,
      transactionId: r.transactionId,
      reason: r.reason.name,
      suggestedCategoryId: r.suggestedCategoryId,
      suggestedCategoryName: r.suggestedCategoryName,
      suggestedMerchant: r.suggestedMerchant,
      confidence: r.confidence,
      explanation: r.explanation,
      createdAt: r.createdAt,
    );
  }

  TransactionLabel _mapLabelEntry(TransactionLabelEntry e) {
    return TransactionLabel(
      id: e.id,
      name: e.name,
      color: e.color,
      isSystem: e.isSystem == 1,
    );
  }

  TransactionLabelEntry _toLabelEntry(TransactionLabel l) {
    return TransactionLabelEntry(
      id: l.id,
      name: l.name,
      color: l.color,
      isSystem: l.isSystem ? 1 : 0,
    );
  }

  CreditCard _mapCreditCardEntry(CreditCardEntry e) {
    return CreditCard(
      id: e.id,
      name: e.name,
      issuer: e.issuer,
      lastFour: e.lastFour,
      creditLimit: e.creditLimit,
      availableCredit: e.availableCredit,
      billingDay: e.billingDay,
      dueDay: e.dueDay,
      isActive: e.isActive == 1,
      createdAt: e.createdAt ?? DateTime.now(),
      updatedAt: e.updatedAt,
    );
  }

  CreditCardEntry _toCreditCardEntry(CreditCard c) {
    return CreditCardEntry(
      id: c.id,
      name: c.name,
      issuer: c.issuer,
      lastFour: c.lastFour,
      creditLimit: c.creditLimit,
      availableCredit: c.availableCredit,
      billingDay: c.billingDay,
      dueDay: c.dueDay,
      isActive: c.isActive ? 1 : 0,
      createdAt: c.createdAt,
      updatedAt: c.updatedAt,
    );
  }

  Account _mapAccountEntry(AccountEntry e) {
    return Account(
      id: e.id,
      name: e.name,
      bankName: e.bankName,
      type: AccountType.values.firstWhere(
        (a) => a.name == e.type,
        orElse: () => AccountType.savings,
      ),
      balance: e.balance,
      currency: e.currency,
      lastFour: e.lastFour,
      isActive: e.isActive == 1,
      createdAt: e.createdAt ?? DateTime.now(),
      updatedAt: e.updatedAt,
    );
  }

  AccountEntry _toAccountEntry(Account a) {
    return AccountEntry(
      id: a.id,
      name: a.name,
      bankName: a.bankName,
      type: a.type.name,
      balance: a.balance,
      currency: a.currency,
      lastFour: a.lastFour,
      isActive: a.isActive ? 1 : 0,
      createdAt: a.createdAt,
      updatedAt: a.updatedAt,
    );
  }
}
