import 'dart:io';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/core/repository.dart';
import 'package:pocketledger/core/models/parsed_transaction_draft.dart';
import 'package:pocketledger/core/models/import_batch.dart';
import 'package:pocketledger/core/models/transaction.dart';
import 'package:pocketledger/core/models/review_item.dart';
import 'package:pocketledger/core/models/enums.dart';
import 'package:pocketledger/parsers/csv_parser.dart';
import 'package:pocketledger/parsers/pdf_parser.dart';

sealed class ImportState {
  const ImportState();
}

class ImportIdle extends ImportState {
  const ImportIdle();
}

class ImportProcessing extends ImportState {
  final String fileName;
  const ImportProcessing(this.fileName);
}

class ImportPreview extends ImportState {
  final String fileName;
  final int totalCount;
  final int newCount;
  final int duplicateCount;
  final int needsReviewCount;
  final Map<String, int> categoryDistribution;

  const ImportPreview({
    required this.fileName,
    required this.totalCount,
    required this.newCount,
    required this.duplicateCount,
    required this.needsReviewCount,
    required this.categoryDistribution,
  });
}

class ImportError extends ImportState {
  final String message;
  const ImportError(this.message);
}

class ImportSuccess extends ImportState {
  final int count;
  const ImportSuccess(this.count);
}

class ImportNeedsPassword extends ImportState {
  final String fileName;
  final String fileType;
  final String? message;
  const ImportNeedsPassword(
    this.fileName, {
    required this.fileType,
    this.message,
  });
}

class ImportNotifier extends StateNotifier<ImportState> {
  final Repository _repo;
  final _uuid = const Uuid();

  String? _currentFilePath;
  String? _currentFileName;
  List<ParsedTransactionDraft>? _drafts;

  ImportNotifier(this._repo) : super(const ImportIdle());

  Future<void> processFile(String filePath, String fileName) async {
    state = ImportProcessing(fileName);
    _currentFilePath = filePath;
    _currentFileName = fileName;
    _drafts = null;

    try {
      List<ParsedTransactionDraft> drafts;
      final normalizedPath = filePath.toLowerCase();
      final normalizedName = fileName.toLowerCase();

      if (normalizedPath.endsWith('.csv') || normalizedName.endsWith('.csv')) {
        final file = File(filePath);
        final content = await file.readAsString();
        drafts = CSVParser().parse(content);
      } else if (normalizedPath.endsWith('.pdf') ||
          normalizedName.endsWith('.pdf')) {
        try {
          drafts = await PDFParser().parse(filePath);
        } on PdfPasswordRequiredException {
          state = ImportNeedsPassword(fileName, fileType: 'pdf');
          return;
        }
      } else {
        state = const ImportError(
            'Unsupported file format. Please use CSV or PDF.');
        return;
      }

      if (drafts.isEmpty) {
        state = const ImportError(
            'No transactions found in the file. Please check the format.');
        return;
      }

      _drafts = drafts;
      _showPreview();
    } catch (e) {
      state = ImportError('Failed to parse file: ${e.toString()}');
    }
  }

  Future<void> processPdfWithPassword(String password) async {
    if (_currentFilePath == null) return;
    final normalizedPassword = password.trim();
    if (normalizedPassword.isEmpty) {
      state = ImportNeedsPassword(
        _currentFileName ?? '',
        fileType: 'pdf',
        message: 'Enter the PDF password to continue.',
      );
      return;
    }

    state = ImportProcessing(_currentFileName ?? '');
    try {
      final drafts = await PDFParser().parse(
        _currentFilePath!,
        password: normalizedPassword,
      );
      if (drafts.isEmpty) {
        state = const ImportError(
          'No transactions found in the PDF. Please check the password and file format.',
        );
        return;
      }
      _drafts = drafts;
      _showPreview();
    } on PdfPasswordRequiredException {
      state = ImportNeedsPassword(
        _currentFileName ?? '',
        fileType: 'pdf',
        message: 'That password did not unlock the PDF. Try again.',
      );
    } catch (e) {
      state = ImportError('Failed to parse PDF: ${e.toString()}');
    }
  }

  void _showPreview() {
    if (_drafts == null) return;

    final existingTransactions = _repo.transactions;
    final existingDescriptions =
        existingTransactions.map((t) => t.description.toLowerCase()).toSet();

    int newCount = 0;
    int duplicateCount = 0;

    for (final draft in _drafts!) {
      final desc = draft.description?.toLowerCase() ?? '';
      final isDuplicate =
          existingDescriptions.contains(desc) && draft.resolvedAmount > 0;
      if (isDuplicate) {
        duplicateCount++;
      } else {
        newCount++;
      }
    }

    state = ImportPreview(
      fileName: _currentFileName ?? '',
      totalCount: _drafts!.length,
      newCount: newCount,
      duplicateCount: duplicateCount,
      needsReviewCount: _drafts!.length,
      categoryDistribution: {'uncategorized': _drafts!.length},
    );
  }

  Future<void> confirm() async {
    if (_drafts == null || _currentFileName == null) return;

    final batchId = _uuid.v4();
    int newCount = 0;

    final existingTransactions = _repo.transactions;
    final existingDescriptions =
        existingTransactions.map((t) => t.description.toLowerCase()).toSet();

    for (final draft in _drafts!) {
      final desc = draft.description?.toLowerCase() ?? '';
      if (existingDescriptions.contains(desc) && draft.resolvedAmount > 0) {
        continue;
      }

      final txn = Transaction(
        id: _uuid.v4(),
        date: draft.date ?? DateTime.now(),
        amount: draft.resolvedAmount.abs(),
        direction: draft.resolvedDirection,
        description: draft.description ?? 'Unknown',
        merchantName: null,
        categoryId: null,
        categoryName: null,
        balance: draft.balance,
        currency: 'INR',
        fingerprint: 'import_${batchId}_$newCount',
        importBatchId: batchId,
        notes: null,
        tags: [],
        confidence: draft.confidence,
        needsReview: true,
        rawDescription: draft.rawDescription,
        createdAt: DateTime.now(),
      );

      _repo.addTransaction(txn);
      newCount++;

      _repo.addReviewItem(ReviewItem(
        id: _uuid.v4(),
        transactionId: txn.id,
        reason: ReviewReason.lowConfidence,
        suggestedCategoryId: null,
        suggestedCategoryName: null,
        suggestedMerchant: null,
        confidence: draft.confidence,
        explanation: 'Newly imported transaction needs review.',
        createdAt: DateTime.now(),
      ));
    }

    _repo.addImportBatch(ImportBatch(
      id: batchId,
      fileName: _currentFileName!,
      fileType: switch (_currentFileName!) {
        final n when n.toLowerCase().endsWith('.csv') => 'csv',
        final n when n.toLowerCase().endsWith('.pdf') => 'pdf',
        _ => 'unknown',
      },
      filePath: _currentFilePath ?? '',
      totalRows: _drafts!.length,
      importedRows: newCount,
      duplicateRows: _drafts!.length - newCount,
      failedRows: 0,
      createdAt: DateTime.now(),
    ));

    state = ImportSuccess(newCount);
  }

  void cancel() {
    _drafts = null;
    _currentFilePath = null;
    _currentFileName = null;
    state = const ImportIdle();
  }

  void reset() {
    _drafts = null;
    _currentFilePath = null;
    _currentFileName = null;
    state = const ImportIdle();
  }
}

final importProvider =
    StateNotifierProvider<ImportNotifier, ImportState>((ref) {
  final repo = ref.watch(dataRepositoryProvider);
  return ImportNotifier(repo);
});
