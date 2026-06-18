import 'package:flutter_test/flutter_test.dart';
import '../test_helpers.dart';

class DedupConfig {
  final double amountThreshold;
  final int dateThresholdDays;
  final bool requirePartialDescription;

  const DedupConfig({
    this.amountThreshold = 1.0,
    this.dateThresholdDays = 3,
    this.requirePartialDescription = true,
  });
}

String buildFingerprint(Transaction t) {
  final merchant = (t.merchantName ?? t.rawDescription).toUpperCase().trim();
  final amt = t.amount.toStringAsFixed(2);
  final date = '${t.transactionDate.year}${_pad(t.transactionDate.month)}${_pad(t.transactionDate.day)}';
  return '$merchant|$amt|$date|${t.direction.name}';
}

String _pad(int n) => n.toString().padLeft(2, '0');

bool isDuplicate(Transaction a, Transaction b, {DedupConfig? config}) {
  final cfg = config ?? const DedupConfig();

  if (a.fingerprint == b.fingerprint) return true;

  final amountDiff = (a.amount - b.amount).abs();
  if (amountDiff > cfg.amountThreshold) return false;

  final dateDiff = a.transactionDate.difference(b.transactionDate).abs();
  if (dateDiff.inDays > cfg.dateThresholdDays) return false;

  if (a.direction != b.direction) return false;

  if (cfg.requirePartialDescription) {
    final descA = a.rawDescription.toUpperCase();
    final descB = b.rawDescription.toUpperCase();
    final wordsA = descA.split(RegExp(r'[\s-]+'));
    final wordsB = descB.split(RegExp(r'[\s-]+'));
    final common = wordsA.where((w) => wordsB.contains(w)).length;
    if (common < 1) return false;
  }

  return true;
}

List<Transaction> findDuplicates(List<Transaction> transactions, {DedupConfig? config}) {
  final duplicates = <Transaction>[];
  for (int i = 0; i < transactions.length; i++) {
    for (int j = i + 1; j < transactions.length; j++) {
      if (isDuplicate(transactions[i], transactions[j], config: config)) {
        duplicates.add(transactions[j]);
      }
    }
  }
  return duplicates;
}

