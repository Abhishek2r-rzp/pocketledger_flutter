import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/core/models/transaction.dart';
import 'package:pocketledger/services/search_service.dart';
import 'package:pocketledger/core/theme/app_colors.dart';
import 'package:pocketledger/core/theme/glass_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchCtrl = TextEditingController();
  final _searchService = SearchService();

  DateTime? _dateFrom;
  DateTime? _dateTo;
  double? _amountMin;
  double? _amountMax;
  String? _categoryId;
  TransactionDirection? _direction;
  List<String> _selectedLabelIds = [];

  List<Transaction> _results = [];

  void _runSearch() {
    final repo = ref.read(dataRepositoryProvider);
    var txns = repo.transactions;

    if (_searchCtrl.text.trim().isNotEmpty) {
      txns = _searchService.search(txns, _searchCtrl.text);
    }

    txns = _searchService.filter(txns,
      categoryId: _categoryId,
      direction: _direction,
      dateFrom: _dateFrom,
      dateTo: _dateTo,
    );

    if (_amountMin != null) {
      txns = txns.where((t) => t.amount >= _amountMin!).toList();
    }
    if (_amountMax != null) {
      txns = txns.where((t) => t.amount <= _amountMax!).toList();
    }
    if (_selectedLabelIds.isNotEmpty) {
      txns = txns.where((t) => t.labelIds.any((id) => _selectedLabelIds.contains(id))).toList();
    }

    setState(() => _results = txns);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(dataRepositoryProvider);
    final categories = repo.categories;
    final labels = repo.labels;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search & Filter'),
        leading: IconButton(
          icon: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppColors.cardGlass,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardGlassBorder, width: 0.5),
            ),
            child: const Icon(Icons.arrow_back_rounded, size: 20),
          ),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search descriptions, merchants...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.clear, color: AppColors.textTertiary), onPressed: () { _searchCtrl.clear(); _runSearch(); })
                    : null,
                isDense: true,
              ),
              style: const TextStyle(color: AppColors.textPrimary),
              onChanged: (_) => _runSearch(),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [
                GlassCard.premium(
                  padding: const EdgeInsets.all(12),
                  borderRadius: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Date Range', style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _datePickerBtn('From', _dateFrom, (d) => setState(() { _dateFrom = d; _runSearch(); })),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _datePickerBtn('To', _dateTo, (d) => setState(() { _dateTo = d; _runSearch(); })),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                GlassCard.premium(
                  padding: const EdgeInsets.all(12),
                  borderRadius: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Amount Range', style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Min',
                                prefixText: '₹ ',
                                isDense: true,
                                border: OutlineInputBorder(borderSide: BorderSide.none),
                                filled: true, fillColor: AppColors.cardGlass,
                              ),
                              style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                              keyboardType: TextInputType.number,
                              onChanged: (v) { _amountMin = double.tryParse(v); _runSearch(); },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Max',
                                prefixText: '₹ ',
                                isDense: true,
                                border: OutlineInputBorder(borderSide: BorderSide.none),
                                filled: true, fillColor: AppColors.cardGlass,
                              ),
                              style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                              keyboardType: TextInputType.number,
                              onChanged: (v) { _amountMax = double.tryParse(v); _runSearch(); },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                GlassCard.premium(
                  padding: const EdgeInsets.all(12),
                  borderRadius: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Direction', style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _filterChip('All', _direction == null, () { setState(() => _direction = null); _runSearch(); }),
                          const SizedBox(width: 6),
                          _filterChip('Income', _direction == TransactionDirection.income, () { setState(() => _direction = TransactionDirection.income); _runSearch(); }, color: AppColors.income),
                          const SizedBox(width: 6),
                          _filterChip('Expense', _direction == TransactionDirection.expense, () { setState(() => _direction = TransactionDirection.expense); _runSearch(); }, color: AppColors.expense),
                        ],
                      ),
                    ],
                  ),
                ),
                if (categories.length > 1) ...[
                  const SizedBox(height: 8),
                  GlassCard.premium(
                    padding: const EdgeInsets.all(12),
                    borderRadius: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Category', style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _filterChip('All', _categoryId == null, () { setState(() => _categoryId = null); _runSearch(); }),
                              const SizedBox(width: 6),
                              ...categories.where((c) => !c.isSystem || c.id == 'uncategorized').map((c) => Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: _filterChip(c.name, _categoryId == c.id, () { setState(() => _categoryId = c.id); _runSearch(); }, color: Color(c.colorValue)),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (labels.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  GlassCard.premium(
                    padding: const EdgeInsets.all(12),
                    borderRadius: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Labels', style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: labels.map((l) => _filterChip(
                            l.name,
                            _selectedLabelIds.contains(l.id),
                            () {
                              setState(() {
                                if (_selectedLabelIds.contains(l.id)) {
                                  _selectedLabelIds.remove(l.id);
                                } else {
                                  _selectedLabelIds.add(l.id);
                                }
                              });
                              _runSearch();
                            },
                            color: Color(l.color),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                if (_results.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('${_results.length} result(s)', style: const TextStyle(color: AppColors.textTertiary, fontSize: 13)),
                  ),
                ..._results.map((txn) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: GlassCardSmall(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: (txn.direction == TransactionDirection.income ? AppColors.income : AppColors.expense).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(txn.direction == TransactionDirection.income ? Icons.arrow_downward : Icons.arrow_upward, size: 16, color: txn.direction == TransactionDirection.income ? AppColors.income : AppColors.expense),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(txn.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
                                Text(_formatDate(txn.date), style: const TextStyle(color: AppColors.textTertiary, fontSize: 10)),
                              ],
                            ),
                          ),
                          Text(
                            '${txn.direction == TransactionDirection.expense ? '-' : ''}₹${txn.amount.toStringAsFixed(0)}',
                            style: TextStyle(color: txn.direction == TransactionDirection.income ? AppColors.income : AppColors.expense, fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
                if (_results.isEmpty && _hasFilters)
                  const Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: Center(child: Text('No matching transactions', style: TextStyle(color: AppColors.textTertiary, fontSize: 14))),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool get _hasFilters =>
      _searchCtrl.text.isNotEmpty ||
      _dateFrom != null ||
      _dateTo != null ||
      _amountMin != null ||
      _amountMax != null ||
      _categoryId != null ||
      _direction != null ||
      _selectedLabelIds.isNotEmpty;

  String _formatDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Widget _datePickerBtn(String label, DateTime? value, ValueChanged<DateTime?> onPicked) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          builder: (ctx, child) => Theme(data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(primary: AppColors.primary, surface: AppColors.surface),
          ), child: child!),
        );
        if (picked != null) onPicked(picked);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: AppColors.cardGlass, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 14, color: AppColors.textTertiary),
            const SizedBox(width: 6),
            Text(value != null ? _formatDate(value) : label, style: TextStyle(color: value != null ? AppColors.textPrimary : AppColors.textTertiary, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, bool selected, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? (color ?? AppColors.primary).withOpacity(0.2) : AppColors.cardGlass,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? (color ?? AppColors.primary).withOpacity(0.4) : AppColors.cardGlassBorder, width: 0.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? (color ?? AppColors.primary) : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
