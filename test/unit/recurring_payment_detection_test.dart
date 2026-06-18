import 'package:flutter_test/flutter_test.dart';
import '../test_helpers.dart';

class RecurringDetectionResult {
  final String merchantName;
  final double amount;
  final double amountVariance;
  final PaymentFrequency frequency;
  final double confidence;
  final List<String> transactionIds;
  final bool isRecurring;

  const RecurringDetectionResult({
    required this.merchantName,
    required this.amount,
    this.amountVariance = 0.0,
    this.frequency = PaymentFrequency.unknown,
    this.confidence = 0.0,
    this.transactionIds = const [],
    this.isRecurring = false,
  });
}

PaymentFrequency detectFrequency(List<DateTime> dates) {
  if (dates.length < 2) return PaymentFrequency.unknown;

  final sorted = List<DateTime>.from(dates)..sort();
  final intervals = <int>[];
  for (int i = 1; i < sorted.length; i++) {
    intervals.add(sorted[i].difference(sorted[i - 1]).inDays);
  }

  if (intervals.isEmpty) return PaymentFrequency.unknown;

  final avgInterval = intervals.fold(0, (a, b) => a + b) / intervals.length;

  for (final interval in intervals) {
    if ((interval - avgInterval).abs() > 7) return PaymentFrequency.unknown;
  }

  if (avgInterval >= 25 && avgInterval <= 35) return PaymentFrequency.monthly;
  if (avgInterval >= 5 && avgInterval <= 10) return PaymentFrequency.weekly;
  if (avgInterval >= 80 && avgInterval <= 100) return PaymentFrequency.quarterly;
  if (avgInterval >= 355 && avgInterval <= 375) return PaymentFrequency.yearly;

  return PaymentFrequency.unknown;
}

double calculateVariance(List<double> amounts) {
  if (amounts.length < 2) return 0;
  final mean = amounts.fold(0.0, (a, b) => a + b) / amounts.length;
  final variance = amounts.fold(0.0, (sum, a) => sum + (a - mean) * (a - mean)) / amounts.length;
  return variance;
}

RecurringDetectionResult detectRecurring(List<Transaction> transactions) {
  if (transactions.length < 3) {
    return const RecurringDetectionResult(
      merchantName: '', amount: 0, isRecurring: false,
    );
  }

  final byMerchant = <String, List<Transaction>>{};
  for (final txn in transactions) {
    final merchant = txn.merchantName ?? txn.rawDescription;
    byMerchant.putIfAbsent(merchant, () => []).add(txn);
  }

  for (final entry in byMerchant.entries) {
    final txns = entry.value;
    if (txns.length < 3) continue;

    final dates = txns.map((t) => t.transactionDate).toList()..sort();
    final amounts = txns.map((t) => t.amount).toList();
    final variance = calculateVariance(amounts);

    if (variance > 5000) continue;

    final frequency = detectFrequency(dates);

    if (frequency == PaymentFrequency.unknown) continue;

    final avgAmount = amounts.fold(0.0, (a, b) => a + b) / amounts.length;
    double confidence = 0.0;

    switch (frequency) {
      case PaymentFrequency.monthly:
        confidence = 0.8;
        break;
      case PaymentFrequency.weekly:
        confidence = 0.75;
        break;
      case PaymentFrequency.quarterly:
        confidence = 0.7;
        break;
      case PaymentFrequency.yearly:
        confidence = 0.65;
        break;
      default:
        confidence = 0.0;
    }

    if (txns.length >= 6) confidence += 0.1;
    if (txns.length >= 12) confidence += 0.05;
    if (variance < 100) confidence += 0.1;

    return RecurringDetectionResult(
      merchantName: entry.key,
      amount: double.parse(avgAmount.toStringAsFixed(2)),
      amountVariance: variance,
      frequency: frequency,
      confidence: confidence.clamp(0.0, 1.0),
      transactionIds: txns.map((t) => t.id).toList(),
      isRecurring: true,
    );
  }

  return const RecurringDetectionResult(
    merchantName: '', amount: 0, isRecurring: false,
  );
}

