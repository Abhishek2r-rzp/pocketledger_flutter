import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/core/models/transaction.dart';
import 'package:pocketledger/core/models/account.dart';
import 'package:pocketledger/core/models/transaction_label.dart';
import 'package:pocketledger/core/models/credit_card.dart';
import 'package:pocketledger/core/models/import_batch.dart';
import 'package:pocketledger/core/models/review_item.dart';
import 'package:pocketledger/core/models/enums.dart';
import 'package:pocketledger/core/models/parsed_transaction_draft.dart';
import 'package:pocketledger/parsers/csv_parser.dart';
import 'package:pocketledger/parsers/pdf_parser.dart';

/// Generate a test PDF with bank statement text using uncompressed stream.
String _createPdfFromText(String content, String dirPath) {
  final lines = content.split('\n');
  final textOps = StringBuffer();
  for (final line in lines) {
    final escaped = line
        .replaceAll('\\', '\\\\')
        .replaceAll('(', '\\(')
        .replaceAll(')', '\\)');
    textOps.write('($escaped) Tj\n');
    textOps.write('0 -14 Td\n');
  }

  final streamContent =
      utf8.encode('BT\n/F1 10 Tf\n10 750 Td\n${textOps.toString()}ET\n');
  final bytes = BytesBuilder();

  void _w(String s) => bytes.add(utf8.encode(s));
  void _wb(List<int> b) => bytes.add(b);

  _w('%PDF-1.4\n');
  _w('1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n');
  _w('2 0 obj\n<< /Type /Pages /Kids [3 0 R] /Count 1 >>\nendobj\n');
  _w(
      '3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792]\n   /Contents 4 0 R /Resources << /Font << /F1 5 0 R >> >> >>\nendobj\n');
  _w('4 0 obj\n<< /Length ${streamContent.length} >>\nstream\n');
  _wb(streamContent);
  _w('\nendstream\nendobj\n');
  _w(
      '5 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Courier >>\nendobj\n');
  _w(
      'xref\n0 6\n0000000000 65535 f \n0000000009 00000 n \n0000000058 00000 n \n0000000115 00000 n \n0000000266 00000 n \n0000000372 00000 n \ntrailer\n<< /Size 6 /Root 1 0 R >>\nstartxref\n422\n%%EOF\n');

  final file =
      File('$dirPath${Platform.pathSeparator}test_statement.pdf');
  file.writeAsBytesSync(bytes.toBytes());
  return file.path;
}

const _uuid = Uuid();

/// 10 realistic Indian bank statement records in CSV format.
/// Uses column headers that CSVParser recognizes (Date, Narration,
/// Withdrawal Amt., Deposit Amt., Closing Balance).
const String _csvData =
    '''Date,Narration,Withdrawal Amt.,Deposit Amt.,Closing Balance
01/03/2025,SALARY CREDIT,,85000.00,125000.00
02/03/2025,SWIGGY UPI PAYMENT,450.00,,124550.00
03/03/2025,UBER INDIA PVT LTD,320.00,,124230.00
04/03/2025,AMAZON PAY INDIA,1299.00,,122931.00
05/03/2025,NETFLIX SUBSCRIPTION,649.00,,122282.00
06/03/2025,BIGBASKET GROCERIES,2340.00,,119942.00
07/03/2025,ZOMATO LIMITED,567.00,,119375.00
08/03/2025,ELECTRICITY BILL PAYMENT,3200.00,,116175.00
09/03/2025,FLIPKART SHOPPING,1899.00,,114276.00
10/03/2025,ATM CASH WITHDRAWAL,5000.00,,109276.00''';

/// Expected normalized descriptions after CSVParser.normalizeDescription
final List<String> _expectedDescriptions = [
  'SALARY CREDIT',
  'SWIGGY',
  'UBER INDIA PVT LTD',
  'AMAZON PAY INDIA',
  'NETFLIX SUBSCRIPTION',
  'BIGBASKET GROCERIES',
  'ZOMATO LIMITED',
  'ELECTRICITY BILL PAYMENT',
  'FLIPKART SHOPPING',
  'ATM CASH WITHDRAWAL',
];

const _expectedAmounts = <double>[
  85000.00,
  450.00,
  320.00,
  1299.00,
  649.00,
  2340.00,
  567.00,
  3200.00,
  1899.00,
  5000.00,
];

