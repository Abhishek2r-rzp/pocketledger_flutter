import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketledger/core/models/budget.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/features/budgets/budgets_provider.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(budgetsProvider);
    final categories = ref.watch(dataRepositoryProvider).categories;
    final notifier = ref.read(budgetsProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (budgets) {
          if (budgets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_wallet_outlined, size: 64,
                      color: theme.colorScheme.outline.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text('No budgets set', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Add a budget to track your spending',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6))),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => _showAddBudgetSheet(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Budget'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              final budget = budgets[index];
              final cat = categories.where((c) => c.id == budget.categoryId).firstOrNull;
              final spent = notifier.spentForBudget(budget);
              final progress = budget.amount > 0 ? (spent / budget.amount) : 0.0;
              final progressColor = progress < 0.8
                  ? const Color(0xFF4CAF50)
                  : progress < 1.0
                      ? const Color(0xFFFF9800)
                      : const Color(0xFFF44336);

              return Dismissible(
                key: Key(budget.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) async {
                  return await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Budget'),
                      content: Text('Delete budget for ${budget.categoryName}?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                        FilledButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.error),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (_) => ref.read(budgetsProvider.notifier).deleteBudget(budget.id),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  decoration: BoxDecoration(color: theme.colorScheme.error, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 12, height: 12,
                              decoration: BoxDecoration(
                                color: Color(cat?.colorValue ?? 0xFF9E9E9E),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                budget.categoryName,
                                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              '₹${spent.toStringAsFixed(0)} / ₹${budget.amount.toStringAsFixed(0)}',
                              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            backgroundColor: progressColor.withOpacity(0.15),
                            color: progressColor,
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${(progress * 100).toStringAsFixed(0)}% used',
                              style: TextStyle(fontSize: 12, color: progressColor, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '₹${(budget.amount - spent).toStringAsFixed(0)} remaining',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBudgetSheet(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddBudgetSheet(BuildContext context, WidgetRef ref) {
    final categories = ref.read(dataRepositoryProvider).categories;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        String? selectedCategoryId;
        String? selectedCategoryName;
        final amountController = TextEditingController();
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Add Budget', style: Theme.of(ctx).textTheme.titleMedium),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Category'),
                items: categories.map((c) => DropdownMenuItem(
                      value: c.id,
                      child: Row(children: [
                        Icon(Icons.circle, size: 12, color: Color(c.colorValue)),
                        const SizedBox(width: 8),
                        Text(c.name),
                      ]),
                    )).toList(),
                onChanged: (v) {
                  selectedCategoryId = v;
                  selectedCategoryName = categories.where((c) => c.id == v).firstOrNull?.name;
                },
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(labelText: 'Monthly Budget'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                controller: amountController,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  if (selectedCategoryId != null && amountController.text.isNotEmpty) {
                    final amount = double.tryParse(amountController.text);
                    if (amount != null && amount > 0) {
                      ref.read(budgetsProvider.notifier).addBudget(
                        selectedCategoryId!,
                        selectedCategoryName ?? 'Unknown',
                        amount,
                      );
                      Navigator.pop(ctx);
                    }
                  }
                },
                child: const Text('Create Budget'),
              ),
            ],
          ),
        );
      },
    );
  }
}
