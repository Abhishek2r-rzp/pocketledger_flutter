import 'dart:math';

enum TransactionDirection { income, expense, transfer, refund, unknown }

enum CategoryType { income, expense, transfer, system }

enum ImportBatchStatus { pending, parsing, completed, failed, cancelled }

enum MatchType { contains, regex, exact, merchant }

enum PaymentFrequency { weekly, monthly, quarterly, yearly, unknown }

enum RecurringStatus { detected, confirmed, rejected }

class Transaction {
  final String id;
  final String importBatchId;
  final String? accountId;
  final DateTime transactionDate;
  final DateTime? postedDate;
  final String rawDescription;
  final String? merchantName;
  final double amount;
  final TransactionDirection direction;
  final String currency;
  final double? balanceAfter;
  final String? categoryId;
  final String? categoryName;
  final double categorizationConfidence;
  final String? categorizationExplanation;
  final List<String> tags;
  final String? notes;
  final String fingerprint;
  final bool isDuplicate;
  final bool needsReview;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Transaction({
    required this.id,
    required this.importBatchId,
    this.accountId,
    required this.transactionDate,
    this.postedDate,
    required this.rawDescription,
    this.merchantName,
    required this.amount,
    required this.direction,
    this.currency = 'INR',
    this.balanceAfter,
    this.categoryId,
    this.categoryName,
    this.categorizationConfidence = 0.0,
    this.categorizationExplanation,
    this.tags = const [],
    this.notes,
    required this.fingerprint,
    this.isDuplicate = false,
    this.needsReview = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Transaction copyWith({
    String? id,
    String? importBatchId,
    String? accountId,
    DateTime? transactionDate,
    DateTime? postedDate,
    String? rawDescription,
    String? merchantName,
    double? amount,
    TransactionDirection? direction,
    String? currency,
    double? balanceAfter,
    String? categoryId,
    String? categoryName,
    double? categorizationConfidence,
    String? categorizationExplanation,
    List<String>? tags,
    String? notes,
    String? fingerprint,
    bool? isDuplicate,
    bool? needsReview,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      importBatchId: importBatchId ?? this.importBatchId,
      accountId: accountId ?? this.accountId,
      transactionDate: transactionDate ?? this.transactionDate,
      postedDate: postedDate ?? this.postedDate,
      rawDescription: rawDescription ?? this.rawDescription,
      merchantName: merchantName ?? this.merchantName,
      amount: amount ?? this.amount,
      direction: direction ?? this.direction,
      currency: currency ?? this.currency,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categorizationConfidence:
          categorizationConfidence ?? this.categorizationConfidence,
      categorizationExplanation:
          categorizationExplanation ?? this.categorizationExplanation,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      fingerprint: fingerprint ?? this.fingerprint,
      isDuplicate: isDuplicate ?? this.isDuplicate,
      needsReview: needsReview ?? this.needsReview,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Category {
  final String id;
  final String name;
  final String? parentCategoryId;
  final String icon;
  final CategoryType type;
  final bool isSystem;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Category({
    required this.id,
    required this.name,
    this.parentCategoryId,
    this.icon = 'help_outline',
    this.type = CategoryType.expense,
    this.isSystem = false,
    required this.createdAt,
    required this.updatedAt,
  });
}

class ImportBatch {
  final String id;
  final String fileName;
  final String fileType;
  final DateTime importedAt;
  final String parserVersion;
  final ImportBatchStatus status;
  final int totalRows;
  final int importedCount;
  final int duplicateCount;
  final int failedCount;
  final int reviewCount;

  const ImportBatch({
    required this.id,
    required this.fileName,
    this.fileType = 'csv',
    required this.importedAt,
    this.parserVersion = '1.0.0',
    this.status = ImportBatchStatus.completed,
    this.totalRows = 0,
    this.importedCount = 0,
    this.duplicateCount = 0,
    this.failedCount = 0,
    this.reviewCount = 0,
  });
}

class Budget {
  final String id;
  final String categoryId;
  final String categoryName;
  final double limit;
  final String period;
  final double spent;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Budget({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.limit,
    this.period = 'monthly',
    this.spent = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });

  double get percentage => limit > 0 ? (spent / limit) * 100 : 0;
  bool get isWarning => percentage >= 80 && percentage < 100;
  bool get isExceeded => percentage >= 100;
}

class RecurringPayment {
  final String id;
  final String merchantName;
  final double amount;
  final double amountVariance;
  final PaymentFrequency frequency;
  final RecurringStatus status;
  final List<String> transactionIds;
  final DateTime firstDetected;
  final DateTime lastOccurrence;
  final double confidence;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RecurringPayment({
    required this.id,
    required this.merchantName,
    required this.amount,
    this.amountVariance = 0.0,
    this.frequency = PaymentFrequency.monthly,
    this.status = RecurringStatus.detected,
    this.transactionIds = const [],
    required this.firstDetected,
    required this.lastOccurrence,
    this.confidence = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });
}

class UserRule {
  final String id;
  final String merchantPattern;
  final String categoryName;
  final String? subcategoryName;
  final MatchType matchType;
  final bool createdByUser;
  final int priority;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserRule({
    required this.id,
    required this.merchantPattern,
    required this.categoryName,
    this.subcategoryName,
    this.matchType = MatchType.contains,
    this.createdByUser = true,
    this.priority = 0,
    required this.createdAt,
    required this.updatedAt,
  });
}

Transaction createTestTransaction({
  String? id,
  String? importBatchId,
  String? accountId,
  DateTime? transactionDate,
  String rawDescription = 'UPI-SWIGGY-ORDER-1234',
  String? merchantName,
  double amount = 450.0,
  TransactionDirection direction = TransactionDirection.expense,
  String currency = 'INR',
  double? balanceAfter,
  String? categoryId,
  String? categoryName,
  double categorizationConfidence = 0.0,
  String? categorizationExplanation,
  List<String> tags = const [],
  String? notes,
  String? fingerprint,
  bool isDuplicate = false,
  bool needsReview = false,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return Transaction(
    id: id ?? 'txn_${now.millisecondsSinceEpoch}_${Random().nextInt(9999)}',
    importBatchId: importBatchId ?? 'batch_test_001',
    accountId: accountId,
    transactionDate: transactionDate ?? DateTime(2025, 3, 1),
    rawDescription: rawDescription,
    merchantName: merchantName,
    amount: amount,
    direction: direction,
    currency: currency,
    balanceAfter: balanceAfter,
    categoryId: categoryId,
    categoryName: categoryName,
    categorizationConfidence: categorizationConfidence,
    categorizationExplanation: categorizationExplanation,
    tags: tags,
    notes: notes,
    fingerprint:
        fingerprint ?? 'fp_${rawDescription.hashCode}_${amount}_${now.millisecondsSinceEpoch}',
    isDuplicate: isDuplicate,
    needsReview: needsReview,
    createdAt: createdAt ?? now,
    updatedAt: updatedAt ?? now,
  );
}

Category createTestCategory({
  String? id,
  String name = 'Test Category',
  String? parentCategoryId,
  String icon = 'help_outline',
  CategoryType type = CategoryType.expense,
  bool isSystem = false,
}) {
  final now = DateTime.now();
  return Category(
    id: id ?? 'cat_${name.toLowerCase().replaceAll(' ', '_')}',
    name: name,
    parentCategoryId: parentCategoryId,
    icon: icon,
    type: type,
    isSystem: isSystem,
    createdAt: now,
    updatedAt: now,
  );
}

ImportBatch createTestImportBatch({
  String? id,
  String fileName = 'test_export.csv',
  String fileType = 'csv',
  DateTime? importedAt,
  String parserVersion = '1.0.0',
  ImportBatchStatus status = ImportBatchStatus.completed,
  int totalRows = 0,
  int importedCount = 0,
  int duplicateCount = 0,
  int failedCount = 0,
  int reviewCount = 0,
}) {
  return ImportBatch(
    id: id ?? 'batch_${DateTime.now().millisecondsSinceEpoch}',
    fileName: fileName,
    fileType: fileType,
    importedAt: importedAt ?? DateTime.now(),
    parserVersion: parserVersion,
    status: status,
    totalRows: totalRows,
    importedCount: importedCount,
    duplicateCount: duplicateCount,
    failedCount: failedCount,
    reviewCount: reviewCount,
  );
}

Budget createTestBudget({
  String? id,
  String? categoryId,
  String categoryName = 'Food & Dining',
  double limit = 10000.0,
  String period = 'monthly',
  double spent = 0.0,
}) {
  final now = DateTime.now();
  return Budget(
    id: id ?? 'budget_${now.millisecondsSinceEpoch}',
    categoryId: categoryId ?? 'cat_food',
    categoryName: categoryName,
    limit: limit,
    period: period,
    spent: spent,
    createdAt: now,
    updatedAt: now,
  );
}

RecurringPayment createTestRecurringPayment({
  String? id,
  String merchantName = 'Netflix',
  double amount = 649.0,
  double amountVariance = 0.0,
  PaymentFrequency frequency = PaymentFrequency.monthly,
  RecurringStatus status = RecurringStatus.detected,
  List<String> transactionIds = const [],
  DateTime? firstDetected,
  DateTime? lastOccurrence,
  double confidence = 0.85,
}) {
  final now = DateTime.now();
  return RecurringPayment(
    id: id ?? 'recur_${now.millisecondsSinceEpoch}',
    merchantName: merchantName,
    amount: amount,
    amountVariance: amountVariance,
    frequency: frequency,
    status: status,
    transactionIds: transactionIds,
    firstDetected: firstDetected ?? now.subtract(const Duration(days: 90)),
    lastOccurrence: lastOccurrence ?? now,
    confidence: confidence,
    createdAt: now,
    updatedAt: now,
  );
}

const String sampleCSV = '''Date,Narration,Withdrawal Amt.,Deposit Amt.,Closing Balance
01/03/25,UPI-SWIGGY-TEST,450.00,,124550.00
02/03/25,SALARY CREDIT,,50000.00,174550.00
03/03/25,AMAZON PAY,1299.00,,173251.00
04/03/25,NEFT-UTILITY-PAYMENT,2500.00,,170751.00
05/03/25,UPI-UBER-INDIA,320.00,,170431.00
06/03/25,ZOMATO LIMITED,567.00,,169864.00
07/03/25,ATM CASH WITHDRAWAL,10000.00,,159864.00
08/03/25,NETFLIX SUBSCRIPTION,649.00,,159215.00
09/03/25,UPI-ZOMATO-ORDER,789.00,,158426.00
10/03/25,RENT PAYMENT,25000.00,,133426.00''';

const String sampleCSVWithBom = '\uFEFF$sampleCSV';

const String sampleCSVQuotedFields = '''Date,Narration,Withdrawal Amt.,Deposit Amt.,Closing Balance
01/03/25,"UPI-SWIGGY,TEST",450.00,,124550.00
02/03/25,"SALARY, CREDIT",,50000.00,174550.00''';

const String sampleCSVEmptyFile = '''Date,Narration,Withdrawal Amt.,Deposit Amt.,Closing Balance
''';