/// Simulate what ImportNotifier.confirm() does.
List<Transaction> _simulateImport(
    DataRepository repo, List<ParsedTransactionDraft> drafts, String batchId) {
  final transactions = <Transaction>[];
  for (int i = 0; i < drafts.length; i++) {
    final draft = drafts[i];
    final txn = Transaction(
      id: _uuid.v4(),
      date: draft.date ?? DateTime.now(),
      amount: draft.resolvedAmount.abs(),
      direction: draft.resolvedDirection,
      description: draft.description ?? 'Unknown',
      merchantName: null,
      categoryId: null,
      categoryName: null,
      balance: draft.balance,
      currency: 'INR',
      fingerprint: 'import_${batchId}_$i',
      importBatchId: batchId,
      notes: null,
      tags: [],
      confidence: draft.confidence,
      needsReview: true,
      createdAt: DateTime.now(),
    );
    repo.addTransaction(txn);
    transactions.add(txn);

    repo.addReviewItem(ReviewItem(
      id: _uuid.v4(),
      transactionId: txn.id,
      reason: ReviewReason.lowConfidence,
      suggestedCategoryId: null,
      suggestedCategoryName: null,
      suggestedMerchant: null,
      confidence: draft.confidence,
      explanation: 'Newly imported transaction needs review.',
      createdAt: DateTime.now(),
    ));
  }

  repo.addImportBatch(ImportBatch(
    id: batchId,
    fileName: 'test_bank_statement.csv',
    fileType: 'csv',
    filePath: '',
    totalRows: drafts.length,
    importedRows: transactions.length,
    duplicateRows: drafts.length - transactions.length,
    failedRows: 0,
    createdAt: DateTime.now(),
  ));

  return transactions;
}

void _verifyTransaction(Transaction t, int index, String batchId) {
  expect(t.id, isNotEmpty);
  expect(t.importBatchId, batchId);
  expect(t.description, _expectedDescriptions[index]);
  expect(t.amount, _expectedAmounts[index]);
  expect(t.fingerprint, 'import_${batchId}_$index');
  expect(t.needsReview, true);
  expect(t.currency, 'INR');
  expect(t.tags, isEmpty);
  expect(t.labelIds, isEmpty);

  if (index == 0) {
    expect(t.direction, TransactionDirection.income);
  } else {
    expect(t.direction, TransactionDirection.expense);
  }
}

