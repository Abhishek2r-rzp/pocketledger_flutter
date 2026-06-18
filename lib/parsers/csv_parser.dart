import 'package:intl/intl.dart';
import 'package:pocketledger/core/models/parsed_transaction_draft.dart';

class CSVParser {
  static const List<String> indianDateFormats = [
    'dd/MM/yy',
    'dd-MM-yyyy',
    'yyyy-MM-dd',
    'dd MMM yyyy',
    'MM/dd/yy',
    'dd/MM/yyyy',
    'd MMM yy',
    'd MMM yyyy',
    'MMM dd, yyyy',
    'dd-MMM-yyyy',
    'yyyy/MM/dd',
    'dd.MM.yyyy',
    'dd/MM/yyyy HH:mm:ss',
    'dd-MM-yyyy HH:mm:ss',
  ];

  static const Map<String, String> columnNameVariations = {
    'date': 'date',
    'transaction date': 'date',
    'value date': 'date',
    'posting date': 'date',
    'transaction_date': 'date',
    'txn date': 'date',
    'narration': 'description',
    'description': 'description',
    'particulars': 'description',
    'remarks': 'description',
    'transaction description': 'description',
    'transaction_details': 'description',
    'withdrawal': 'debit',
    'withdrawal amt.': 'debit',
    'withdrawal amt': 'debit',
    'debit': 'debit',
    'debit amount': 'debit',
    'dr': 'debit',
    'withdrawals': 'debit',
    'deposit': 'credit',
    'deposit amt.': 'credit',
    'deposit amt': 'credit',
    'credit': 'credit',
    'credit amount': 'credit',
    'cr': 'credit',
    'deposits': 'credit',
    'amount': 'amount',
    'transaction amount': 'amount',
    'txn amount': 'amount',
    'balance': 'balance',
    'closing balance': 'balance',
    'available balance': 'balance',
    'running balance': 'balance',
  };

  List<ParsedTransactionDraft> parse(String csvContent, {String currency = 'INR'}) {
    final rows = parseCSVContent(csvContent);
    if (rows.isEmpty) return [];

    final headers = rows.first.map((h) => h.trim().toLowerCase()).toList();
    final mapping = detectColumnMapping(headers);

    final List<ParsedTransactionDraft> drafts = [];
    for (int i = 1; i < rows.length; i++) {
      try {
        final row = rows[i];
        if (row.length < 2) continue;
        if (row.every((cell) => cell.trim().isEmpty)) continue;

        final draft = _parseRow(row, mapping);
        if (draft != null) {
          drafts.add(draft);
        }
      } catch (_) {}
    }

    return drafts;
  }

  ({int? date, int? description, int? debit, int? credit, int? amount, int? balance}) detectColumnMapping(List<String> headers) {
    int? dateIdx, descIdx, debitIdx, creditIdx, amountIdx, balanceIdx;

    for (int i = 0; i < headers.length; i++) {
      final header = headers[i].trim().toLowerCase();
      final mapped = columnNameVariations[header];
      if (mapped == null) continue;

      switch (mapped) {
        case 'date':
          dateIdx ??= i;
          break;
        case 'description':
          descIdx ??= i;
          break;
        case 'debit':
          debitIdx ??= i;
          break;
        case 'credit':
          creditIdx ??= i;
          break;
        case 'amount':
          amountIdx ??= i;
          break;
        case 'balance':
          balanceIdx ??= i;
          break;
      }
    }

    return (date: dateIdx, description: descIdx, debit: debitIdx, credit: creditIdx, amount: amountIdx, balance: balanceIdx);
  }

  ParsedTransactionDraft? _parseRow(List<String> row, ({int? date, int? description, int? debit, int? credit, int? amount, int? balance}) mapping) {
    DateTime? date;
    String? description;
    double? debit;
    double? credit;
    double? amount;
    double? balance;

    if (mapping.date != null && mapping.date! < row.length) {
      date = parseDate(row[mapping.date!].trim());
    }
    if (mapping.description != null && mapping.description! < row.length) {
      description = normalizeDescription(row[mapping.description!].trim());
    }
    if (mapping.debit != null && mapping.debit! < row.length) {
      debit = parseAmount(row[mapping.debit!].trim());
    }
    if (mapping.credit != null && mapping.credit! < row.length) {
      credit = parseAmount(row[mapping.credit!].trim());
    }
    if (mapping.amount != null && mapping.amount! < row.length) {
      amount = parseAmount(row[mapping.amount!].trim());
    }
    if (mapping.balance != null && mapping.balance! < row.length) {
      balance = parseAmount(row[mapping.balance!].trim());
    }

    if (date == null && description == null) return null;
    if (amount == null && debit == null && credit == null) return null;

    final resolvedAmount = amount ?? (debit ?? 0) - (debit != null ? 0 : (credit ?? 0));
    if (resolvedAmount == 0) return null;

    final rawDesc = (mapping.description != null && mapping.description! < row.length)
        ? row[mapping.description!].trim()
        : null;

    return ParsedTransactionDraft(
      date: date,
      description: description,
      debit: debit,
      credit: credit,
      amount: amount,
      balance: balance,
      rawDescription: rawDesc,
    );
  }

