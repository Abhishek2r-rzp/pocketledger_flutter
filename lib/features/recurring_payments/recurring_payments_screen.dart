import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pocketledger/core/models/recurring_payment.dart';
import 'package:pocketledger/core/models/enums.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/features/recurring_payments/recurring_payments_provider.dart';

class RecurringPaymentsScreen extends ConsumerWidget {
  const RecurringPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(recurringPaymentsProvider);
    final categories = ref.watch(dataRepositoryProvider).categories;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recurring Payments'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (payments) {
          if (payments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.repeat, size: 64,
                      color: theme.colorScheme.outline.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text('No recurring payments found',
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Import more transactions to detect patterns',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6))),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final payment = payments[index];
              final cat = categories.where((c) => c.id == payment.categoryId).firstOrNull;

              return Dismissible(
                key: Key(payment.id),
                direction: DismissDirection.horizontal,
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
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    ref.read(recurringPaymentsProvider.notifier).confirmPayment(payment.id);
                  } else {
                    ref.read(recurringPaymentsProvider.notifier).rejectPayment(payment.id);
                  }
                },
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(cat?.colorValue ?? 0xFF9E9E9E).withOpacity(0.2),
                      child: Icon(
                        Icons.repeat,
                        color: Color(cat?.colorValue ?? 0xFF9E9E9E),
                      ),
                    ),
                    title: Text(
                      payment.merchantName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('₹${payment.averageAmount.toStringAsFixed(2)} - ${_frequencyLabel(payment.frequency)}'),
                        Text('${payment.occurrences} occurrences'),
                      ],
                    ),
                    trailing: _StatusBadge(payment.active, theme),
                    onTap: () => _showPaymentDetails(context, payment, cat?.name ?? 'Unknown'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _frequencyLabel(PaymentFrequency? frequency) {
    switch (frequency) {
      case PaymentFrequency.weekly: return 'Weekly';
      case PaymentFrequency.biweekly: return 'Bi-weekly';
      case PaymentFrequency.monthly: return 'Monthly';
      case PaymentFrequency.quarterly: return 'Quarterly';
      case PaymentFrequency.yearly: return 'Yearly';
      case PaymentFrequency.irregular: return 'Irregular';
      case null: return 'Unknown';
    }
  }

  Widget _StatusBadge(bool active, ThemeData theme) {
    if (active) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFF4CAF50).withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'Active',
          style: TextStyle(fontSize: 10, color: Color(0xFF4CAF50), fontWeight: FontWeight.w600),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF44336).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'Inactive',
        style: TextStyle(fontSize: 10, color: Color(0xFFF44336), fontWeight: FontWeight.w600),
      ),
    );
  }

  void _showPaymentDetails(BuildContext context, RecurringPayment payment, String categoryName) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(payment.merchantName, style: theme.textTheme.titleMedium),
              const SizedBox(height: 16),
              _DetailRow('Amount', '₹${payment.averageAmount.toStringAsFixed(2)}', theme),
              _DetailRow('Category', categoryName, theme),
              _DetailRow('Frequency', _frequencyLabel(payment.frequency), theme),
              _DetailRow('Occurrences', '${payment.occurrences}', theme),
              if (payment.amount != null)
                _DetailRow('Last Amount', '₹${payment.amount!.toStringAsFixed(2)}', theme),
              _DetailRow('Last Detected', DateFormat('dd MMM yyyy').format(payment.lastDetected), theme),
            ],
          ),
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;

  _DetailRow(this.label, this.value, this.theme);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          )),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
