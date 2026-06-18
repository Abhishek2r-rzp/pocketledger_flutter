import 'dart:convert';
import 'package:uuid/uuid.dart';

import '../core/models/transaction.dart';
import 'agent_core/agent_protocol.dart';
import 'statement_parser_agent.dart';

const _uuid = Uuid();

class NormalizerInput {
  final List<ParsedTransactionDraft> drafts;
  final String importBatchId;
  final String currency;

  const NormalizerInput({
    required this.drafts,
    required this.importBatchId,
    required this.currency,
  });
}

class NormalizerOutput {
  final List<Transaction> transactions;

  const NormalizerOutput({required this.transactions});
}

class TransactionNormalizerAgent
    implements Agent<NormalizerInput, NormalizerOutput> {
  @override
  String get name => 'TransactionNormalizerAgent';

  @override
  String get purpose =>
      'Converts parsed rows into normalized Transaction objects';

  String generateFingerprint(
      DateTime date, double amount, String description) {
    final normalized =
        '${date.toIso8601String()}|${amount.toStringAsFixed(2)}|${description.trim().toLowerCase()}';
    final bytes = utf8.encode(normalized);
    return base64Encode(bytes);
  }

  TransactionDirection detectDirection(
      double? debit, double? credit, double? amount) {
    if (debit != null && debit > 0) return TransactionDirection.debit;
    if (credit != null && credit > 0) return TransactionDirection.credit;
    if (amount != null) {
      if (amount < 0) return TransactionDirection.credit;
      return TransactionDirection.debit;
    }
    return TransactionDirection.debit;
  }

  @override
  Future<AgentResult<NormalizerOutput>> run(NormalizerInput input) async {
    try {
      if (input.drafts.isEmpty) {
        return AgentResult(
          status: AgentTaskStatus.completed,
          output: const NormalizerOutput(transactions: []),
          confidence: 1.0,
          explanation: 'No drafts to normalize',
        );
      }

      final transactions = <Transaction>[];
      int failedCount = 0;

      for (final draft in input.drafts) {
        try {
          if (draft.parsedDate == null || draft.parsedAmount == null) {
            failedCount++;
            continue;
          }

          final direction = draft.parsedDirection ??
              detectDirection(null, null, draft.parsedAmount);
          final absAmount = draft.parsedAmount!.abs();
          final fingerprint = generateFingerprint(
              draft.parsedDate!, absAmount, draft.rawDescription);

          final transaction = Transaction(
            id: _uuid.v4(),
            date: draft.parsedDate!,
            amount: absAmount,
            direction: direction,
            description: draft.rawDescription,
            merchantName: null,
            categoryId: null,
            categoryName: null,
            balance: draft.parsedBalance,
            currency: input.currency,
            fingerprint: fingerprint,
            importBatchId: input.importBatchId,
            createdAt: DateTime.now(),
          );

          transactions.add(transaction);
        } catch (_) {
          failedCount++;
        }
      }

      final confidence =
          input.drafts.isEmpty ? 1.0 : (transactions.length / input.drafts.length);

      return AgentResult(
        status: failedCount > 0 && transactions.isEmpty
            ? AgentTaskStatus.failed
            : AgentTaskStatus.completed,
        output: NormalizerOutput(transactions: transactions),
        confidence: confidence,
        explanation:
            'Normalized ${transactions.length} of ${input.drafts.length} drafts ($failedCount failed)',
      );
    } catch (e) {
      return AgentResult(
        status: AgentTaskStatus.failed,
        confidence: 0,
        explanation: 'Normalization error: $e',
      );
    }
  }
}
