import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pocketledger/core/models/import_batch.dart';
import 'package:pocketledger/features/import_history/import_history_provider.dart';

class ImportHistoryScreen extends ConsumerWidget {
  const ImportHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(importHistoryProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Import History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (batches) {
          if (batches.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64,
                      color: theme.colorScheme.outline.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text('No import history', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Import a bank statement to see history here',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6))),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: batches.length,
            itemBuilder: (context, index) {
              final batch = batches[index];
              return Dismissible(
                key: Key(batch.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) async {
                  return await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Import Record'),
                      content: Text('Delete import record for ${batch.fileName}?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          style: FilledButton.styleFrom(
                            backgroundColor: theme.colorScheme.error,
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (_) {
                  ref.read(importHistoryProvider.notifier).deleteBatch(batch.id);
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                            Icon(
                              Icons.check_circle,
                              size: 20,
                              color: const Color(0xFF4CAF50),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    batch.fileName,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    DateFormat('dd MMM yyyy, hh:mm a').format(batch.createdAt),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatBadge(
                              icon: Icons.receipt,
                              label: 'Total',
                              value: '${batch.totalRows}',
                              theme: theme,
                            ),
                            _StatBadge(
                              icon: Icons.add_circle_outline,
                              label: 'Imported',
                              value: '${batch.importedRows}',
                              color: const Color(0xFF4CAF50),
                              theme: theme,
                            ),
                            _StatBadge(
                              icon: Icons.content_copy,
                              label: 'Duplicates',
                              value: '${batch.duplicateRows}',
                              color: const Color(0xFFFF9800),
                              theme: theme,
                            ),
                            _StatBadge(
                              icon: Icons.error_outline,
                              label: 'Failed',
                              value: '${batch.failedRows}',
                              color: const Color(0xFFF44336),
                              theme: theme,
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
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;
  final ThemeData theme;

  const _StatBadge({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 16, color: color ?? theme.colorScheme.onSurface.withOpacity(0.6)),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        Text(label, style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        )),
      ],
    );
  }
}