void main() {
  late DateTime baseDate;

  setUp(() {
    baseDate = DateTime(2025, 1, 15);
  });

  group('RecurringPaymentDetector - monthly recurring', () {
    test('3+ transactions at ~30 day intervals detected as monthly', () {
      final txns = List.generate(4, (i) {
        return createTestTransaction(
          id: 'netflix_$i',
          merchantName: 'Netflix',
          amount: 649.0,
          transactionDate: baseDate.add(Duration(days: i * 30)),
        );
      });

      final result = detectRecurring(txns);
      expect(result.isRecurring, isTrue);
      expect(result.frequency, PaymentFrequency.monthly);
      expect(result.confidence, greaterThanOrEqualTo(0.8));
    });

    test('same merchant, similar amount detected monthly', () {
      final txns = List.generate(4, (i) {
        return createTestTransaction(
          id: 'swiggy_one_$i',
          merchantName: 'Swiggy One',
          amount: 149.0,
          transactionDate: baseDate.add(Duration(days: i * 30)),
        );
      });

      final result = detectRecurring(txns);
      expect(result.isRecurring, isTrue);
      expect(result.frequency, PaymentFrequency.monthly);
    });

    test('exactly 3 monthly transactions detected', () {
      final txns = List.generate(3, (i) {
        return createTestTransaction(
          id: 'spotify_$i',
          merchantName: 'Spotify',
          amount: 199.0,
          transactionDate: baseDate.add(Duration(days: i * 30)),
        );
      });

      final result = detectRecurring(txns);
      expect(result.isRecurring, isTrue);
    });
  });

  group('RecurringPaymentDetector - single transaction', () {
    test('single transaction is not recurring', () {
      final txns = [
        createTestTransaction(
          id: 'netflix_1',
          merchantName: 'Netflix',
          amount: 649.0,
          transactionDate: baseDate,
        ),
      ];

      final result = detectRecurring(txns);
      expect(result.isRecurring, isFalse);
    });

    test('two transactions is not yet recurring', () {
      final txns = [
        createTestTransaction(
          id: 'netflix_1', merchantName: 'Netflix',
          amount: 649.0, transactionDate: baseDate,
        ),
        createTestTransaction(
          id: 'netflix_2', merchantName: 'Netflix',
          amount: 649.0, transactionDate: baseDate.add(const Duration(days: 30)),
        ),
      ];

      final result = detectRecurring(txns);
      expect(result.isRecurring, isFalse);
    });
  });

  group('RecurringPaymentDetector - weekly frequency', () {
    test('transactions at ~7 day intervals detected as weekly', () {
      final txns = List.generate(5, (i) {
        return createTestTransaction(
          id: 'lunch_$i',
          merchantName: 'Weekly Lunch',
          amount: 250.0,
          transactionDate: baseDate.add(Duration(days: i * 7)),
        );
      });

      final result = detectRecurring(txns);
      expect(result.isRecurring, isTrue);
      expect(result.frequency, PaymentFrequency.weekly);
    });
  });

  group('RecurringPaymentDetector - confidence scoring', () {
    test('more transactions increase confidence', () {
      final txns4 = List.generate(4, (i) {
        return createTestTransaction(
          id: 'netflix_$i', merchantName: 'Netflix',
          amount: 649.0, transactionDate: baseDate.add(Duration(days: i * 30)),
        );
      });
      final txns8 = List.generate(8, (i) {
        return createTestTransaction(
          id: 'netflix_b_$i', merchantName: 'Netflix',
          amount: 649.0, transactionDate: baseDate.add(Duration(days: i * 30)),
        );
      });

      expect(detectRecurring(txns8).confidence, greaterThan(detectRecurring(txns4).confidence));
    });

    test('exact same amounts increase confidence', () {
      final exactAmount = List.generate(4, (i) {
        return createTestTransaction(
          id: 'netflix_e_$i', merchantName: 'Netflix',
          amount: 649.0, transactionDate: baseDate.add(Duration(days: i * 30)),
        );
      });
      final varyingAmount = List.generate(4, (i) {
        return createTestTransaction(
          id: 'netflix_v_$i', merchantName: 'Netflix',
          amount: 649.0 + i * 50.0,
          transactionDate: baseDate.add(Duration(days: i * 30)),
        );
      });

      expect(
        detectRecurring(exactAmount).confidence,
        greaterThan(detectRecurring(varyingAmount).confidence),
      );
    });
  });

  group('RecurringPaymentDetector - non-recurring', () {
    test('random unrelated transactions not detected', () {
      const merchants = ['Swiggy', 'Amazon', 'Uber', 'DMart', 'Zomato'];
      final txns = List.generate(10, (i) {
        return createTestTransaction(
          id: 'txn_$i',
          merchantName: merchants[i % merchants.length],
          amount: (100.0 + i * 37.0),
          transactionDate: baseDate.add(Duration(days: i * 2)),
        );
      });

      final result = detectRecurring(txns);
      expect(result.isRecurring, isFalse);
    });

    test('same merchant but very different amounts not recurring', () {
      final txns = List.generate(4, (i) {
        return createTestTransaction(
          id: 'uber_$i', merchantName: 'Uber',
          amount: 100.0 + i * 200.0,
          transactionDate: baseDate.add(Duration(days: i * 30)),
        );
      });

      final result = detectRecurring(txns);
      expect(result.isRecurring, isFalse);
    });
  });

  group('RecurringPaymentDetector - frequency detection', () {
    test('detectFrequency returns monthly for ~30 day intervals', () {
      final dates = [
        DateTime(2025, 1, 15),
        DateTime(2025, 2, 15),
        DateTime(2025, 3, 15),
        DateTime(2025, 4, 15),
      ];
      expect(detectFrequency(dates), PaymentFrequency.monthly);
    });

    test('detectFrequency returns weekly for ~7 day intervals', () {
      final dates = [
        DateTime(2025, 1, 1),
        DateTime(2025, 1, 8),
        DateTime(2025, 1, 15),
        DateTime(2025, 1, 22),
      ];
      expect(detectFrequency(dates), PaymentFrequency.weekly);
    });

    test('detectFrequency returns unknown for single date', () {
      expect(detectFrequency([DateTime(2025, 1, 1)]), PaymentFrequency.unknown);
    });

    test('detectFrequency returns unknown for irregular intervals', () {
      final dates = [
        DateTime(2025, 1, 1),
        DateTime(2025, 2, 15),
        DateTime(2025, 3, 10),
      ];
      expect(detectFrequency(dates), PaymentFrequency.unknown);
    });
  });

  group('RecurringPaymentDetector - amount variance', () {
    test('calculateVariance returns 0 for identical amounts', () {
      expect(calculateVariance([649.0, 649.0, 649.0]), 0.0);
    });

    test('calculateVariance returns positive for varying amounts', () {
      expect(calculateVariance([100.0, 200.0, 300.0]), greaterThan(0));
    });

    test('calculateVariance returns 0 for single amount', () {
      expect(calculateVariance([649.0]), 0.0);
    });
  });
}