  DateTime? parseDate(String dateString) {
    if (dateString.isEmpty) return null;
    final cleaned = dateString.trim().replaceAll(RegExp(r'[\u200E\u200F]'), '');

    for (final format in indianDateFormats) {
      try {
        return DateFormat(format, 'en').parseStrict(cleaned);
      } catch (_) {}
    }

    try {
      return DateTime.parse(cleaned);
    } catch (_) {}

    return null;
  }

  double? parseAmount(String amountString) {
    if (amountString.isEmpty) return null;
    String cleaned = amountString.trim();

    cleaned = cleaned.replaceAll('₹', '').replaceAll('Rs', '').replaceAll('rs', '').replaceAll('INR', '').replaceAll(',', '').trim();

    final isNegative = cleaned.startsWith('(') && cleaned.endsWith(')');
    if (isNegative) {
      cleaned = cleaned.substring(1, cleaned.length - 1);
    }

    if (cleaned.contains('-') && !cleaned.startsWith('-')) {
      final parts = cleaned.split('-');
      cleaned = parts[0].trim();
    }

    final isNegativeSign = cleaned.startsWith('-');
    if (isNegativeSign) {
      cleaned = cleaned.substring(1);
    }

    final netNegative = isNegative || isNegativeSign;

    try {
      double value = double.parse(cleaned);
      if (value.isNaN || value.isInfinite) return null;
      return netNegative ? -value : value;
    } catch (_) {
      return null;
    }
  }

  String normalizeDescription(String description) {
    String result = description.trim();
    result = result.replaceAllMapped(
      RegExp(r'^(UPI|NEFT|RTGS|IMPS|ECS|CHEQUE|CHQ|DD|REF|UTR|TXN|TRF)[-\s:#]*', caseSensitive: false),
      (_) => '',
    );
    result = result.replaceAllMapped(
      RegExp(r'(UPI|NEFT|RTGS|IMPS|ECS|CHEQUE|CHQ|DD|REF|UTR|TXN|TRF)[-\s:#]?[\d\w]{6,}', caseSensitive: false),
      (_) => '',
    );
    result = result.replaceAll(RegExp(r'\s{2,}'), ' ').trim();
    if (result.length > 120) {
      result = result.substring(0, 120).trim();
    }
    return result;
  }

  static List<List<String>> parseCSVContent(String content) {
    final List<List<String>> rows = [];
    final List<String> currentRow = [];
    StringBuffer currentField = StringBuffer();
    bool inQuotes = false;

    for (int i = 0; i < content.length; i++) {
      final char = content[i];
      final nextChar = i + 1 < content.length ? content[i + 1] : null;

      if (inQuotes) {
        if (char == '"' && nextChar == '"') {
          currentField.write('"');
          i++;
        } else if (char == '"') {
          inQuotes = false;
        } else {
          currentField.write(char);
        }
      } else {
        if (char == '"') {
          inQuotes = true;
        } else if (char == ',') {
          currentRow.add(currentField.toString().trim());
          currentField = StringBuffer();
        } else if (char == '\n') {
          currentRow.add(currentField.toString().trim());
          if (currentRow.isNotEmpty && currentRow.any((f) => f.isNotEmpty)) {
            rows.add(List.from(currentRow));
          }
          currentRow.clear();
          currentField = StringBuffer();
        } else if (char == '\r') {
          continue;
        } else {
          currentField.write(char);
        }
      }
    }

    currentRow.add(currentField.toString().trim());
    if (currentRow.isNotEmpty && currentRow.any((f) => f.isNotEmpty)) {
      rows.add(List.from(currentRow));
    }

    return rows;
  }
}
