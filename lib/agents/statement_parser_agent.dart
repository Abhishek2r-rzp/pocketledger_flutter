import 'dart:io';
import 'dart:convert';
import 'package:csv/csv.dart';

import '../core/models/transaction.dart';
import 'agent_core/agent_protocol.dart';

class StatementParserInput {
  final String filePath;
  final String fileType;
  final String importBatchId;
  final String currency;

  const StatementParserInput({
    required this.filePath,
    required this.fileType,
    required this.importBatchId,
    required this.currency,
  });
}

class StatementParserOutput {
  final List<ParsedTransactionDraft> parsedDrafts;
  final double parserConfidence;
  final List<String> parseErrors;

  const StatementParserOutput({
    required this.parsedDrafts,
    required this.parserConfidence,
    required this.parseErrors,
  });
}

class ParsedTransactionDraft {
  final int rowNumber;
  final String rawDate;
  final String rawDescription;
  final String? rawDebit;
  final String? rawCredit;
  final String? rawAmount;
  final String? rawBalance;
  final DateTime? parsedDate;
  final double? parsedAmount;
  final TransactionDirection? parsedDirection;
  final double? parsedBalance;
  final String currency;

  const ParsedTransactionDraft({
    required this.rowNumber,
    required this.rawDate,
    required this.rawDescription,
    this.rawDebit,
    this.rawCredit,
    this.rawAmount,
    this.rawBalance,
    this.parsedDate,
    this.parsedAmount,
    this.parsedDirection,
    this.parsedBalance,
    required this.currency,
  });

  ParsedTransactionDraft copyWith({
    int? rowNumber,
    String? rawDate,
    String? rawDescription,
    String? rawDebit,
    String? rawCredit,
    String? rawAmount,
    String? rawBalance,
    DateTime? parsedDate,
    double? parsedAmount,
    TransactionDirection? parsedDirection,
    double? parsedBalance,
    String? currency,
  }) {
    return ParsedTransactionDraft(
      rowNumber: rowNumber ?? this.rowNumber,
      rawDate: rawDate ?? this.rawDate,
      rawDescription: rawDescription ?? this.rawDescription,
      rawDebit: rawDebit ?? this.rawDebit,
      rawCredit: rawCredit ?? this.rawCredit,
      rawAmount: rawAmount ?? this.rawAmount,
      rawBalance: rawBalance ?? this.rawBalance,
      parsedDate: parsedDate ?? this.parsedDate,
      parsedAmount: parsedAmount ?? this.parsedAmount,
      parsedDirection: parsedDirection ?? this.parsedDirection,
      parsedBalance: parsedBalance ?? this.parsedBalance,
      currency: currency ?? this.currency,
    );
  }
}

