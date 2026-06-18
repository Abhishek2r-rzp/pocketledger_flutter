import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';
import '../../core/models/agent_action_log.dart';
import '../../core/models/budget.dart';
import '../../core/models/category.dart';
import '../../core/models/enums.dart';
import '../../core/models/import_batch.dart';
import '../../core/models/insight.dart';
import '../../core/models/recurring_payment.dart';
import '../../core/models/review_item.dart';
import '../../core/models/transaction.dart';
import '../budget_agent.dart';
import '../categorization_agent.dart';
import '../deduplication_agent.dart';
import '../file_import_agent.dart';
import '../insight_agent.dart';
import '../learning_agent.dart';
import '../merchant_cleaner_agent.dart';
import '../privacy_guard_agent.dart';
import '../recurring_payment_agent.dart';
import '../review_queue_agent.dart';
import '../statement_parser_agent.dart';
import '../transaction_normalizer_agent.dart';
import 'agent_protocol.dart';

const _uuid = Uuid();

class ImportResult {
  final String importBatchId;
  final int totalParsed;
  final int imported;
  final int duplicates;
  final int needsReview;
  final int failed;
  final List<String> transactionIds;

  const ImportResult({
    required this.importBatchId,
    required this.totalParsed,
    required this.imported,
    required this.duplicates,
    required this.needsReview,
    required this.failed,
    required this.transactionIds,
  });
}

class AgentOrchestrator {
  static final AgentOrchestrator _instance = AgentOrchestrator._();
  factory AgentOrchestrator() => _instance;
  AgentOrchestrator._();

  final fileImportAgent = FileImportAgent();
  final statementParserAgent = StatementParserAgent();
  final transactionNormalizerAgent = TransactionNormalizerAgent();
  final deduplicationAgent = DeduplicationAgent();
  final merchantCleanerAgent = MerchantCleanerAgent();
  final categorizationAgent = CategorizationAgent();
  final reviewQueueAgent = ReviewQueueAgent();
  final learningAgent = LearningAgent();
  final budgetAgent = BudgetAgent();
  final recurringPaymentAgent = RecurringPaymentAgent();
  final insightAgent = InsightAgent();
  final privacyGuardAgent = PrivacyGuardAgent();

