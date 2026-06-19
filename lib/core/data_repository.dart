import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:pocketledger/core/repository.dart';
import 'package:pocketledger/core/models/transaction.dart';
import 'package:pocketledger/core/models/account.dart';
import 'package:pocketledger/core/models/transaction_label.dart';
import 'package:pocketledger/core/models/credit_card.dart';
import 'package:pocketledger/core/models/category.dart';
import 'package:pocketledger/core/models/review_item.dart';
import 'package:pocketledger/core/models/import_batch.dart';
import 'package:pocketledger/core/models/budget.dart';
import 'package:pocketledger/core/models/recurring_payment.dart';
import 'package:pocketledger/core/models/agent_action_log.dart';
import 'package:pocketledger/core/models/user_settings.dart';
import 'package:pocketledger/core/models/parsed_transaction_draft.dart';

final dataRepositoryProvider = Provider<Repository>((ref) {
  return DataRepository();
});

class DataRepository extends Repository {
  final List<Transaction> _transactions = [];
  final List<ReviewItem> _reviewItems = [];
  final List<ImportBatch> _importBatches = [];
  final List<Budget> _budgets = [];
  final List<RecurringPayment> _recurringPayments = [];
  final List<AgentActionLog> _agentLogs = [];
  final List<TransactionLabel> _labels = [];
  final List<CreditCard> _creditCards = [];
  final List<Account> _accounts = [];
  UserSettings _settings = UserSettings();
  List<Category> _categories = [];
  int _txnCounter = 0;

  DataRepository() {
    _categories = List.from(Category.defaults);
  }

  void _addTransaction(Transaction t) {
    _transactions.add(t);
    _txnCounter++;
  }

  List<Transaction> get transactions => List.unmodifiable(_transactions);
  List<ReviewItem> get reviewItems => List.unmodifiable(_reviewItems);
  List<ImportBatch> get importBatches => List.unmodifiable(_importBatches);
  List<Budget> get budgets => List.unmodifiable(_budgets);
  List<RecurringPayment> get recurringPayments =>
      List.unmodifiable(_recurringPayments);
  List<AgentActionLog> get agentLogs => List.unmodifiable(_agentLogs);
  UserSettings get settings => _settings;
  List<Category> get categories => List.unmodifiable(_categories);
  List<TransactionLabel> get labels => List.unmodifiable(_labels);
  List<CreditCard> get creditCards => List.unmodifiable(_creditCards);
  List<Account> get accounts => List.unmodifiable(_accounts);

  void addTransaction(Transaction t) => _addTransaction(t);
  void updateTransaction(Transaction t) {
    final idx = _transactions.indexWhere((e) => e.id == t.id);
    if (idx >= 0) _transactions[idx] = t;
  }

  void deleteTransaction(String id) =>
      _transactions.removeWhere((t) => t.id == id);
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
    return transactions.length;
  }

  void _addImportBatch(ImportBatch batch) => _importBatches.add(batch);
  void addImportBatch(ImportBatch batch) => _importBatches.add(batch);
  void deleteImportBatch(String id) =>
      _importBatches.removeWhere((b) => b.id == id);

  void addReviewItem(ReviewItem item) => _reviewItems.add(item);
  void removeReviewItem(String id) =>
      _reviewItems.removeWhere((r) => r.id == id);

  void addBudget(Budget budget) => _budgets.add(budget);
  void deleteBudget(String id) => _budgets.removeWhere((b) => b.id == id);

  void addRecurringPayment(RecurringPayment p) => _recurringPayments.add(p);
  void updateRecurringPayment(RecurringPayment p) {
    final idx = _recurringPayments.indexWhere((r) => r.id == p.id);
    if (idx >= 0) _recurringPayments[idx] = p;
  }

  void deleteRecurringPayment(String id) =>
      _recurringPayments.removeWhere((r) => r.id == id);

  void addAgentLog(AgentActionLog log) => _agentLogs.add(log);
  void clearAgentLogs() => _agentLogs.clear();

  void updateSettings(UserSettings s) => _settings = s;

  List<ParsedTransactionDraft> importDrafts = [];

  Category? getCategory(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  void addLabel(TransactionLabel label) => _labels.add(label);
  void updateLabel(TransactionLabel label) {
    final idx = _labels.indexWhere((l) => l.id == label.id);
    if (idx >= 0) _labels[idx] = label;
  }

  void deleteLabel(String id) => _labels.removeWhere((l) => l.id == id);

  void addCreditCard(CreditCard card) => _creditCards.add(card);
  void updateCreditCard(CreditCard card) {
    final idx = _creditCards.indexWhere((c) => c.id == card.id);
    if (idx >= 0) _creditCards[idx] = card;
  }

  void deleteCreditCard(String id) =>
      _creditCards.removeWhere((c) => c.id == id);

  void addAccount(Account account) => _accounts.add(account);
  void updateAccount(Account account) {
    final idx = _accounts.indexWhere((a) => a.id == account.id);
    if (idx >= 0) _accounts[idx] = account;
  }

  void deleteAccount(String id) => _accounts.removeWhere((a) => a.id == id);

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
  }
}
