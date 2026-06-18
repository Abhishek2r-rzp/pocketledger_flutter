import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketledger/core/models/review_item.dart';
import 'package:pocketledger/core/models/enums.dart';
import 'package:pocketledger/core/models/transaction.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/core/repository.dart';
import 'package:pocketledger/features/review_queue/review_queue_provider.dart';

class ReviewQueueScreen extends ConsumerWidget {
  const ReviewQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(reviewQueueProvider);
    final filter = ref.watch(reviewFilterProvider);
    final repo = ref.watch(dataRepositoryProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Queue'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 64, color: theme.colorScheme.primary),
                  const SizedBox(height: 16),
                  Text('All caught up!', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('No items need review', style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  )),
                ],
              ),
            );
          }

          return Column(
            children: [
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: const Text('All'),
                        selected: filter == null,
                        onSelected: (_) => ref.read(reviewFilterProvider.notifier).state = null,
                      ),
                    ),
                    ...ReviewReason.values.map((reason) {
                      final label = _reasonLabel(reason);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(label),
                          selected: filter == reason,
                          onSelected: (_) => ref.read(reviewFilterProvider.notifier).state = reason,
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final txn = repo.getTransaction(item.transactionId);
                    if (txn == null) return const SizedBox.shrink();

                    final cat = repo.categories.where((c) => c.id == item.suggestedCategoryId).firstOrNull;

                    return Dismissible(
                      key: Key(item.id),
                      direction: DismissDirection.horizontal,
                      onDismissed: (direction) {
                        if (direction == DismissDirection.startToEnd) {
                          ref.read(reviewQueueProvider.notifier).approveItem(item.id);
                        } else {
                          ref.read(reviewQueueProvider.notifier).rejectItem(item.id);
                        }
                      },
                      background: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.check, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF44336),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(cat?.colorValue ?? 0xFF9E9E9E).withOpacity(0.2),
                            child: Text(
                              txn.description.isNotEmpty
                                  ? txn.description[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                color: Color(cat?.colorValue ?? 0xFF9E9E9E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            txn.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('₹${txn.amount.toStringAsFixed(2)}'),
                              Row(
                                children: [
                                  _confidenceBadge(item.confidence, theme),
                                  const SizedBox(width: 8),
                                  _reasonBadge(item.reason, theme),
                                ],
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              switch (value) {
                                case 'edit':
                                  context.push('/transactions/${txn.id}');
                                  break;
                                case 'approve':
                                  ref.read(reviewQueueProvider.notifier).approveItem(item.id);
                                  break;
                                case 'reject':
                                  ref.read(reviewQueueProvider.notifier).rejectItem(item.id);
                                  break;
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(value: 'edit', child: Text('Edit')),
                              const PopupMenuItem(value: 'approve', child: Text('Approve')),
                              const PopupMenuItem(value: 'reject', child: Text('Reject')),
                            ],
                          ),
                          onTap: () => _showEditCategorySheet(context, ref, item, repo),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _confidenceBadge(double confidence, ThemeData theme) {
    final color = confidence > 0.8 ? const Color(0xFF4CAF50) : confidence > 0.5 ? const Color(0xFFFF9800) : const Color(0xFFF44336);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '${(confidence * 100).toStringAsFixed(0)}%',
        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _reasonBadge(ReviewReason reason, ThemeData theme) {
    final label = _reasonLabel(reason);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, color: theme.colorScheme.onPrimaryContainer),
      ),
    );
  }

  String _reasonLabel(ReviewReason reason) {
    switch (reason) {
      case ReviewReason.lowConfidence:
        return 'Low Confidence';
      case ReviewReason.possibleDuplicate:
        return 'Possible Duplicate';
      case ReviewReason.ambiguousColumns:
        return 'Ambiguous';
    }
  }

  void _showEditCategorySheet(BuildContext context, WidgetRef ref, ReviewItem item, Repository repo) {
    final categories = repo.categories;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Assign Category', style: Theme.of(ctx).textTheme.titleMedium),
              const SizedBox(height: 16),
              ...categories.map((c) => ListTile(
                    leading: Icon(Icons.circle, color: Color(c.colorValue), size: 20),
                    title: Text(c.name),
                    selected: c.id == item.suggestedCategoryId,
                    onTap: () {
                      ref.read(reviewQueueProvider.notifier).updateCategory(item.id, c.id, c.name);
                      Navigator.pop(ctx);
                    },
                  )),
            ],
          ),
        );
      },
    );
  }
}