  Future<AgentResult<ImportResult>> executeImportPipeline(
    String filePath,
    AgentDatabase database,
  ) async {
    final logs = <AgentActionLog>[];

    final batchId = _uuid.v4();
    final now = DateTime.now();

    try {
      final fileResult = await fileImportAgent.run(
        FileImportInput(filePath: filePath, fileName: filePath.split('/').last),
      );
      logs.addAll(fileResult.auditLogs);
      if (fileResult.status == AgentTaskStatus.failed) {
        return AgentResult(
          status: AgentTaskStatus.failed,
          confidence: 0,
          explanation: fileResult.explanation ?? 'File import failed',
          auditLogs: logs,
        );
      }

      final importBatch = fileResult.output!.importBatch;
      final localPath = fileResult.output!.localCopyPath;
      final fileType = importBatch.fileType;

      await database.insertBatch(
        ImportBatch(
          id: importBatch.id,
          fileName: importBatch.fileName,
          fileType: fileType,
          filePath: localPath,
          totalRows: 0,
          importedRows: 0,
          duplicateRows: 0,
          failedRows: 0,
          createdAt: now,
        ),
      );

      final parseResult = await statementParserAgent.run(
        StatementParserInput(
          filePath: localPath,
          fileType: fileType,
          importBatchId: importBatch.id,
          currency: 'INR',
        ),
      );
      logs.addAll(parseResult.auditLogs);
      if (parseResult.status == AgentTaskStatus.failed) {
        return AgentResult(
          status: AgentTaskStatus.failed,
          confidence: 0,
          explanation: parseResult.explanation ?? 'Parsing failed',
          auditLogs: logs,
        );
      }

      final drafts = parseResult.output!.parsedDrafts;
      final totalParsed = drafts.length;

      if (totalParsed == 0) {
        return AgentResult(
          status: AgentTaskStatus.completed,
          output: ImportResult(
            importBatchId: batchId,
            totalParsed: 0,
            imported: 0,
            duplicates: 0,
            needsReview: 0,
            failed: 0,
            transactionIds: [],
          ),
          confidence: 1.0,
          explanation: 'No transactions found in file',
          auditLogs: logs,
        );
      }

      final normalizeResult = await transactionNormalizerAgent.run(
        NormalizerInput(
          drafts: drafts,
          importBatchId: importBatch.id,
          currency: 'INR',
        ),
      );
      logs.addAll(normalizeResult.auditLogs);
      if (normalizeResult.status == AgentTaskStatus.failed) {
        return AgentResult(
          status: AgentTaskStatus.failed,
          confidence: 0,
          explanation: normalizeResult.explanation ?? 'Normalization failed',
          auditLogs: logs,
        );
      }

      var transactions = normalizeResult.output!.transactions;

      final existing = await database.getExistingTransactions();

      final dedupResult = await deduplicationAgent.run(
        DedupInput(transactions: transactions, existingTransactions: existing),
      );
      logs.addAll(dedupResult.auditLogs);

      transactions = dedupResult.output!.uniqueTransactions;
      final exactDuplicates = dedupResult.output!.exactDuplicates;
      final possibleDuplicates = dedupResult.output!.possibleDuplicates;

      if (transactions.isEmpty) {
        await database.updateBatch(importBatch.id,
            importedRows: 0,
            duplicateRows: exactDuplicates.length,
            failedRows: 0);
        return AgentResult(
          status: AgentTaskStatus.completed,
          output: ImportResult(
            importBatchId: batchId,
            totalParsed: totalParsed,
            imported: 0,
            duplicates: exactDuplicates.length + possibleDuplicates.length,
            needsReview: 0,
            failed: 0,
            transactionIds: [],
          ),
          confidence: 1.0,
          explanation: 'All transactions were duplicates',
          auditLogs: logs,
        );
      }

      final merchantResult = await merchantCleanerAgent.run(
        MerchantInput(transactions: transactions),
      );
      logs.addAll(merchantResult.auditLogs);
      transactions = merchantResult.output!.cleanedTransactions;

      final categories = await database.getAllCategories();
      final userRules = await database.getAllRules();

      final categorizeResult = await categorizationAgent.run(
        CategorizationInput(
          transactions: transactions,
          userRules: userRules,
          categories: categories,
        ),
      );
      logs.addAll(categorizeResult.auditLogs);
      transactions = categorizeResult.output!.categorizedTransactions;

      final lowConfidenceItems = transactions
          .where((t) => t.categoryId == null)
          .map((t) {
            return ReviewItem(
              id: _uuid.v4(),
              transactionId: t.id,
              reason: ReviewReason.lowConfidence,
              confidence: 0.0,
              explanation: 'No matching category found for "${t.description}"',
              createdAt: now,
            );
          })
          .toList();

      final possibleDupItems = possibleDuplicates.map((t) {
        return ReviewItem(
          id: _uuid.v4(),
          transactionId: t.id,
          reason: ReviewReason.possibleDuplicate,
          confidence: 0.5,
          explanation:
              'Possible duplicate of an existing transaction (amount: ${t.amount}, description: "${t.description}")',
          createdAt: now,
        );
      }).toList();

      final allReviewItems = [...lowConfidenceItems, ...possibleDupItems];

      await database.insertTransactions(transactions);

      if (allReviewItems.isNotEmpty) {
        await database.insertReviewItems(allReviewItems);
      }

      await database.updateBatch(
        importBatch.id,
        importedRows: transactions.length,
        duplicateRows: exactDuplicates.length + possibleDuplicates.length,
        failedRows: 0,
      );

      final transactionIds = transactions.map((t) => t.id).toList();

      return AgentResult(
        status: allReviewItems.isNotEmpty
            ? AgentTaskStatus.needsUserReview
            : AgentTaskStatus.completed,
        output: ImportResult(
          importBatchId: importBatch.id,
          totalParsed: totalParsed,
          imported: transactions.length,
          duplicates: exactDuplicates.length + possibleDuplicates.length,
          needsReview: allReviewItems.length,
          failed: 0,
          transactionIds: transactionIds,
        ),
        confidence: parseResult.output!.parserConfidence,
        explanation:
            'Imported ${transactions.length} of $totalParsed transactions',
        auditLogs: logs,
        needsReview: allReviewItems.isNotEmpty,
      );
    } catch (e) {
      return AgentResult(
        status: AgentTaskStatus.failed,
        confidence: 0,
        explanation: 'Import pipeline error: $e',
        auditLogs: logs,
      );
    }
  }

  Future<AgentResult<int>> executeCategorizationPipeline(
      AgentDatabase database) async {
    final logs = <AgentActionLog>[];

    try {
      final uncategorized = await database.getUncategorizedTransactions();
      if (uncategorized.isEmpty) {
        return AgentResult(
          status: AgentTaskStatus.completed,
          output: 0,
          confidence: 1.0,
          explanation: 'No uncategorized transactions found',
          auditLogs: logs,
        );
      }

      final categories = await database.getAllCategories();
      final userRules = await database.getAllRules();

      final categorizeResult = await categorizationAgent.run(
        CategorizationInput(
          transactions: uncategorized,
          userRules: userRules,
          categories: categories,
        ),
      );
      logs.addAll(categorizeResult.auditLogs);

      final categorized = categorizeResult.output!.categorizedTransactions;

      int updatedCount = 0;
      for (final tx in categorized) {
        if (tx.categoryId != null) {
          await database.updateTransaction(
            id: tx.id,
            categoryId: tx.categoryId,
            categoryName: tx.categoryName,
          );
          updatedCount++;
        }
      }

      await logAction(
        agentName: 'AgentOrchestrator',
        actionType: 'categorize_pipeline',
        inputSummary: '${uncategorized.length} uncategorized transactions',
        outputSummary: 'Categorized $updatedCount transactions',
        confidence: categorizeResult.confidence,
        database: database,
      );

      return AgentResult(
        status: AgentTaskStatus.completed,
        output: updatedCount,
        confidence: categorizeResult.confidence,
        explanation: 'Categorized $updatedCount of ${uncategorized.length} transactions',
        auditLogs: logs,
      );
    } catch (e) {
      return AgentResult(
        status: AgentTaskStatus.failed,
        confidence: 0,
        explanation: 'Categorization pipeline error: $e',
        auditLogs: logs,
      );
    }
  }

