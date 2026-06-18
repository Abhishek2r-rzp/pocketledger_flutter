import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pocketledger/core/models/transaction.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/features/transactions/transaction_detail_provider.dart';

class TransactionDetailScreen extends ConsumerWidget {
  final String? transactionId;

  const TransactionDetailScreen({super.key, this.transactionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionDetailProvider(transactionId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(transactionId == null ? 'New Transaction' : 'Edit Transaction'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: transactionId != null
                ? () => _confirmDelete(context, ref)
                : null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DateField(
              date: state.date,
              onChanged: (d) => ref.read(transactionDetailProvider(transactionId).notifier).updateDate(d),
              theme: theme,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Merchant'),
              controller: TextEditingController(text: state.merchantName ?? '')
                ..selection = TextSelection.collapsed(offset: (state.merchantName ?? '').length),
              onChanged: (v) => ref.read(transactionDetailProvider(transactionId).notifier).updateMerchantName(v),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              controller: TextEditingController(text: state.description)
                ..selection = TextSelection.collapsed(offset: state.description.length),
              onChanged: (v) => ref.read(transactionDetailProvider(transactionId).notifier).updateDescription(v),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Amount'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    controller: TextEditingController(text: state.amount.toStringAsFixed(2))
                      ..selection = TextSelection.collapsed(offset: state.amount.toStringAsFixed(2).length),
                    onChanged: (v) {
                      final amount = double.tryParse(v);
                      if (amount != null) {
                        ref.read(transactionDetailProvider(transactionId).notifier).updateAmount(amount);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<TransactionDirection>(
                    value: state.direction,
                    decoration: const InputDecoration(labelText: 'Direction'),
                    items: TransactionDirection.values.map((d) => DropdownMenuItem(
                          value: d,
                          child: Row(
                            children: [
                              Icon(
                                d == TransactionDirection.income ? Icons.arrow_downward : Icons.arrow_upward,
                                size: 16,
                                color: d == TransactionDirection.income ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                              ),
                              const SizedBox(width: 8),
                              Text(d == TransactionDirection.income ? 'Income' : 'Expense'),
                            ],
                          ),
                        )).toList(),
                    onChanged: (v) {
                      if (v != null) {
                        ref.read(transactionDetailProvider(transactionId).notifier).updateDirection(v);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: state.categoryId,
              decoration: const InputDecoration(labelText: 'Category'),
              items: ref.read(dataRepositoryProvider).categories.map((c) => DropdownMenuItem(
                    value: c.id,
                    child: Row(
                      children: [
                        Icon(Icons.circle, size: 12, color: Color(c.colorValue)),
                        const SizedBox(width: 8),
                        Text(c.name),
                      ],
                    ),
                  )).toList(),
              onChanged: (v) {
                final cat = ref.read(dataRepositoryProvider).categories.where((c) => c.id == v).firstOrNull;
                ref.read(transactionDetailProvider(transactionId).notifier).updateCategory(v, cat?.name);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 3,
              controller: TextEditingController(text: state.notes ?? '')
                ..selection = TextSelection.collapsed(offset: (state.notes ?? '').length),
              onChanged: (v) => ref.read(transactionDetailProvider(transactionId).notifier).updateNotes(v),
            ),
            const SizedBox(height: 16),
            _TagsField(
              tags: state.tags,
              onAdd: (tag) => ref.read(transactionDetailProvider(transactionId).notifier).addTag(tag),
              onRemove: (tag) => ref.read(transactionDetailProvider(transactionId).notifier).removeTag(tag),
              theme: theme,
            ),
            if (state.rawDescription != null) ...[
              const SizedBox(height: 16),
              Card(
                color: theme.colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Raw Description', style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      )),
                      const SizedBox(height: 4),
                      Text(state.rawDescription!, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
            ],
            if (state.categorizationExplanation != null) ...[
              const SizedBox(height: 16),
              Card(
                color: theme.colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Categorization', style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                      )),
                      const SizedBox(height: 4),
                      Text(state.categorizationExplanation!, style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                      )),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () async {
                await ref.read(transactionDetailProvider(transactionId).notifier).save();
                if (context.mounted) context.pop();
              },
              child: const Text('Save'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              ref.read(transactionDetailProvider(transactionId).notifier).delete();
              Navigator.pop(ctx);
              context.pop();
            },
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;
  final ThemeData theme;

  const _DateField({required this.date, required this.onChanged, required this.theme});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2010),
          lastDate: DateTime(2030),
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: const InputDecoration(labelText: 'Date'),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 16),
            const SizedBox(width: 8),
            Text(DateFormat('dd MMM yyyy').format(date)),
          ],
        ),
      ),
    );
  }
}

class _TagsField extends StatelessWidget {
  final List<String> tags;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;
  final ThemeData theme;

  const _TagsField({
    required this.tags,
    required this.onAdd,
    required this.onRemove,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tags', style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        )),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            ...tags.map((tag) => Chip(
                  label: Text(tag, style: const TextStyle(fontSize: 12)),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => onRemove(tag),
                  visualDensity: VisualDensity.compact,
                )),
            ActionChip(
              label: const Text('+ Add', style: TextStyle(fontSize: 12)),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    final controller = TextEditingController();
                    return AlertDialog(
                      title: const Text('Add Tag'),
                      content: TextField(
                        controller: controller,
                        decoration: const InputDecoration(hintText: 'Enter tag name'),
                        autofocus: true,
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                        FilledButton(
                          onPressed: () {
                            if (controller.text.trim().isNotEmpty) {
                              onAdd(controller.text.trim());
                              Navigator.pop(ctx);
                            }
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ],
    );
  }
}
