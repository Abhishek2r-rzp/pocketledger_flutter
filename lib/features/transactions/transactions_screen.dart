import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pocketledger/core/models/transaction.dart';
import 'package:pocketledger/core/models/category.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/features/transactions/transactions_provider.dart';
import 'package:pocketledger/core/theme/app_colors.dart';
import 'package:pocketledger/core/theme/glass_card.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(transactionsProvider);
    final searchQuery = ref.watch(transactionSearchProvider);
    final sortBy = ref.watch(transactionSortProvider);
    final directionFilter = ref.watch(transactionDirectionFilterProvider);
    final categories = ref.watch(dataRepositoryProvider).categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        leading: IconButton(
          icon: Container(
            width: 36,
            height: 36,
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
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search transactions...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textTertiary),
                        onPressed: () => ref.read(transactionSearchProvider.notifier).state = '',
                      )
                    : null,
                isDense: true,
              ),
              style: const TextStyle(color: AppColors.textPrimary),
              onChanged: (v) => ref.read(transactionSearchProvider.notifier).state = v,
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _GlassFilterChip(
                  label: 'All',
                  selected: directionFilter == null,
                  onSelected: () => ref.read(transactionDirectionFilterProvider.notifier).state = null,
                ),
                const SizedBox(width: 8),
                _GlassFilterChip(
                  label: 'Income',
                  selected: directionFilter == TransactionDirection.income,
                  onSelected: () => ref.read(transactionDirectionFilterProvider.notifier).state = TransactionDirection.income,
                  color: AppColors.income,
                ),
                const SizedBox(width: 8),
                _GlassFilterChip(
                  label: 'Expense',
                  selected: directionFilter == TransactionDirection.expense,
                  onSelected: () => ref.read(transactionDirectionFilterProvider.notifier).state = TransactionDirection.expense,
                  color: AppColors.expense,
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  onSelected: (v) => ref.read(transactionSortProvider.notifier).state = v,
                  color: AppColors.surface,
                  surfaceTintColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'date', child: Text('Date', style: TextStyle(color: AppColors.textPrimary))),
                    const PopupMenuItem(value: 'amount', child: Text('Amount', style: TextStyle(color: AppColors.textPrimary))),
                    const PopupMenuItem(value: 'description', child: Text('Name', style: TextStyle(color: AppColors.textPrimary))),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.cardGlass,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardGlassBorder, width: 0.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.sort, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(
                          _sortLabel(sortBy),
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: data.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: AppColors.textSecondary))),
              data: (transactions) {
                if (transactions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_rounded, size: 64, color: AppColors.textTertiary.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        const Text('No transactions found', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
                        const SizedBox(height: 8),
                        Text(
                          searchQuery.isNotEmpty
                              ? 'Try a different search term'
                              : 'Import a bank statement to get started',
                          style: const TextStyle(color: AppColors.textTertiary, fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => ref.refresh(transactionsProvider.future),
                  color: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final txn = transactions[index];
                      final cat = categories.where((c) => c.id == txn.categoryId).firstOrNull;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GlassCardSmall(
                          onTap: () => context.push('/transactions/${txn.id}'),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color(cat?.colorValue ?? 0xFF9E9E9E).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  txn.direction == TransactionDirection.income
                                      ? Icons.trending_down_rounded
                                      : Icons.trending_up_rounded,
                                  size: 18,
                                  color: Color(cat?.colorValue ?? 0xFF9E9E9E),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      txn.description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Text(
                                          _formatDate(txn.date),
                                          style: const TextStyle(color: AppColors.textTertiary, fontSize: 11),
                                        ),
                                        if (cat != null) ...[
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: Color(cat.colorValue).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              cat.name,
                                              style: TextStyle(fontSize: 9, color: Color(cat.colorValue)),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '₹${txn.amount.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: txn.direction == TransactionDirection.income
                                          ? AppColors.income
                                          : AppColors.expense,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.textTertiary),
                            ],
                          ),
                        ).animate().fadeIn(
                          duration: 300.ms,
                          delay: (index * 50).ms,
                          curve: Curves.easeOutCubic,
                        ).slideY(
                          begin: 0.05,
                          end: 0,
                          duration: 300.ms,
                          delay: (index * 50).ms,
                          curve: Curves.easeOutCubic,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _sortLabel(String sortBy) {
    switch (sortBy) {
      case 'date':
        return 'Date';
      case 'amount':
        return 'Amount';
      case 'description':
        return 'Name';
      default:
        return 'Date';
    }
  }
}

class _GlassFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final Color? color;

  const _GlassFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? (color ?? AppColors.primary).withOpacity(0.15)
              : AppColors.cardGlass,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? (color ?? AppColors.primary).withOpacity(0.3)
                : AppColors.cardGlassBorder,
            width: selected ? 1.0 : 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? (color ?? AppColors.primary) : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