  Future<AgentResult<List<RecurringPayment>>>
      executeRecurringDetectionPipeline(AgentDatabase database) async {
    final logs = <AgentActionLog>[];

    try {
      final transactions = await database.getAllTransactions();
      final existingRecurring = await database.getActiveRecurring();

      if (transactions.isEmpty) {
        return AgentResult(
          status: AgentTaskStatus.completed,
          output: [],
          confidence: 1.0,
          explanation: 'No transactions to analyze',
          auditLogs: logs,
        );
      }

      final result = await recurringPaymentAgent.run(
        RecurringInput(
          transactions: transactions,
          existingRecurring: existingRecurring,
        ),
      );
      logs.addAll(result.auditLogs);

      final detected = result.output!.detectedPayments;
      for (final payment in detected) {
        await database.insertRecurring(payment);
      }

      return AgentResult(
        status: AgentTaskStatus.completed,
        output: detected,
        confidence: result.confidence,
        explanation: 'Detected ${detected.length} recurring payments',
        auditLogs: logs,
      );
    } catch (e) {
      return AgentResult(
        status: AgentTaskStatus.failed,
        confidence: 0,
        explanation: 'Recurring detection pipeline error: $e',
        auditLogs: logs,
      );
    }
  }

  Future<AgentResult<List<Insight>>> executeInsightsPipeline(
      AgentDatabase database) async {
    final logs = <AgentActionLog>[];

    try {
      final transactions = await database.getAllTransactions();
      final budgets = await database.getBudgets();
      final recurring = await database.getActiveRecurring();
      final categories = await database.getAllCategories();

      final insights = await insightAgent.generateInsights(
        transactions: transactions,
        budgets: budgets,
        recurring: recurring,
        categories: categories,
      );

      return AgentResult(
        status: AgentTaskStatus.completed,
        output: insights,
        confidence: 0.9,
        explanation: 'Generated ${insights.length} insights',
        auditLogs: logs,
      );
    } catch (e) {
      return AgentResult(
        status: AgentTaskStatus.failed,
        confidence: 0,
        explanation: 'Insights pipeline error: $e',
        auditLogs: logs,
      );
    }
  }

  Future<void> processUserCorrection(
    String transactionId,
    String newCategoryId,
    String? newMerchantName,
    AgentDatabase database,
  ) async {
    final transactions = await database.getAllTransactions();
    final tx = transactions.where((t) => t.id == transactionId).firstOrNull;
    if (tx == null) return;

    final categories = await database.getAllCategories();
    final newCategory = categories.where((c) => c.id == newCategoryId).firstOrNull;

    await database.updateTransaction(
      id: transactionId,
      categoryId: newCategoryId,
      categoryName: newCategory?.name,
      merchantName: newMerchantName ?? tx.merchantName,
    );

    await learningAgent.processCorrection(
      transaction: tx,
      originalCategoryId: tx.categoryId,
      newCategoryId: newCategoryId,
      originalMerchant: tx.merchantName,
      newMerchant: newMerchantName,
      database: database,
    );

    final reviewItems = await database.getReviewItems();
    for (final item in reviewItems) {
      if (item.transactionId == transactionId) {
        await database.deleteReviewItem(item.id);
      }
    }

    await logAction(
      agentName: 'AgentOrchestrator',
      actionType: 'user_correction',
      inputSummary: 'Transaction $transactionId',
      outputSummary: 'Assigned category $newCategoryId, merchant: $newMerchantName',
      confidence: 1.0,
      explanation: 'User correction applied',
      database: database,
    );
  }

  Future<void> logAction({
    required String agentName,
    required String actionType,
    String? inputSummary,
    String? outputSummary,
    required double confidence,
    String? explanation,
    String? transactionId,
    String? batchId,
    required AgentDatabase database,
  }) async {
    final log = AgentActionLog(
      id: _uuid.v4(),
      agentName: agentName,
      actionType: actionType,
      inputSummary: inputSummary,
      outputSummary: outputSummary,
      confidence: confidence,
      explanation: explanation,
      transactionId: transactionId,
      batchId: batchId,
      createdAt: DateTime.now(),
    );
    await database.insertActionLog(log);
  }
}
