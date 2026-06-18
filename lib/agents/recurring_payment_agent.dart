import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

import '../core/models/enums.dart';
import '../core/models/recurring_payment.dart';
import '../core/models/transaction.dart';
import 'agent_core/agent_protocol.dart';

const _uuid = Uuid();

class RecurringInput {
  final List<Transaction> transactions;
  final List<RecurringPayment> existingRecurring;

  const RecurringInput({
    required this.transactions,
    required this.existingRecurring,
  });
}

class RecurringOutput {
  final List<RecurringPayment> detectedPayments;

  const RecurringOutput({required this.detectedPayments});
}

class RecurringPaymentAgent
    implements Agent<RecurringInput, RecurringOutput> {
  @override
  String get name => 'RecurringPaymentAgent';

  @override
  String get purpose => 'Detects recurring merchants/payments';

  List<RecurringPayment> detectRecurring(List<Transaction> transactions) {
    final detected = <RecurringPayment>[];

    final debitTxs =
        transactions.where((t) => t.direction == TransactionDirection.debit).toList();

    final merchantGroups = <String, List<Transaction>>{};
    for (final tx in debitTxs) {
      final key = tx.merchantName ?? tx.description;
      merchantGroups.putIfAbsent(key, () => []).add(tx);
    }

    for (final entry in merchantGroups.entries) {
      final txs = entry.value;
      if (txs.length < 2) continue;

      txs.sort((a, b) => a.date.compareTo(b.date));

      final amounts = txs.map((t) => t.amount).toList();
      if (!areAmountsSimilar(amounts)) continue;

      final frequency = checkRegularInterval(txs);
      if (frequency == null) continue;

      final avgAmount = amounts.sum / amounts.length;
      final lastTx = txs.last;

      final alreadyExists = detected.any(
        (p) => p.merchantName == entry.key,
      );
      if (alreadyExists) continue;

      detected.add(RecurringPayment(
        id: _uuid.v4(),
        merchantName: entry.key,
        amount: avgAmount,
        frequency: frequency,
        categoryId: lastTx.categoryId,
        categoryName: lastTx.categoryName,
        lastDetected: lastTx.date,
        occurrences: txs.length,
        averageAmount: avgAmount,
        active: true,
        createdAt: DateTime.now(),
      ));
    }

    return detected;
  }

  PaymentFrequency? checkRegularInterval(List<Transaction> transactions) {
    if (transactions.length < 2) return null;

    final diffs = <int>[];
    for (int i = 1; i < transactions.length; i++) {
      diffs.add(transactions[i].date.difference(transactions[i - 1].date).inDays);
    }

    if (diffs.isEmpty) return null;

    final avgDiff = diffs.sum / diffs.length;

    if (avgDiff >= 27 && avgDiff <= 33) return PaymentFrequency.monthly;
    if (avgDiff >= 13 && avgDiff <= 16) return PaymentFrequency.biweekly;
    if (avgDiff >= 6 && avgDiff <= 8) return PaymentFrequency.weekly;
    if (avgDiff >= 85 && avgDiff <= 98) return PaymentFrequency.quarterly;
    if (avgDiff >= 355 && avgDiff <= 375) return PaymentFrequency.yearly;

    return PaymentFrequency.irregular;
  }

  bool areAmountsSimilar(List<double> amounts, {double threshold = 0.2}) {
    if (amounts.length < 2) return true;

    final mean = amounts.sum / amounts.length;
    if (mean == 0) return false;

    for (final amount in amounts) {
      final deviation = (amount - mean).abs() / mean;
      if (deviation > threshold) return false;
    }

    return true;
  }

  @override
  Future<AgentResult<RecurringOutput>> run(RecurringInput input) async {
    try {
      final existingMerchants =
          input.existingRecurring.map((r) => r.merchantName).toSet();

      final newPayments = detectRecurring(input.transactions);
      final filtered = newPayments
          .where((p) => !existingMerchants.contains(p.merchantName))
          .toList();

      return AgentResult(
        status: AgentTaskStatus.completed,
        output: RecurringOutput(detectedPayments: filtered),
        confidence: filtered.isNotEmpty ? 0.8 : 1.0,
        explanation:
            'Detected ${filtered.length} new recurring payments',
      );
    } catch (e) {
      return AgentResult(
        status: AgentTaskStatus.failed,
        confidence: 0,
        explanation: 'Recurring detection error: $e',
      );
    }
  }
}