void main() {
  late DateTime baseDate;
  late Transaction txn1;
  late Transaction txn2;

  setUp(() {
    baseDate = DateTime(2025, 3, 15);
  });

  group('Deduplication - fingerprint match', () {
    test('exact fingerprint returns true', () {
      txn1 = createTestTransaction(
        rawDescription: 'UPI-SWIGGY-ORDER-1234',
        merchantName: 'Swiggy',
        amount: 450.0,
        transactionDate: baseDate,
        fingerprint: 'swiggy|450.00|20250315|expense',
      );
      txn2 = createTestTransaction(
        rawDescription: 'UPI-SWIGGY-ORDER-1234',
        merchantName: 'Swiggy',
        amount: 450.0,
        transactionDate: baseDate,
        fingerprint: 'swiggy|450.00|20250315|expense',
      );

      expect(isDuplicate(txn1, txn2), isTrue);
      expect(buildFingerprint(txn1), buildFingerprint(txn2));
    });

    test('same transaction with same id returns true', () {
      txn1 = createTestTransaction(
        id: 'txn_001',
        rawDescription: 'UPI-SWIGGY-ORDER-1234',
        amount: 450.0,
        transactionDate: baseDate,
        fingerprint: 'fp_swiggy_450',
      );

      expect(isDuplicate(txn1, txn1), isTrue);
    });
  });

  group('Deduplication - similar amount and close date', () {
    test('same merchant, amount within threshold, date within 3 days = duplicate', () {
      txn1 = createTestTransaction(
        rawDescription: 'UPI-SWIGGY-ORDER-1234',
        merchantName: 'Swiggy',
        amount: 450.0,
        transactionDate: baseDate,
        fingerprint: 'fp1',
      );
      txn2 = createTestTransaction(
        rawDescription: 'UPI-SWIGGY-ORDER-5678',
        merchantName: 'Swiggy',
        amount: 450.50,
        transactionDate: baseDate.add(const Duration(days: 2)),
        fingerprint: 'fp2',
      );

      expect(isDuplicate(txn1, txn2), isTrue);
    });

    test('exact amount threshold boundary (1.0) passes', () {
      txn1 = createTestTransaction(
        rawDescription: 'AMAZON PAY',
        amount: 1299.0,
        transactionDate: baseDate,
        fingerprint: 'fp1',
      );
      txn2 = createTestTransaction(
        rawDescription: 'AMAZON PAY',
        amount: 1300.0,
        transactionDate: baseDate,
        fingerprint: 'fp2',
      );

      expect(isDuplicate(txn1, txn2), isTrue);
    });

    test('date threshold boundary (3 days) passes', () {
      txn1 = createTestTransaction(
        merchantName: 'Swiggy',
        amount: 450.0,
        transactionDate: baseDate,
        fingerprint: 'fp1',
      );
      txn2 = createTestTransaction(
        merchantName: 'Swiggy',
        amount: 450.50,
        transactionDate: baseDate.add(const Duration(days: 3)),
        fingerprint: 'fp2',
      );

      expect(isDuplicate(txn1, txn2), isTrue);
    });
  });

  group('Deduplication - different amounts are not duplicates', () {
    test('amount exceeds threshold returns false', () {
      txn1 = createTestTransaction(
        rawDescription: 'UPI-SWIGGY-ORDER-1234',
        amount: 450.0,
        transactionDate: baseDate,
        fingerprint: 'fp1',
      );
      txn2 = createTestTransaction(
        rawDescription: 'UPI-SWIGGY-ORDER-5678',
        amount: 500.0,
        transactionDate: baseDate,
        fingerprint: 'fp2',
      );

      expect(isDuplicate(txn1, txn2), isFalse);
    });

    test('amount difference of 2.0 fails when threshold is 1.0', () {
      txn1 = createTestTransaction(
        merchantName: 'Amazon',
        amount: 1299.0,
        transactionDate: baseDate,
        fingerprint: 'fp1',
      );
      txn2 = createTestTransaction(
        merchantName: 'Amazon',
        amount: 1301.0,
        transactionDate: baseDate,
        fingerprint: 'fp2',
      );

      expect(isDuplicate(txn1, txn2), isFalse);
    });
  });

  group('Deduplication - different dates are not duplicates', () {
    test('date diff > 3 days returns false', () {
      txn1 = createTestTransaction(
        merchantName: 'Netflix',
        amount: 649.0,
        transactionDate: baseDate,
        fingerprint: 'fp1',
      );
      txn2 = createTestTransaction(
        merchantName: 'Netflix',
        amount: 649.0,
        transactionDate: baseDate.add(const Duration(days: 10)),
        fingerprint: 'fp2',
      );

      expect(isDuplicate(txn1, txn2), isFalse);
    });

    test('date diff of 4 days fails', () {
      txn1 = createTestTransaction(
        merchantName: 'Zomato',
        amount: 567.0,
        transactionDate: baseDate,
        fingerprint: 'fp1',
      );
      txn2 = createTestTransaction(
        merchantName: 'Zomato',
        amount: 567.0,
        transactionDate: baseDate.add(const Duration(days: 4)),
        fingerprint: 'fp2',
      );

      expect(isDuplicate(txn1, txn2), isFalse);
    });
  });

  group('Deduplication - partial description match', () {
    test('same merchant keyword is sufficient for match', () {
      txn1 = createTestTransaction(
        rawDescription: 'UPI-SWIGGY-ORDER-1234',
        amount: 450.0,
        transactionDate: baseDate,
        fingerprint: 'fp1',
      );
      txn2 = createTestTransaction(
        rawDescription: 'POS SWIGGY RESTAURANT',
        amount: 450.50,
        transactionDate: baseDate.add(const Duration(days: 1)),
        fingerprint: 'fp2',
      );

      expect(isDuplicate(txn1, txn2), isTrue);
    });

    test('no common words returns false', () {
      txn1 = createTestTransaction(
        rawDescription: 'UPI-SWIGGY-ORDER',
        amount: 450.0,
        transactionDate: baseDate,
        fingerprint: 'fp1',
      );
      txn2 = createTestTransaction(
        rawDescription: 'NEFT-UTILITY-PAYMENT',
        amount: 450.50,
        transactionDate: baseDate.add(const Duration(days: 1)),
        fingerprint: 'fp2',
      );

      expect(isDuplicate(txn1, txn2), isFalse);
    });

    test('partial description match disabled returns true', () {
      txn1 = createTestTransaction(
        rawDescription: 'UPI-SWIGGY-ORDER-1234',
        amount: 450.0,
        transactionDate: baseDate,
        fingerprint: 'fp1',
      );
      txn2 = createTestTransaction(
        rawDescription: 'NEFT-UTILITY-PAYMENT',
        amount: 450.50,
        transactionDate: baseDate.add(const Duration(days: 1)),
        fingerprint: 'fp2',
      );

      expect(
        isDuplicate(txn1, txn2, config: const DedupConfig(requirePartialDescription: false)),
        isTrue,
      );
    });
  });

  group('Deduplication - no false positives', () {
    test('different merchants and amounts are not duplicates', () {
      txn1 = createTestTransaction(
        merchantName: 'Swiggy',
        amount: 450.0,
        transactionDate: baseDate,
        fingerprint: 'fp_swiggy',
      );
      txn2 = createTestTransaction(
        merchantName: 'Amazon',
        amount: 1299.0,
        transactionDate: baseDate,
        fingerprint: 'fp_amazon',
      );

      expect(isDuplicate(txn1, txn2), isFalse);
    });

    test('different directions are not duplicates', () {
      txn1 = createTestTransaction(
        merchantName: 'Refund',
        amount: 500.0,
        direction: TransactionDirection.income,
        transactionDate: baseDate,
        fingerprint: 'fp_income',
      );
      txn2 = createTestTransaction(
        merchantName: 'Payment',
        amount: 500.0,
        direction: TransactionDirection.expense,
        transactionDate: baseDate,
        fingerprint: 'fp_expense',
      );

      expect(isDuplicate(txn1, txn2), isFalse);
    });

    test('same amount completely different merchants no match', () {
      txn1 = createTestTransaction(
        rawDescription: 'UPI-SWIGGY-ORDER',
        merchantName: 'Swiggy',
        amount: 500.0,
        transactionDate: baseDate,
        fingerprint: 'fp_swiggy',
      );
      txn2 = createTestTransaction(
        rawDescription: 'NEFT-ELECTRICITY-BILL',
        merchantName: 'Electricity Board',
        amount: 500.0,
        transactionDate: baseDate,
        fingerprint: 'fp_elec',
      );

      expect(isDuplicate(txn1, txn2), isFalse);
    });
  });

  group('Deduplication - bulk detection', () {
    test('findDuplicates returns only actual duplicates', () {
      final txns = [
        createTestTransaction(
          id: '1', merchantName: 'Swiggy', amount: 450.0,
          transactionDate: baseDate, fingerprint: 'fp1',
        ),
        createTestTransaction(
          id: '2', merchantName: 'Swiggy', amount: 450.50,
          transactionDate: baseDate.add(const Duration(days: 1)),
          fingerprint: 'fp2',
        ),
        createTestTransaction(
          id: '3', merchantName: 'Amazon', amount: 1299.0,
          transactionDate: baseDate, fingerprint: 'fp3',
        ),
        createTestTransaction(
          id: '4', merchantName: 'Swiggy', amount: 1000.0,
          transactionDate: baseDate, fingerprint: 'fp4',
        ),
      ];

      final duplicates = findDuplicates(txns);
      expect(duplicates.length, 1);
      expect(duplicates.first.id, '2');
    });

    test('findDuplicates returns empty for all unique txns', () {
      final txns = [
        createTestTransaction(
          id: '1', merchantName: 'Swiggy', amount: 450.0,
          transactionDate: baseDate, fingerprint: 'fp1',
        ),
        createTestTransaction(
          id: '2', merchantName: 'Amazon', amount: 1299.0,
          transactionDate: baseDate, fingerprint: 'fp2',
        ),
        createTestTransaction(
          id: '3', merchantName: 'Netflix', amount: 649.0,
          transactionDate: baseDate, fingerprint: 'fp3',
        ),
      ];

      expect(findDuplicates(txns), isEmpty);
    });
  });
}
