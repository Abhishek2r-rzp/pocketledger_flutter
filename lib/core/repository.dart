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

abstract class Repository {
  List<Transaction> get transactions;
  List<ReviewItem> get reviewItems;
  List<ImportBatch> get importBatches;
  List<Budget> get budgets;
  List<RecurringPayment> get recurringPayments;
  List<AgentActionLog> get agentLogs;
  UserSettings get settings;
  List<Category> get categories;
  List<TransactionLabel> get labels;
  List<CreditCard> get creditCards;
  List<Account> get accounts;

  List<ParsedTransactionDraft> importDrafts = [];

  void addTransaction(Transaction t);
  void updateTransaction(Transaction t);
  void deleteTransaction(String id);
  Transaction? getTransaction(String id);
  int addTransactions(List<Transaction> transactions);

  void addImportBatch(ImportBatch batch);
  void deleteImportBatch(String id);

  void addReviewItem(ReviewItem item);
  void removeReviewItem(String id);

  void addBudget(Budget budget);
  void deleteBudget(String id);

  void addRecurringPayment(RecurringPayment p);
  void updateRecurringPayment(RecurringPayment p);
  void deleteRecurringPayment(String id);

  void addAgentLog(AgentActionLog log);
  void clearAgentLogs();

  void updateSettings(UserSettings s);

  Category? getCategory(String id);

  void addLabel(TransactionLabel label);
  void updateLabel(TransactionLabel label);
  void deleteLabel(String id);

  void addCreditCard(CreditCard card);
  void updateCreditCard(CreditCard card);
  void deleteCreditCard(String id);

  void addAccount(Account account);
  void updateAccount(Account account);
  void deleteAccount(String id);

  void clearAllData();
}
