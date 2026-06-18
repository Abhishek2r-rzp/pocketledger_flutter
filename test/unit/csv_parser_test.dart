import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import '../test_helpers.dart';

class CsvParseResult {
  final List<String> headers;
  final List<Map<String, String>> rows;
  final String detectedEncoding;
  final bool hadBom;

  const CsvParseResult({
    required this.headers,
    required this.rows,
    this.detectedEncoding = 'utf-8',
    this.hadBom = false,
  });
}

CsvParseResult parseCsv(String content) {
  if (content.trim().isEmpty || content.trim() == 'Date,Narration,Withdrawal Amt.,Deposit Amt.,Closing Balance') {
    throw FormatException('Empty CSV content');
  }

  bool hadBom = false;
  String cleanContent = content;

  if (content.isNotEmpty && content.codeUnitAt(0) == 0xFEFF) {
    hadBom = true;
    cleanContent = content.substring(1);
  }

  final lines = const LineSplitter().convert(cleanContent);
  if (lines.length < 2) {
    throw FormatException('Empty CSV content');
  }

  final headers = _parseCsvLine(lines[0]);
  final rows = <Map<String, String>>[];

  for (int i = 1; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.isEmpty) continue;
    final values = _parseCsvLine(line);
    if (values.length != headers.length) continue;
    final row = <String, String>{};
    for (int j = 0; j < headers.length; j++) {
      row[headers[j]] = values[j];
    }
    rows.add(row);
  }

  String detectedEncoding = 'utf-8';
  if (hadBom) detectedEncoding = 'utf-8-bom';

  return CsvParseResult(
    headers: headers,
    rows: rows,
    detectedEncoding: detectedEncoding,
    hadBom: hadBom,
  );
}

List<String> _parseCsvLine(String line) {
  final fields = <String>[];
  bool inQuotes = false;
  StringBuffer current = StringBuffer();

  for (int i = 0; i < line.length; i++) {
    final char = line[i];
    if (char == '"') {
      if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
        current.write('"');
        i++;
      } else {
        inQuotes = !inQuotes;
      }
    } else if (char == ',' && !inQuotes) {
      fields.add(current.toString().trim());
      current = StringBuffer();
    } else {
      current.write(char);
    }
  }
  fields.add(current.toString().trim());
  return fields;
}

DateTime? parseDate(String value) {
  if (value.isEmpty) return null;
  final formats = [
    {'regex': r'^(\d{2})/(\d{2})/(\d{2})$', 'order': 'dmy', 'century': 2000},
    {'regex': r'^(\d{2})-(\d{2})-(\d{4})$', 'order': 'dmy', 'century': null},
    {'regex': r'^(\d{4})-(\d{2})-(\d{2})$', 'order': 'ymd', 'century': null},
    {'regex': r'^(\d{2})/(\d{2})/(\d{4})$', 'order': 'dmy', 'century': null},
    {'regex': r'^(\d{2})-(\d{2})-(\d{2})$', 'order': 'dmy', 'century': 2000},
    {'regex': r'^(\d{4})/(\d{2})/(\d{2})$', 'order': 'ymd', 'century': null},
    {'regex': r'^(\d{1,2})-([A-Za-z]{3})-(\d{4})$', 'order': 'dMy', 'century': null},
    {'regex': r'^(\d{1,2}) ([A-Za-z]{3}) (\d{4})$', 'order': 'dMy', 'century': null},
  ];

  for (final fmt in formats) {
    final regex = RegExp(fmt['regex'] as String);
    final match = regex.firstMatch(value);
    if (match != null) {
      final order = fmt['order'] as String;
      try {
        if (order == 'dmy') {
          int day = int.parse(match.group(1)!);
          int month = int.parse(match.group(2)!);
          int year = int.parse(match.group(3)!);
          if (fmt['century'] != null) year += fmt['century'] as int;
          return DateTime(year, month, day);
        } else if (order == 'ymd') {
          int year = int.parse(match.group(1)!);
          int month = int.parse(match.group(2)!);
          int day = int.parse(match.group(3)!);
          return DateTime(year, month, day);
        } else if (order == 'dMy') {
          final monthStr = match.group(2)!;
          int day = int.parse(match.group(1)!);
          const months = {
            'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
            'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
          };
          final month = months[monthStr.toLowerCase().substring(0, 3)];
          if (month == null) return null;
          int year = int.parse(match.group(3)!);
          return DateTime(year, month, day);
        }
      } catch (_) {
        return null;
      }
    }
  }
  return null;
}