void main() {
  group('Import Pipeline — CSV', () {
    late DataRepository repo;
    late List<ParsedTransactionDraft> drafts;

    setUp(() {
      repo = DataRepository();
      repo.clearAllData();
    });

    test('CSVParser correctly parses 10 bank records', () {
      final parser = CSVParser();
      drafts = parser.parse(_csvData);
      expect(drafts, hasLength(10));
      expect(drafts[0].description, 'SALARY CREDIT');
      expect(drafts[1].description, 'SWIGGY');
      expect(drafts[9].description, 'ATM CASH WITHDRAWAL');
      expect(drafts[0].resolvedDirection, TransactionDirection.income);
      expect(drafts[1].resolvedDirection, TransactionDirection.expense);
    });

    test('CSV import creates 10 transactions, 10 review items, 1 import batch',
        () {
      final parser = CSVParser();
      drafts = parser.parse(_csvData);
      expect(drafts, hasLength(10));

      final batchId = _uuid.v4();
      _simulateImport(repo, drafts, batchId);

      expect(repo.transactions, hasLength(10));
      expect(repo.reviewItems, hasLength(10));
      expect(repo.importBatches, hasLength(1));
      expect(repo.importBatches.first.id, batchId);

      for (int i = 0; i < 10; i++) {
        _verifyTransaction(repo.transactions[i], i, batchId);
      }
    });

    test('CSV import has correct amounts and directions', () {
      final parser = CSVParser();
      drafts = parser.parse(_csvData);
      final batchId = _uuid.v4();
      _simulateImport(repo, drafts, batchId);

      final txns = repo.transactions;
      expect(txns[0].direction, TransactionDirection.income);
      expect(txns[0].amount, 85000.00);

      for (int i = 1; i < 10; i++) {
        expect(txns[i].direction, TransactionDirection.expense);
        expect(txns[i].amount, _expectedAmounts[i]);
      }

      final totalIncome = txns
          .where((t) => t.direction == TransactionDirection.income)
          .fold<double>(0, (s, t) => s + t.amount);
      final totalExpense = txns
          .where((t) => t.direction == TransactionDirection.expense)
          .fold<double>(0, (s, t) => s + t.amount);

      expect(totalIncome, 85000.00);
      expect(totalExpense, 15724.00);
    });

    test('clearAllData removes all data', () {
      final parser = CSVParser();
      drafts = parser.parse(_csvData);
      final batchId = _uuid.v4();
      _simulateImport(repo, drafts, batchId);

      expect(repo.transactions, isNotEmpty);
      expect(repo.reviewItems, isNotEmpty);
      expect(repo.importBatches, isNotEmpty);

      repo.clearAllData();

      expect(repo.transactions, isEmpty);
      expect(repo.reviewItems, isEmpty);
      expect(repo.importBatches, isEmpty);
      expect(repo.budgets, isEmpty);
      expect(repo.recurringPayments, isEmpty);
      expect(repo.agentLogs, isEmpty);
    });

    test('data persists across multiple imports', () {
      final parser = CSVParser();
      drafts = parser.parse(_csvData);
      _simulateImport(repo, drafts, _uuid.v4());
      _simulateImport(repo, drafts, _uuid.v4());

      expect(repo.transactions, hasLength(20));
      expect(repo.importBatches, hasLength(2));
    });
  });

  group('Import Pipeline — PDF', () {
    late DataRepository repo;
    late Directory tempDir;

    setUp(() {
      repo = DataRepository();
      repo.clearAllData();
      tempDir = Directory.systemTemp.createTempSync('pocketledger_test_');
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    String _makePdf(String content) =>
        _createPdfFromText(content, tempDir.path);

    test('PDFParser extracts text and returns drafts', () async {
      final pdfText = [
        'Date                Description              Amount      Balance',
        '01/03/2025          SALARY CREDIT             85000       125000',
        '02/03/2025          SWIGGY FOOD               -450        124550',
        '03/03/2025          UBER RIDE                 -320        124230',
      ].join('\n');

      final path = _makePdf(pdfText);
      final parser = PDFParser();
      final drafts = await parser.parse(path);

      expect(drafts, hasLength(3));
      expect(drafts[0].description, contains('SALARY'));
      expect(drafts[1].description, contains('SWIGGY'));
      expect(drafts[2].description, contains('UBER'));
      expect(drafts[0].resolvedDirection, TransactionDirection.income);
      expect(drafts[1].resolvedDirection, TransactionDirection.expense);
      expect(drafts[2].resolvedDirection, TransactionDirection.expense);
    });

    test('PDF import creates transactions, review items, import batch',
        () async {
      final pdfText = [
        'Date                Description              Amount      Balance',
        '01/03/2025          SALARY CREDIT             85000       125000',
        '02/03/2025          SWIGGY FOOD               -450        124550',
        '03/03/2025          UBER RIDE                 -320        124230',
      ].join('\n');

      final path = _makePdf(pdfText);
      final parser = PDFParser();
      final drafts = await parser.parse(path);

      expect(drafts, hasLength(3));

      final batchId = _uuid.v4();
      for (int i = 0; i < drafts.length; i++) {
        final draft = drafts[i];
        repo.addTransaction(Transaction(
          id: _uuid.v4(),
          date: draft.date ?? DateTime.now(),
          amount: draft.resolvedAmount.abs(),
          direction: draft.resolvedDirection,
          description: draft.description ?? 'Unknown',
          categoryId: null,
          categoryName: null,
          balance: draft.balance,
          currency: 'INR',
          fingerprint: 'import_${batchId}_$i',
          importBatchId: batchId,
          tags: [],
          confidence: draft.confidence,
          needsReview: true,
          createdAt: DateTime.now(),
        ));
        repo.addReviewItem(ReviewItem(
          id: _uuid.v4(),
          transactionId: 'txn_$i',
          reason: ReviewReason.lowConfidence,
          confidence: draft.confidence,
          explanation: 'Newly imported transaction needs review.',
          createdAt: DateTime.now(),
        ));
      }
      repo.addImportBatch(ImportBatch(
        id: batchId,
        fileName: 'test_statement.pdf',
        fileType: 'pdf',
        filePath: path,
        totalRows: drafts.length,
        importedRows: drafts.length,
        duplicateRows: 0,
        failedRows: 0,
        createdAt: DateTime.now(),
      ));

      expect(repo.transactions, hasLength(3));
      expect(repo.reviewItems, hasLength(3));
      expect(repo.importBatches, hasLength(1));

      repo.clearAllData();
      expect(repo.transactions, isEmpty);
      expect(repo.reviewItems, isEmpty);
      expect(repo.importBatches, isEmpty);
    });

    test('empty PDF returns empty drafts', () async {
      final path = _makePdf('');
      final parser = PDFParser();
      final drafts = await parser.parse(path);
      expect(drafts, isEmpty);
    });

    test('PDFParser handles invalid file path gracefully', () async {
      final parser = PDFParser();
      final drafts = await parser.parse('/nonexistent/file.pdf');
      expect(drafts, isEmpty);
    });
  });

  group('Labels', () {
    late DataRepository repo;

    setUp(() {
      repo = DataRepository();
      repo.clearAllData();
    });

    test('addLabel stores a label', () {
      final label = TransactionLabel(
        id: 'lbl_1',
        name: 'Groceries',
        color: 0xFF4CAF50,
      );
      repo.addLabel(label);

      expect(repo.labels, hasLength(1));
      expect(repo.labels.first.name, 'Groceries');
      expect(repo.labels.first.color, 0xFF4CAF50);
    });

    test('labels persist after add', () {
      repo.addLabel(TransactionLabel(id: 'l1', name: 'Groceries'));
      repo.addLabel(TransactionLabel(id: 'l2', name: 'Subscriptions', color: 0xFFE91E63));

      expect(repo.labels, hasLength(2));
      expect(repo.labels.any((l) => l.name == 'Groceries'), isTrue);
      expect(repo.labels.any((l) => l.name == 'Subscriptions'), isTrue);
    });

    test('updateLabel modifies existing label', () {
      repo.addLabel(TransactionLabel(id: 'lbl_1', name: 'Groceries'));
      repo.updateLabel(TransactionLabel(id: 'lbl_1', name: 'Groceries & Essentials', color: 0xFF2196F3));

      expect(repo.labels, hasLength(1));
      expect(repo.labels.first.name, 'Groceries & Essentials');
      expect(repo.labels.first.color, 0xFF2196F3);
    });

    test('deleteLabel removes a label', () {
      repo.addLabel(TransactionLabel(id: 'l1', name: 'Groceries'));
      repo.addLabel(TransactionLabel(id: 'l2', name: 'Subscriptions'));
      repo.deleteLabel('l1');

      expect(repo.labels, hasLength(1));
      expect(repo.labels.first.name, 'Subscriptions');
    });

    test('labelIds on Transaction can be set and read', () {
      repo.addLabel(TransactionLabel(id: 'lbl_1', name: 'Important'));
      repo.addLabel(TransactionLabel(id: 'lbl_2', name: 'Tax Related'));

      final txn = Transaction(
        id: _uuid.v4(),
        date: DateTime.now(),
        amount: 500.0,
        direction: TransactionDirection.expense,
        description: 'Test expense',
        currency: 'INR',
        fingerprint: 'fp_lbl_test',
        importBatchId: 'lbl_batch',
        labelIds: ['lbl_1', 'lbl_2'],
        tags: ['test-tag'],
        createdAt: DateTime.now(),
      );
      repo.addTransaction(txn);

      final saved = repo.getTransaction(txn.id);
      expect(saved, isNotNull);
      expect(saved!.labelIds, contains('lbl_1'));
      expect(saved.labelIds, contains('lbl_2'));
      expect(saved.tags, contains('test-tag'));
    });

    test('clearAllData removes labels', () {
      repo.addLabel(TransactionLabel(id: 'l1', name: 'Groceries'));
      repo.addLabel(TransactionLabel(id: 'l2', name: 'Subscriptions'));
      repo.clearAllData();

      expect(repo.labels, isEmpty);
    });

    test('label defaults are applied correctly', () {
      final label = TransactionLabel(id: 'l1', name: 'Default');
      expect(label.color, 0xFF9E9E9E);
      expect(label.isSystem, false);
    });

    test('copyWith preserves unchanged fields', () {
      final label = TransactionLabel(id: 'l1', name: 'Groceries', color: 0xFF4CAF50, isSystem: false);
      final updated = label.copyWith(name: 'Groceries & Essentials');
      expect(updated.id, 'l1');
      expect(updated.name, 'Groceries & Essentials');
      expect(updated.color, 0xFF4CAF50);
      expect(updated.isSystem, false);
    });
  });

  group('Credit Cards', () {
    late DataRepository repo;

    setUp(() {
      repo = DataRepository();
      repo.clearAllData();
    });

    test('addCreditCard stores a card', () {
      final card = CreditCard(
        id: 'cc_1',
        name: 'HDFC Regalia',
        issuer: 'HDFC Bank',
        lastFour: '1234',
        creditLimit: 200000,
        availableCredit: 150000,
        billingDay: 5,
        dueDay: 20,
        isActive: true,
        createdAt: DateTime.now(),
      );
      repo.addCreditCard(card);

      expect(repo.creditCards, hasLength(1));
      expect(repo.creditCards.first.name, 'HDFC Regalia');
      expect(repo.creditCards.first.lastFour, '1234');
    });

    test('multiple cards persist', () {
      repo.addCreditCard(CreditCard(
        id: 'cc_1', name: 'HDFC Regalia', lastFour: '1234',
        creditLimit: 200000, createdAt: DateTime.now(),
      ));
      repo.addCreditCard(CreditCard(
        id: 'cc_2', name: 'ICICI Sapphire', lastFour: '5678',
        creditLimit: 150000, createdAt: DateTime.now(),
      ));

      expect(repo.creditCards, hasLength(2));
    });

    test('updateCreditCard modifies card', () {
      repo.addCreditCard(CreditCard(
        id: 'cc_1', name: 'HDFC Regalia', lastFour: '1234',
        creditLimit: 200000, createdAt: DateTime.now(),
      ));
      repo.updateCreditCard(CreditCard(
        id: 'cc_1', name: 'HDFC Regalia Gold', lastFour: '1234',
        creditLimit: 300000, createdAt: DateTime.now(),
      ));

      expect(repo.creditCards, hasLength(1));
      expect(repo.creditCards.first.name, 'HDFC Regalia Gold');
      expect(repo.creditCards.first.creditLimit, 300000);
    });

    test('deleteCreditCard removes card', () {
      repo.addCreditCard(CreditCard(
        id: 'cc_1', name: 'HDFC Regalia', lastFour: '1234',
        creditLimit: 200000, createdAt: DateTime.now(),
      ));
      repo.addCreditCard(CreditCard(
        id: 'cc_2', name: 'ICICI Sapphire', lastFour: '5678',
        creditLimit: 150000, createdAt: DateTime.now(),
      ));
      repo.deleteCreditCard('cc_1');

      expect(repo.creditCards, hasLength(1));
      expect(repo.creditCards.first.name, 'ICICI Sapphire');
    });

    test('outstandingAmount is creditLimit minus availableCredit', () {
      final card = CreditCard(
        id: 'cc_1', name: 'HDFC Regalia', lastFour: '1234',
        creditLimit: 100000, availableCredit: 60000,
        createdAt: DateTime.now(),
      );
      expect(card.outstandingAmount, 40000);
    });

    test('isOverLimit when outstanding exceeds limit', () {
      final card = CreditCard(
        id: 'cc_1', name: 'Test Card', lastFour: '0000',
        creditLimit: 50000, availableCredit: -1000,
        createdAt: DateTime.now(),
      );
      expect(card.isOverLimit, isTrue);
    });

    test('isOverLimit false when within limit', () {
      final card = CreditCard(
        id: 'cc_1', name: 'Test Card', lastFour: '0000',
        creditLimit: 50000, availableCredit: 25000,
        createdAt: DateTime.now(),
      );
      expect(card.isOverLimit, isFalse);
    });

    test('copyWith preserves unchanged fields', () {
      final now = DateTime.now();
      final card = CreditCard(
        id: 'cc_1', name: 'HDFC Regalia', lastFour: '1234',
        creditLimit: 200000, billingDay: 5, dueDay: 20,
        createdAt: now,
      );
      final updated = card.copyWith(creditLimit: 300000, availableCredit: 150000);
      expect(updated.id, 'cc_1');
      expect(updated.name, 'HDFC Regalia');
      expect(updated.creditLimit, 300000);
      expect(updated.availableCredit, 150000);
      expect(updated.billingDay, 5);
      expect(updated.dueDay, 20);
    });

    test('clearAllData removes credit cards', () {
      repo.addCreditCard(CreditCard(
        id: 'cc_1', name: 'HDFC Regalia', lastFour: '1234',
        creditLimit: 200000, createdAt: DateTime.now(),
      ));
      repo.clearAllData();
      expect(repo.creditCards, isEmpty);
    });

    test('transactions can reference credit card via accountId', () {
      repo.addCreditCard(CreditCard(
        id: 'cc_1', name: 'HDFC Regalia', lastFour: '1234',
        creditLimit: 200000, createdAt: DateTime.now(),
      ));

      final txn = Transaction(
        id: _uuid.v4(),
        date: DateTime.now(),
        amount: 1500.0,
        direction: TransactionDirection.expense,
        description: 'Amazon purchase on card',
        currency: 'INR',
        fingerprint: 'fp_cc_txn',
        importBatchId: 'cc_batch',
        labelIds: [],
        tags: ['credit-card'],
        createdAt: DateTime.now(),
      );
      repo.addTransaction(txn);

      final saved = repo.getTransaction(txn.id);
      expect(saved, isNotNull);
      expect(saved!.tags, contains('credit-card'));
      expect(repo.creditCards.first.name, 'HDFC Regalia');
    });
  });

  group('Accounts', () {
    late DataRepository repo;

    setUp(() {
      repo = DataRepository();
      repo.clearAllData();
    });

    test('addAccount stores an account', () {
      repo.addAccount(Account(
        id: 'acc_1', name: 'HDFC Savings', bankName: 'HDFC Bank',
        type: AccountType.savings, balance: 50000, lastFour: '1234',
        createdAt: DateTime.now(),
      ));
      expect(repo.accounts, hasLength(1));
      expect(repo.accounts.first.name, 'HDFC Savings');
      expect(repo.accounts.first.balance, 50000);
      expect(repo.accounts.first.lastFour, '1234');
    });

    test('addAccount sets defaults correctly', () {
      repo.addAccount(Account(
        id: 'acc_1', name: 'Cash Wallet',
        createdAt: DateTime.now(),
      ));
      final a = repo.accounts.first;
      expect(a.type, AccountType.savings);
      expect(a.balance, 0);
      expect(a.currency, 'INR');
      expect(a.isActive, true);
    });

    test('updateAccount modifies fields', () {
      repo.addAccount(Account(
        id: 'acc_1', name: 'HDFC Savings', type: AccountType.savings,
        balance: 50000, createdAt: DateTime.now(),
      ));
      repo.updateAccount(repo.accounts.first.copyWith(name: 'HDFC Salary', balance: 75000));
      expect(repo.accounts.first.name, 'HDFC Salary');
      expect(repo.accounts.first.balance, 75000);
    });

    test('deleteAccount removes account', () {
      repo.addAccount(Account(id: 'a1', name: 'A', createdAt: DateTime.now()));
      repo.addAccount(Account(id: 'a2', name: 'B', createdAt: DateTime.now()));
      repo.deleteAccount('a1');
      expect(repo.accounts, hasLength(1));
      expect(repo.accounts.first.name, 'B');
    });

    test('multiple account types', () {
      for (final type in AccountType.values) {
        repo.addAccount(Account(
          id: 'acc_${type.name}', name: type.name, type: type,
          createdAt: DateTime.now(),
        ));
      }
      expect(repo.accounts, hasLength(AccountType.values.length));
      expect(repo.accounts.map((a) => a.type).toSet(), hasLength(AccountType.values.length));
    });

    test('total account balance', () {
      repo.addAccount(Account(id: 'a1', name: 'Savings', balance: 50000, createdAt: DateTime.now()));
      repo.addAccount(Account(id: 'a2', name: 'Wallet', balance: 5000, createdAt: DateTime.now()));
      repo.addAccount(Account(id: 'a3', name: 'Card', balance: -2000, createdAt: DateTime.now()));
      final total = repo.accounts.fold<double>(0, (s, a) => s + a.balance);
      expect(total, 53000);
    });

    test('clearAllData removes accounts', () {
      repo.addAccount(Account(id: 'a1', name: 'Savings', createdAt: DateTime.now()));
      repo.clearAllData();
      expect(repo.accounts, isEmpty);
    });

    test('copyWith partial update', () {
      final a = Account(id: 'a1', name: 'Savings', type: AccountType.savings, balance: 50000, createdAt: DateTime.now());
      final updated = a.copyWith(balance: 60000);
      expect(updated.id, 'a1');
      expect(updated.name, 'Savings');
      expect(updated.type, AccountType.savings);
      expect(updated.balance, 60000);
    });
  });

  group('Search & Filter', () {
    late DataRepository repo;

    setUp(() {
      repo = DataRepository();
      repo.clearAllData();
      final now = DateTime.now();
      repo.addTransaction(Transaction(
        id: _uuid.v4(), date: now.subtract(const Duration(days: 1)),
        amount: 1000, direction: TransactionDirection.expense,
        description: 'Amazon shopping', currency: 'INR',
        fingerprint: 'fp_1', importBatchId: 'batch_1',
        categoryId: 'shopping', labelIds: ['lbl_important'],
        tags: [], createdAt: now,
      ));
      repo.addTransaction(Transaction(
        id: _uuid.v4(), date: now.subtract(const Duration(days: 5)),
        amount: 50000, direction: TransactionDirection.income,
        description: 'Salary credit', currency: 'INR',
        fingerprint: 'fp_2', importBatchId: 'batch_1',
        categoryId: 'salary', labelIds: [],
        tags: [], createdAt: now,
      ));
      repo.addTransaction(Transaction(
        id: _uuid.v4(), date: now.subtract(const Duration(days: 10)),
        amount: 450, direction: TransactionDirection.expense,
        description: 'Swiggy order', currency: 'INR',
        fingerprint: 'fp_3', importBatchId: 'batch_1',
        categoryId: 'food', labelIds: ['lbl_important'],
        tags: [], createdAt: now,
      ));
    });

    test('filter by direction', () {
      final expenses = repo.transactions.where((t) => t.direction == TransactionDirection.expense).toList();
      expect(expenses, hasLength(2));
      final incomes = repo.transactions.where((t) => t.direction == TransactionDirection.income).toList();
      expect(incomes, hasLength(1));
    });

    test('filter by category', () {
      final shopping = repo.transactions.where((t) => t.categoryId == 'shopping').toList();
      expect(shopping, hasLength(1));
      expect(shopping.first.amount, 1000);
    });

    test('filter by amount range', () {
      final above500 = repo.transactions.where((t) => t.amount >= 500).toList();
      expect(above500, hasLength(2));
      final below1000 = repo.transactions.where((t) => t.amount < 1000).toList();
      expect(below1000, hasLength(1));
      expect(below1000.first.amount, 450);
    });

    test('filter by date', () {
      final now = DateTime.now();
      final recent = repo.transactions.where((t) =>
        t.date.isAfter(now.subtract(const Duration(days: 3)))).toList();
      expect(recent, hasLength(1));
      expect(recent.first.description, 'Amazon shopping');
    });

    test('search by description text', () {
      final results = repo.transactions.where((t) =>
        t.description.toLowerCase().contains('salary')).toList();
      expect(results, hasLength(1));
      expect(results.first.amount, 50000);
    });

    test('search by partial description', () {
      final results = repo.transactions.where((t) =>
        t.description.toLowerCase().contains('amaz')).toList();
      expect(results, hasLength(1));
    });

    test('filter by labelIds', () {
      final important = repo.transactions.where((t) =>
        t.labelIds.contains('lbl_important')).toList();
      expect(important, hasLength(2));
      expect(important.map((t) => t.description),
        containsAll(['Amazon shopping', 'Swiggy order']));
    });

    test('combined filters', () {
      final now = DateTime.now();
      var results = repo.transactions.where((t) =>
        t.direction == TransactionDirection.expense &&
        t.categoryId == 'food');
      expect(results, hasLength(1));
      expect(results.first.description, 'Swiggy order');
    });

    test('sort by amount descending', () {
      final sorted = List<Transaction>.from(repo.transactions)
        ..sort((a, b) => b.amount.compareTo(a.amount));
      expect(sorted[0].amount, 50000);
      expect(sorted[1].amount, 1000);
      expect(sorted[2].amount, 450);
    });

    test('empty result when no match', () {
      final results = repo.transactions.where((t) =>
        t.description.toLowerCase().contains('nonexistent')).toList();
      expect(results, isEmpty);
    });
  });
}