class StatementParserAgent
    implements Agent<StatementParserInput, StatementParserOutput> {
  @override
  String get name => 'StatementParserAgent';

  @override
  String get purpose =>
      'Parses CSV/PDF files, extracts raw transaction rows';

  double estimateConfidence(List<ParsedTransactionDraft> drafts) {
    if (drafts.isEmpty) return 0;
    final parsed = drafts.where((d) => d.parsedAmount != null).length;
    return parsed / drafts.length;
  }

  List<ParsedTransactionDraft> _parseCsv(
      String filePath, String importBatchId, String currency) {
    final file = File(filePath);
    final contents = file.readAsStringSync();
    final rows =
        const CsvToListConverter(eol: '\n').convert(contents);

    final drafts = <ParsedTransactionDraft>[];
    int dataStart = 0;

    for (int i = 0; i < rows.length; i++) {
      if (rows[i].isEmpty || rows[i].every((c) => c.toString().trim().isEmpty)) {
        dataStart = i + 1;
      } else {
        final headerLower =
            rows[i].map((c) => c.toString().toLowerCase().trim()).join(',');
        if (headerLower.contains('date') ||
            headerLower.contains('transaction') ||
            headerLower.contains('description') ||
            headerLower.contains('amount') ||
            headerLower.contains('debit') ||
            headerLower.contains('credit') ||
            headerLower.contains('withdrawal') ||
            headerLower.contains('deposit')) {
          dataStart = i + 1;
          break;
        }
        dataStart = i + 1;
      }
    }

    for (int i = dataStart; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty ||
          row.every((c) => c.toString().trim().isEmpty)) {
        continue;
      }

      if (row.length < 2) continue;

      final cols = row.map((c) => c.toString().trim()).toList();

      String? rawDate;
      String rawDescription = '';
      String? rawDebit;
      String? rawCredit;
      String? rawAmount;
      String? rawBalance;

      int dateIdx = -1;
      int descIdx = -1;
      int amountIdx = -1;
      int debitIdx = -1;
      int creditIdx = -1;
      int balanceIdx = -1;

      for (int j = 0; j < cols.length; j++) {
        final lower = cols[j].toLowerCase();
        if (lower.contains('date') || lower.contains('txn date')) {
          dateIdx = j;
        } else if (lower.contains('description') ||
            lower.contains('narrative') ||
            lower.contains('particulars') ||
            lower.contains('details')) {
          descIdx = j;
        } else if (lower.contains('amount') &&
            !lower.contains('balance')) {
          amountIdx = j;
        } else if (lower == 'debit' ||
            lower == 'withdrawal' ||
            lower == 'debit (inr)') {
          debitIdx = j;
        } else if (lower == 'credit' ||
            lower == 'deposit' ||
            lower == 'credit (inr)') {
          creditIdx = j;
        } else if (lower.contains('balance') ||
            lower.contains('closing')) {
          balanceIdx = j;
        }
      }

      if (dateIdx >= 0) {
        rawDate = cols[dateIdx];
      }
      if (descIdx >= 0) {
        rawDescription = cols[descIdx];
      } else if (cols.length > dateIdx + 1) {
        rawDescription = cols[dateIdx + 1];
      }
      if (debitIdx >= 0) rawDebit = cols[debitIdx];
      if (creditIdx >= 0) rawCredit = cols[creditIdx];
      if (amountIdx >= 0) rawAmount = cols[amountIdx];
      if (balanceIdx >= 0) rawBalance = cols[balanceIdx];

      if (rawDate == null && rawDescription.isEmpty) continue;

      DateTime? parsedDate;
      try {
        parsedDate = _parseDate(rawDate ?? '');
      } catch (_) {}

      double? parsedAmount;
      TransactionDirection? parsedDirection;

      if (rawAmount != null && rawAmount.isNotEmpty) {
        final cleaned = rawAmount.replaceAll(RegExp(r'[^0-9.\-]'), '');
        parsedAmount = double.tryParse(cleaned);
      }

      if (rawDebit != null && rawDebit.isNotEmpty) {
        final cleaned = rawDebit.replaceAll(RegExp(r'[^0-9.\-]'), '');
        final val = double.tryParse(cleaned);
        if (val != null && val > 0) {
          parsedAmount = val;
          parsedDirection = TransactionDirection.debit;
        }
      }

      if (rawCredit != null && rawCredit.isNotEmpty) {
        final cleaned = rawCredit.replaceAll(RegExp(r'[^0-9.\-]'), '');
        final val = double.tryParse(cleaned);
        if (val != null && val > 0) {
          if (parsedAmount == null) {
            parsedAmount = val;
            parsedDirection = TransactionDirection.credit;
          } else {
            parsedDirection = TransactionDirection.debit;
          }
        }
      }

      double? parsedBalance;
      if (rawBalance != null && rawBalance.isNotEmpty) {
        final cleaned = rawBalance.replaceAll(RegExp(r'[^0-9.\-]'), '');
        parsedBalance = double.tryParse(cleaned);
      }

      drafts.add(ParsedTransactionDraft(
        rowNumber: i + 1,
        rawDate: rawDate ?? '',
        rawDescription: rawDescription,
        rawDebit: rawDebit,
        rawCredit: rawCredit,
        rawAmount: rawAmount,
        rawBalance: rawBalance,
        parsedDate: parsedDate,
        parsedAmount: parsedAmount,
        parsedDirection: parsedDirection,
        parsedBalance: parsedBalance,
        currency: currency,
      ));
    }

    return drafts;
  }

  DateTime _parseDate(String raw) {
    final cleaned = raw.trim();
    final formats = [
      'dd/MM/yyyy',
      'MM/dd/yyyy',
      'yyyy-MM-dd',
      'dd-MM-yyyy',
      'dd MMM yyyy',
      'dd MMMM yyyy',
      'MMMM dd, yyyy',
      'MMM dd, yyyy',
    ];

    for (final format in formats) {
      try {
        return _DateParser(format).parseStrict(cleaned);
      } catch (_) {}
    }

    final parts = cleaned.split(RegExp(r'[/\- ]'));
    if (parts.length >= 3) {
      final now = DateTime.now();
      int d = int.tryParse(parts[0]) ?? 1;
      int m = int.tryParse(parts[1]) ?? 1;
      int y = int.tryParse(parts[2]) ?? now.year;
      if (y < 100) y += 2000;
      return DateTime(y, m, d);
    }

    throw FormatException('Could not parse date: $raw');
  }

  @override
  Future<AgentResult<StatementParserOutput>> run(
      StatementParserInput input) async {
    final errors = <String>[];

    try {
      final file = File(input.filePath);
      if (!await file.exists()) {
        return AgentResult(
          status: AgentTaskStatus.failed,
          confidence: 0,
          explanation: 'File not found: ${input.filePath}',
        );
      }

      List<ParsedTransactionDraft> drafts;

      switch (input.fileType) {
        case 'csv':
        case 'tsv':
          drafts = _parseCsv(
              input.filePath, input.importBatchId, input.currency);
          break;
        case 'pdf':
          drafts = await _parsePdf(
              input.filePath, input.importBatchId, input.currency);
          break;
        default:
          return AgentResult(
            status: AgentTaskStatus.failed,
            confidence: 0,
            explanation: 'Unsupported file type: ${input.fileType}',
          );
      }

      final confidence = estimateConfidence(drafts);

      if (drafts.isEmpty) {
        return AgentResult(
          status: AgentTaskStatus.needsUserReview,
          output: StatementParserOutput(
            parsedDrafts: [],
            parserConfidence: 0,
            parseErrors: ['No transactions found in file'],
          ),
          confidence: 0,
          explanation: 'No transactions could be parsed from the file',
          needsReview: true,
        );
      }

      return AgentResult(
        status: AgentTaskStatus.completed,
        output: StatementParserOutput(
          parsedDrafts: drafts,
          parserConfidence: confidence,
          parseErrors: errors,
        ),
        confidence: confidence,
        explanation:
            'Parsed ${drafts.length} transactions from ${input.fileType} file',
      );
    } catch (e) {
      return AgentResult(
        status: AgentTaskStatus.failed,
        confidence: 0,
        explanation: 'Parsing error: $e',
      );
    }
  }

  Future<List<ParsedTransactionDraft>> _parsePdf(
      String filePath, String importBatchId, String currency) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    final text = utf8.decode(bytes, allowMalformed: true);

    final lines =
        text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();

    final drafts = <ParsedTransactionDraft>[];
    final datePattern = RegExp(
        r'(\d{1,2}[/\-]\d{1,2}[/\-]\d{2,4})');
    final amountPattern = RegExp(
        r'([+-]?\s*[\d,]+\.\d{2})');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final dateMatch = datePattern.firstMatch(line);
      if (dateMatch == null) continue;

      final amountMatches = amountPattern.allMatches(line).toList();
      if (amountMatches.isEmpty) continue;

      final rawDate = dateMatch.group(1)!;
      DateTime? parsedDate;
      try {
        parsedDate = _parseDate(rawDate);
      } catch (_) {}

      double? parsedAmount;
      TransactionDirection? parsedDirection;

      if (amountMatches.length == 1) {
        parsedAmount = _parseAmount(amountMatches[0].group(1)!);
      } else if (amountMatches.length >= 2) {
        final first = _parseAmount(amountMatches[0].group(1)!);
        final second = _parseAmount(amountMatches[1].group(1)!);
        if (first < 0) {
          parsedAmount = first.abs();
          parsedDirection = TransactionDirection.debit;
        } else if (second < 0) {
          parsedAmount = second.abs();
          parsedDirection = TransactionDirection.debit;
        } else {
          parsedAmount = second;
        }
      }

      final descStart = dateMatch.end;
      final descEnd = amountMatches.first.start;
      final rawDescription =
          line.substring(descStart, descEnd).trim();

      drafts.add(ParsedTransactionDraft(
        rowNumber: i + 1,
        rawDate: rawDate,
        rawDescription: rawDescription,
        parsedDate: parsedDate,
        parsedAmount: parsedAmount,
        parsedDirection: parsedDirection,
        currency: currency,
      ));
    }

    return drafts;
  }

  double _parseAmount(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'[^0-9.\-]'), '');
    return double.tryParse(cleaned) ?? 0;
  }
}