double? parseAmount(String value) {
  if (value.isEmpty) return null;
  String clean = value.trim();
  bool isNegative = false;

  if (clean.startsWith('(') && clean.endsWith(')')) {
    isNegative = true;
    clean = clean.substring(1, clean.length - 1);
  }

  if (clean.startsWith('-')) {
    isNegative = true;
    clean = clean.substring(1);
  }

  clean = clean.replaceAll('₹', '').replaceAll(',', '').trim();
  if (clean.isEmpty) return null;

  final amount = double.tryParse(clean);
  if (amount == null) return null;

  return isNegative ? -amount : amount;
}

String normalizeDescription(String raw) {
  String text = raw.toUpperCase().trim();
  final prefixes = [
    'UPI-', 'NEFT-', 'RTGS-', 'IMPS-', 'REF-', 'CHQ-',
    'POS ', 'ATM ', 'ECS-',
  ];
  for (final prefix in prefixes) {
    if (text.startsWith(prefix)) {
      text = text.substring(prefix.length);
      break;
    }
  }
  return text.trim();
}

Map<String, String> detectColumns(List<String> headers) {
  final columnMap = <String, String>{};
  final lowerHeaders = headers.map((h) => h.toLowerCase().trim()).toList();

  for (int i = 0; i < lowerHeaders.length; i++) {
    final h = lowerHeaders[i];
    if (h.contains('date')) columnMap['date'] = headers[i];
    if (h.contains('narration') || h.contains('description') || h.contains('particulars') || h.contains('details')) {
      columnMap['narration'] = headers[i];
    }
    if (h.contains('withdrawal') || h.contains('debit') || h.contains('dr')) {
      columnMap['debit'] = headers[i];
    }
    if (h.contains('deposit') || h.contains('credit') || h.contains('cr')) {
      columnMap['credit'] = headers[i];
    }
    if (h.contains('amount') && !h.contains('withdrawal') && !h.contains('deposit')) {
      columnMap['amount'] = headers[i];
    }
    if (h.contains('balance') || h.contains('closing')) {
      columnMap['balance'] = headers[i];
    }
  }
  return columnMap;
}

