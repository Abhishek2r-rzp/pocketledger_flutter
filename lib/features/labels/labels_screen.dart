import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/core/models/transaction_label.dart';
import 'package:pocketledger/core/theme/app_colors.dart';
import 'package:pocketledger/core/theme/glass_card.dart';

class LabelsScreen extends ConsumerWidget {
  const LabelsScreen({super.key});

  static const _presetColors = [
    0xFF7C5CFC, 0xFF00D4AA, 0xFFFF4757, 0xFFF77F00,
    0xFF60A5FA, 0xFFEC4899, 0xFF8B5CF6, 0xFF14B8A6,
    0xFFF59E0B, 0xFF10B981, 0xFF6366F1, 0xFFEF4444,
    0xFF06B6D4, 0xFF84CC16, 0xFFD946EF, 0xFF22C55E,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(dataRepositoryProvider);
    final labels = repo.labels;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Labels'),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showLabelDialog(context, ref, null),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Add Label'),
      ),
      body: labels.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.label_outline, size: 64, color: AppColors.textTertiary.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  const Text('No labels yet', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('Create labels to organize your transactions', style: TextStyle(color: AppColors.textTertiary, fontSize: 13)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              itemCount: labels.length,
              itemBuilder: (context, index) {
                final label = labels[index];
                final txnCount = repo.transactions.where((t) => t.labelIds.contains(label.id)).length;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GlassCard.premium(
                    padding: const EdgeInsets.all(12),
                    borderRadius: 16,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: Color(label.color).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.label, size: 22, color: Color(label.color)),
                      ),
                      title: Text(label.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500, fontSize: 14)),
                      subtitle: Text('$txnCount transaction(s)', style: const TextStyle(color: AppColors.textTertiary, fontSize: 11)),
                      trailing: PopupMenuButton<String>(
                        onSelected: (v) {
                          if (v == 'edit') _showLabelDialog(context, ref, label);
                          if (v == 'delete') _confirmDelete(context, ref, label);
                        },
                        color: AppColors.surface,
                        surfaceTintColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        itemBuilder: (_) => [
                          const PopupMenuItem(value: 'edit', child: ListTile(
                            leading: Icon(Icons.edit, size: 18, color: AppColors.textPrimary),
                            title: Text('Edit', style: TextStyle(color: AppColors.textPrimary, fontSize: 13)),
                            dense: true, contentPadding: EdgeInsets.zero,
                          )),
                          const PopupMenuItem(value: 'delete', child: ListTile(
                            leading: Icon(Icons.delete, size: 18, color: AppColors.expense),
                            title: Text('Delete', style: TextStyle(color: AppColors.expense, fontSize: 13)),
                            dense: true, contentPadding: EdgeInsets.zero,
                          )),
                        ],
                        icon: const Icon(Icons.more_horiz, color: AppColors.textTertiary, size: 20),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showLabelDialog(BuildContext context, WidgetRef ref, TransactionLabel? existing) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    int selectedColor = existing?.color ?? _presetColors[0];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(existing != null ? 'Edit Label' : 'Add Label', style: const TextStyle(color: AppColors.textPrimary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Label Name',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  prefixIcon: Icon(Icons.label, color: AppColors.textTertiary),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  filled: true, fillColor: AppColors.cardGlass,
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Color', style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: _presetColors.map((c) => GestureDetector(
                  onTap: () => setDialogState(() => selectedColor = c),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: Color(c),
                      borderRadius: BorderRadius.circular(10),
                      border: selectedColor == c
                          ? Border.all(color: AppColors.textPrimary, width: 2.5)
                          : null,
                      boxShadow: selectedColor == c
                          ? [BoxShadow(color: Color(c).withOpacity(0.5), blurRadius: 8, spreadRadius: 1)]
                          : null,
                    ),
                  ),
                )).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) return;
                final uuid = const Uuid();
                if (existing != null) {
                  ref.read(dataRepositoryProvider).updateLabel(existing.copyWith(
                    name: name, color: selectedColor,
                  ));
                } else {
                  ref.read(dataRepositoryProvider).addLabel(TransactionLabel(
                    id: uuid.v4(), name: name, color: selectedColor,
                  ));
                }
                Navigator.pop(ctx);
              },
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              child: Text(existing != null ? 'Save' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, TransactionLabel label) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Delete Label', style: TextStyle(color: AppColors.textPrimary)),
        content: Text('Delete "${label.name}"? Transactions with this label will not be deleted.', style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              ref.read(dataRepositoryProvider).deleteLabel(label.id);
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.expense),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