class _DateParser {
  final String pattern;
  const _DateParser(this.pattern);

  DateTime parseStrict(String input) {
    final parts = input.trim().split(RegExp(r'[/\- ]'));
    final fmtParts = pattern.split(RegExp(r'[/\- ]'));

    int d = 1, m = 1, y = 2000;

    for (int i = 0; i < fmtParts.length && i < parts.length; i++) {
      final val = int.tryParse(parts[i]) ?? 1;
      switch (fmtParts[i].toLowerCase()) {
        case 'dd':
          d = val;
          break;
        case 'mm':
          m = val;
          break;
        case 'yyyy':
          y = val;
          break;
        case 'yy':
          y = val + 2000;
          break;
        case 'mmm':
          m = _monthFromAbbr(parts[i]);
          break;
        case 'mmmm':
          m = _monthFromName(parts[i]);
          break;
      }
    }

    return DateTime(y, m, d);
  }

  int _monthFromAbbr(String abbr) {
    const months = {
      'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
      'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
    };
    return months[abbr.toLowerCase().substring(0, 3)] ?? 1;
  }

  int _monthFromName(String name) {
    const months = {
      'january': 1, 'february': 2, 'march': 3, 'april': 4, 'may': 5, 'june': 6,
      'july': 7, 'august': 8, 'september': 9, 'october': 10, 'november': 11, 'december': 12,
    };
    return months[name.toLowerCase()] ?? 1;
  }
}