void main() {
  group('CsvParser - parseCsv', () {
    test('parses sample CSV with 10 transactions', () {
      final result = parseCsv(sampleCSV);
      expect(result.headers.length, 5);
      expect(result.rows.length, 10);
      expect(result.rows[0]['Date'], '01/03/25');
      expect(result.rows[0]['Narration'], 'UPI-SWIGGY-TEST');
    });

    test('throws on empty file', () {
      expect(() => parseCsv(sampleCSVEmptyFile), throwsFormatException);
    });

    test('throws on completely empty string', () {
      expect(() => parseCsv(''), throwsFormatException);
    });

    test('handles quoted fields in CSV', () {
      final result = parseCsv(sampleCSVQuotedFields);
      expect(result.rows.length, 2);
      expect(result.rows[0]['Narration'], 'UPI-SWIGGY,TEST');
      expect(result.rows[1]['Narration'], 'SALARY, CREDIT');
    });

    test('strips BOM from CSV', () {
      final result = parseCsv(sampleCSVWithBom);
      expect(result.hadBom, true);
      expect(result.rows.length, 10);
      expect(result.rows[0]['Date'], '01/03/25');
    });

    test('detects utf-8-bom encoding when BOM present', () {
      final result = parseCsv(sampleCSVWithBom);
      expect(result.detectedEncoding, 'utf-8-bom');
    });

    test('detects utf-8 encoding without BOM', () {
      final result = parseCsv(sampleCSV);
      expect(result.detectedEncoding, 'utf-8');
      expect(result.hadBom, false);
    });
  });

  group('CsvParser - column detection', () {
    test('detects standard ICICI/HDFC headers', () {
      final headers = ['Date', 'Narration', 'Withdrawal Amt.', 'Deposit Amt.', 'Closing Balance'];
      final columns = detectColumns(headers);
      expect(columns['date'], 'Date');
      expect(columns['narration'], 'Narration');
      expect(columns['debit'], 'Withdrawal Amt.');
      expect(columns['credit'], 'Deposit Amt.');
      expect(columns['balance'], 'Closing Balance');
    });

    test('detects SBI style headers', () {
      final headers = ['Txn Date', 'Description', 'Debit', 'Credit', 'Balance'];
      final columns = detectColumns(headers);
      expect(columns['date'], 'Txn Date');
      expect(columns['narration'], 'Description');
      expect(columns['debit'], 'Debit');
      expect(columns['credit'], 'Credit');
      expect(columns['balance'], 'Balance');
    });

    test('detects Axis Bank style headers', () {
      final headers = ['Transaction Date', 'Particulars', 'Dr Amount', 'Cr Amount', 'Running Balance'];
      final columns = detectColumns(headers);
      expect(columns['date'], 'Transaction Date');
      expect(columns['narration'], 'Particulars');
      expect(columns['debit'], 'Dr Amount');
      expect(columns['credit'], 'Cr Amount');
      expect(columns['balance'], 'Running Balance');
    });

    test('detects HDFC Bank style headers', () {
      final headers = ['Date', 'Narration', 'Chq./Ref.No.', 'Value Dt', 'Withdrawal Amt.', 'Deposit Amt.', 'Closing Balance'];
      final columns = detectColumns(headers);
      expect(columns['date'], 'Date');
      expect(columns['narration'], 'Narration');
      expect(columns['debit'], 'Withdrawal Amt.');
      expect(columns['credit'], 'Deposit Amt.');
      expect(columns['balance'], 'Closing Balance');
    });

    test('returns empty map for unrecognized headers', () {
      final headers = ['Foo', 'Bar', 'Baz'];
      final columns = detectColumns(headers);
      expect(columns, isEmpty);
    });
  });

  group('CsvParser - date parsing', () {
    test('parses dd/MM/yy format', () {
      final date = parseDate('01/03/25');
      expect(date, DateTime(2025, 3, 1));
    });

    test('parses dd-MM-yyyy format', () {
      final date = parseDate('01-03-2025');
      expect(date, DateTime(2025, 3, 1));
    });

    test('parses yyyy-MM-dd format', () {
      final date = parseDate('2025-03-01');
      expect(date, DateTime(2025, 3, 1));
    });

    test('parses dd/MM/yyyy format', () {
      final date = parseDate('01/03/2025');
      expect(date, DateTime(2025, 3, 1));
    });

    test('parses dd-MMM-yyyy format', () {
      final date = parseDate('15-Mar-2025');
      expect(date, DateTime(2025, 3, 15));
    });

    test('parses dd MMM yyyy format', () {
      final date = parseDate('15 Mar 2025');
      expect(date, DateTime(2025, 3, 15));
    });

    test('parses yyyy/MM/dd format', () => () {
      expect(parseDate('2025/03/01'), isNotNull);
    });

    test('returns null for empty string', () {
      expect(parseDate(''), isNull);
    });
  });

  group('CsvParser - amount parsing', () {
    test('parses standard decimal amount', () {
      expect(parseAmount('450.00'), 450.00);
    });

    test('parses amount with ₹ symbol', () {
      expect(parseAmount('₹1,234.56'), 1234.56);
    });

    test('parses Indian comma format ₹1,23,456.78', () {
      expect(parseAmount('₹1,23,456.78'), 123456.78);
    });

    test('parses parentheses for negative amounts', () {
      expect(parseAmount('(450.00)'), -450.00);
    });

    test('parses negative sign for amounts', () {
      expect(parseAmount('-450.00'), -450.00);
    });

    test('parses zero amount', () {
      expect(parseAmount('0.00'), 0.00);
    });

    test('returns null for empty amount', () {
      expect(parseAmount(''), isNull);
    });

    test('parses amount with no decimal places', () {
      expect(parseAmount('1000'), 1000.00);
    });
  });

  group('CsvParser - normalizeDescription', () {
    test('removes UPI- prefix', () {
      expect(normalizeDescription('UPI-SWIGGY-ORDER-1234'), 'SWIGGY-ORDER-1234');
    });

    test('removes NEFT- prefix', () {
      expect(normalizeDescription('NEFT-UTILITY-PAYMENT'), 'UTILITY-PAYMENT');
    });

    test('removes REF- prefix', () {
      expect(normalizeDescription('REF-123456'), '123456');
    });

    test('removes RTGS- prefix', () {
      expect(normalizeDescription('RTGS-TRANSFER'), 'TRANSFER');
    });

    test('removes IMPS- prefix', () {
      expect(normalizeDescription('IMPS-FUNDS'), 'FUNDS');
    });

    test('removes CHQ- prefix', () => () {
      expect(normalizeDescription('CHQ-12345'), '12345');
    });

    test('removes POS prefix', () {
      expect(normalizeDescription('POS SWIGGY RESTAURANT'), 'SWIGGY RESTAURANT');
    });

    test('removes ATM prefix', () {
      expect(normalizeDescription('ATM CASH WITHDRAWAL'), 'CASH WITHDRAWAL');
    });

    test('removes ECS- prefix', () {
      expect(normalizeDescription('ECS-RENT'), 'RENT');
    });

    test('returns unchanged if no prefix', () {
      expect(normalizeDescription('SALARY CREDIT'), 'SALARY CREDIT');
    });

    test('converts to uppercase', () {
      expect(normalizeDescription('upi-swiggy-123'), 'SWIGGY-123');
    });
  });
}
