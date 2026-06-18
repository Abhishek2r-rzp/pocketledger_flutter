import 'package:flutter_riverpod/legacy.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/core/repository.dart';
import 'package:pocketledger/core/models/transaction.dart';
import 'package:uuid/uuid.dart';

class TransactionEditor {
  final String? id;
  final DateTime date;
  final String description;
  final String? merchantName;
  final double amount;
  final TransactionDirection direction;
  final String? categoryId;
  final String? categoryName;
  final String? notes;
  final List<String> tags;
  final String? rawDescription;
  final String? categorizationExplanation;

  const TransactionEditor({
    this.id,
    required this.date,
    required this.description,
    this.merchantName,
    required this.amount,
    required this.direction,
    this.categoryId,
    this.categoryName,
    this.notes,
    this.tags = const [],
    this.rawDescription,
    this.categorizationExplanation,
  });
}

class TransactionDetailNotifier extends StateNotifier<TransactionEditor> {
  final Repository _repo;
  final String? _transactionId;
  final _uuid = const Uuid();

  TransactionDetailNotifier(this._repo, this._transactionId)
      : super(_buildInitial(_repo, _transactionId));

  static TransactionEditor _buildInitial(Repository repo, String? id) {
    if (id == null) {
      return TransactionEditor(
        date: DateTime.now(),
        description: '',
        amount: 0,
        direction: TransactionDirection.expense,
      );
    }
    final txn = repo.getTransaction(id);
    if (txn == null) {
      return TransactionEditor(
        date: DateTime.now(),
        description: '',
        amount: 0,
        direction: TransactionDirection.expense,
      );
    }
    return TransactionEditor(
      id: txn.id,
      date: txn.date,
      description: txn.description,
      merchantName: txn.merchantName,
      amount: txn.amount,
      direction: txn.direction,
      categoryId: txn.categoryId,
      categoryName: txn.categoryName,
      notes: txn.notes,
      tags: List.from(txn.tags),
      rawDescription: txn.rawDescription,
      categorizationExplanation: txn.categorizationExplanation,
    );
  }

  void updateDate(DateTime d) => state = TransactionEditor(
        id: state.id, date: d, description: state.description,
        merchantName: state.merchantName, amount: state.amount,
        direction: state.direction, categoryId: state.categoryId,
        categoryName: state.categoryName, notes: state.notes,
        tags: state.tags, rawDescription: state.rawDescription,
        categorizationExplanation: state.categorizationExplanation,
      );

  void updateDescription(String v) => state = TransactionEditor(
        id: state.id, date: state.date, description: v,
        merchantName: state.merchantName, amount: state.amount,
        direction: state.direction, categoryId: state.categoryId,
        categoryName: state.categoryName, notes: state.notes,
        tags: state.tags, rawDescription: state.rawDescription,
        categorizationExplanation: state.categorizationExplanation,
      );

  void updateMerchantName(String? v) => state = TransactionEditor(
        id: state.id, date: state.date, description: state.description,
        merchantName: v, amount: state.amount, direction: state.direction,
        categoryId: state.categoryId, categoryName: state.categoryName,
        notes: state.notes, tags: state.tags, rawDescription: state.rawDescription,
        categorizationExplanation: state.categorizationExplanation,
      );

  void updateAmount(double v) => state = TransactionEditor(
        id: state.id, date: state.date, description: state.description,
        merchantName: state.merchantName, amount: v, direction: state.direction,
        categoryId: state.categoryId, categoryName: state.categoryName,
        notes: state.notes, tags: state.tags, rawDescription: state.rawDescription,
        categorizationExplanation: state.categorizationExplanation,
      );

  void updateDirection(TransactionDirection v) => state = TransactionEditor(
        id: state.id, date: state.date, description: state.description,
        merchantName: state.merchantName, amount: state.amount, direction: v,
        categoryId: state.categoryId, categoryName: state.categoryName,
        notes: state.notes, tags: state.tags, rawDescription: state.rawDescription,
        categorizationExplanation: state.categorizationExplanation,
      );

  void updateCategory(String? id, String? name) => state = TransactionEditor(
        id: state.id, date: state.date, description: state.description,
        merchantName: state.merchantName, amount: state.amount,
        direction: state.direction, categoryId: id, categoryName: name,
        notes: state.notes, tags: state.tags, rawDescription: state.rawDescription,
        categorizationExplanation: state.categorizationExplanation,
      );

  void updateNotes(String? v) => state = TransactionEditor(
        id: state.id, date: state.date, description: state.description,
        merchantName: state.merchantName, amount: state.amount,
        direction: state.direction, categoryId: state.categoryId,
        categoryName: state.categoryName, notes: v, tags: state.tags,
        rawDescription: state.rawDescription,
        categorizationExplanation: state.categorizationExplanation,
      );

  void addTag(String tag) {
    if (state.tags.contains(tag)) return;
    state = TransactionEditor(
      id: state.id, date: state.date, description: state.description,
      merchantName: state.merchantName, amount: state.amount,
      direction: state.direction, categoryId: state.categoryId,
      categoryName: state.categoryName, notes: state.notes,
      tags: [...state.tags, tag], rawDescription: state.rawDescription,
      categorizationExplanation: state.categorizationExplanation,
    );
  }

  void removeTag(String tag) => state = TransactionEditor(
        id: state.id, date: state.date, description: state.description,
        merchantName: state.merchantName, amount: state.amount,
        direction: state.direction, categoryId: state.categoryId,
        categoryName: state.categoryName, notes: state.notes,
        tags: state.tags.where((t) => t != tag).toList(),
        rawDescription: state.rawDescription,
        categorizationExplanation: state.categorizationExplanation,
      );

  Future<void> save() async {
    if (state.id != null) {
      final existing = _repo.getTransaction(state.id!);
      if (existing != null) {
        _repo.updateTransaction(existing.copyWith(
          date: state.date,
          description: state.description,
          merchantName: state.merchantName,
          amount: state.amount,
          direction: state.direction,
          categoryId: state.categoryId,
          categoryName: state.categoryName,
          notes: state.notes,
          tags: state.tags,
        ));
      }
    } else {
      _repo.addTransaction(Transaction(
        id: _uuid.v4(),
        date: state.date,
        description: state.description,
        merchantName: state.merchantName,
        amount: state.amount,
        direction: state.direction,
        categoryId: state.categoryId,
        categoryName: state.categoryName,
        notes: state.notes,
        tags: state.tags,
        balance: null,
        currency: 'INR',
        fingerprint: 'manual_${_uuid.v4()}',
        importBatchId: 'manual',
        createdAt: DateTime.now(),
      ));
    }
  }

  void delete() {
    if (state.id != null) {
      _repo.deleteTransaction(state.id!);
    }
  }
}

final transactionDetailProvider = StateNotifierProvider.family<TransactionDetailNotifier, TransactionEditor, String?>((ref, id) {
  final repo = ref.watch(dataRepositoryProvider);
  return TransactionDetailNotifier(repo, id);
});
