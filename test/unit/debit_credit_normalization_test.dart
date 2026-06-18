import 'package:flutter_test/flutter_test.dart';
import '../test_helpers.dart';

enum NormalizationMode { singleColumn, dualColumn }

TransactionDirection? normalizeDirection({
  String? debitValue,
  String? creditValue,
  String? amountValue,
  NormalizationMode mode = NormalizationMode.singleColumn,
}) {
  if (mode == NormalizationMode.dualColumn) {
    if (debitValue != null && debitValue.isNotEmpty && debitValue != '0') {
      return TransactionDirection.expense;
    }
    if (creditValue != null && creditValue.isNotEmpty && creditValue != '0') {
      return TransactionDirection.income;
    }
    return null;
  }

  if (amountValue == null || amountValue.isEmpty) return null;

  final clean = amountValue
      .replaceAll('₹', '')
      .replaceAll(',', '')
      .replaceAll('(', '')
      .replaceAll(')', '')
      .trim();

  final amount = double.tryParse(clean);
  if (amount == null) return null;

  final isNegative = amountValue.startsWith('-') ||
      (amountValue.startsWith('(') && amountValue.endsWith(')'));

  if (isNegative) return TransactionDirection.expense;
  if (amount > 0) return TransactionDirection.income;
  return null;
}

double? normalizeAmount({
  String? debitValue,
  String? creditValue,
  String? amountValue,
  TransactionDirection? direction,
  NormalizationMode mode = NormalizationMode.singleColumn,
}) {
  double parseClean(String value) {
    final clean = value
        .replaceAll('₹', '')
        .replaceAll(',', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .trim();
    final amount = double.tryParse(clean);
    if (amount == null) return 0.0;

    final isNegative = value.startsWith('-') ||
        (value.startsWith('(') && value.endsWith(')'));
    return isNegative ? -amount : amount;
  }

  if (mode == NormalizationMode.dualColumn) {
    if (debitValue != null && debitValue.isNotEmpty && debitValue != '0') {
      return parseClean(debitValue).abs();
    }
    if (creditValue != null && creditValue.isNotEmpty && creditValue != '0') {
      return parseClean(creditValue).abs();
    }
    return null;
  }

  if (amountValue == null || amountValue.isEmpty) return null;
  return parseClean(amountValue).abs();
}

void main() {
  group('DebitCreditNormalizer - single column (amount)', () {
    group('direction detection', () {
      test('positive amount is income', () {
        expect(
          normalizeDirection(amountValue: '50000.00'),
          TransactionDirection.income,
        );
      });

      test('negative amount (with -) is expense', () {
        expect(
          normalizeDirection(amountValue: '-450.00'),
          TransactionDirection.expense,
        );
      });

      test('negative amount (parentheses) is expense', () {
        expect(
          normalizeDirection(amountValue: '(450.00)'),
          TransactionDirection.expense,
        );
      });

      test('amount with ₹ symbol positive is income', () {
        expect(
          normalizeDirection(amountValue: '₹50000.00'),
          TransactionDirection.income,
        );
      });

      test('zero amount returns null', () {
        expect(normalizeDirection(amountValue: '0'), isNull);
      });

      test('empty value returns null', () {
        expect(normalizeDirection(amountValue: ''), isNull);
      });

      test('null amount returns null', () {
        expect(normalizeDirection(), isNull);
      });
    });

    group('amount extraction', () {
      test('returns absolute value for positive amount', () {
        expect(normalizeAmount(amountValue: '50000.00'), 50000.00);
      });

      test('returns absolute value for negative amount', () {
        expect(normalizeAmount(amountValue: '-450.00'), 450.00);
      });

      test('returns absolute value for parenthesized amount', () {
        expect(normalizeAmount(amountValue: '(450.00)'), 450.00);
      });

      test('handles ₹ symbol', () {
        expect(normalizeAmount(amountValue: '₹1,234.56'), 1234.56);
      });

      test('handles Indian comma format', () {
        expect(normalizeAmount(amountValue: '₹1,23,456.78'), 123456.78);
      });

      test('empty value returns null', () {
        expect(normalizeAmount(amountValue: ''), isNull);
      });
    });
  });

  group('DebitCreditNormalizer - dual column (debit/credit)', () {
    group('direction detection', () {
      test('debit column has value = expense', () {
        expect(
          normalizeDirection(
            debitValue: '450.00',
            creditValue: '',
            mode: NormalizationMode.dualColumn,
          ),
          TransactionDirection.expense,
        );
      });

      test('credit column has value = income', () {
        expect(
          normalizeDirection(
            debitValue: '',
            creditValue: '50000.00',
            mode: NormalizationMode.dualColumn,
          ),
          TransactionDirection.income,
        );
      });

      test('both empty returns null', () {
        expect(
          normalizeDirection(
            debitValue: '',
            creditValue: '',
            mode: NormalizationMode.dualColumn,
          ),
          isNull,
        );
      });

      test('both zero returns null', () {
        expect(
          normalizeDirection(
            debitValue: '0',
            creditValue: '0',
            mode: NormalizationMode.dualColumn,
          ),
          isNull,
        );
      });

      test('debit takes priority when both have values', () {
        expect(
          normalizeDirection(
            debitValue: '450.00',
            creditValue: '50000.00',
            mode: NormalizationMode.dualColumn,
          ),
          TransactionDirection.expense,
        );
      });
    });

    group('amount extraction', () {
      test('uses debit amount when debit has value', () {
        expect(
          normalizeAmount(
            debitValue: '450.00',
            creditValue: '',
            mode: NormalizationMode.dualColumn,
          ),
          450.00,
        );
      });

      test('uses credit amount when credit has value', () {
        expect(
          normalizeAmount(
            debitValue: '',
            creditValue: '50000.00',
            mode: NormalizationMode.dualColumn,
          ),
          50000.00,
        );
      });

      test('uses debit over credit when both present', () {
        expect(
          normalizeAmount(
            debitValue: '450.00',
            creditValue: '50000.00',
            mode: NormalizationMode.dualColumn,
          ),
          450.00,
        );
      });

      test('returns absolute value for debit', () {
        expect(
          normalizeAmount(
            debitValue: '-450.00',
            creditValue: '',
            mode: NormalizationMode.dualColumn,
          ),
          450.00,
        );
      });

      test('both empty returns null', () {
        expect(
          normalizeAmount(
            debitValue: '',
            creditValue: '',
            mode: NormalizationMode.dualColumn,
          ),
          isNull,
        );
      });

      test('zero debit returns null', () {
        expect(
          normalizeAmount(
            debitValue: '0',
            creditValue: '',
            mode: NormalizationMode.dualColumn,
          ),
          isNull,
        );
      });
    });
  });

  group('DebitCreditNormalizer - integration with sample data', () {
    test('parses Swiggy txn as expense from sample CSV', () {
      final direction = normalizeDirection(
        debitValue: '450.00',
        creditValue: '',
        mode: NormalizationMode.dualColumn,
      );
      final amount = normalizeAmount(
        debitValue: '450.00',
        creditValue: '',
        mode: NormalizationMode.dualColumn,
      );
      expect(direction, TransactionDirection.expense);
      expect(amount, 450.00);
    });

    test('parses salary txn as income from sample CSV', () {
      final direction = normalizeDirection(
        debitValue: '',
        creditValue: '50000.00',
        mode: NormalizationMode.dualColumn,
      );
      final amount = normalizeAmount(
        debitValue: '',
        creditValue: '50000.00',
        mode: NormalizationMode.dualColumn,
      );
      expect(direction, TransactionDirection.income);
      expect(amount, 50000.00);
    });
  });
}
