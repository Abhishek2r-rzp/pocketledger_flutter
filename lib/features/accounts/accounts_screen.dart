import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/core/models/account.dart';
import 'package:pocketledger/core/models/enums.dart';
import 'package:pocketledger/core/theme/app_colors.dart';
import 'package:pocketledger/core/theme/glass_card.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  static const _typeIcons = {
    AccountType.savings: Icons.account_balance,
    AccountType.creditCard: Icons.credit_card,
    AccountType.wallet: Icons.account_balance_wallet_rounded,
    AccountType.cash: Icons.money,
    AccountType.investment: Icons.trending_up,
  };

  static const _typeLabels = {
    AccountType.savings: 'Savings',
    AccountType.creditCard: 'Credit Card',
    AccountType.wallet: 'Wallet',
    AccountType.cash: 'Cash',
    AccountType.investment: 'Investment',
  };

  IconData _iconFor(AccountType type) => _typeIcons[type] ?? Icons.account_balance;
  String _labelFor(AccountType type) => _typeLabels[type] ?? 'Unknown';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(dataRepositoryProvider);
    final accounts = repo.accounts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
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
        onPressed: () => _showAccountDialog(context, ref, null),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Add Account'),
      ),
      body: accounts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_outlined, size: 64, color: AppColors.textTertiary.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  const Text('No accounts yet', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('Add your bank accounts, wallets, and cards', style: TextStyle(color: AppColors.textTertiary, fontSize: 13)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
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
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(_iconFor(account.type), size: 22, color: AppColors.primary),
                      ),
                      title: Text(account.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500, fontSize: 14)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 2),
                          Text(
                            '${_labelFor(account.type)}${account.lastFour != null ? ' • xxxx${account.lastFour}' : ''}',
                            style: const TextStyle(color: AppColors.textTertiary, fontSize: 11),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '₹${account.balance.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: account.balance >= 0 ? AppColors.income : AppColors.expense,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 4),
                          PopupMenuButton<String>(
                            onSelected: (v) {
                              if (v == 'edit') _showAccountDialog(context, ref, account);
                              if (v == 'delete') _confirmDelete(context, ref, account);
                            },
                            color: AppColors.surface,
                            surfaceTintColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            itemBuilder: (_) => [
                              const PopupMenuItem(value: 'edit', child: ListTile(
                                leading: Icon(Icons.edit, size: 18, color: AppColors.textPrimary),
                                title: Text('Edit', style: TextStyle(color: AppColors.textPrimary, fontSize: 13)),
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                              )),
                              const PopupMenuItem(value: 'delete', child: ListTile(
                                leading: Icon(Icons.delete, size: 18, color: AppColors.expense),
                                title: Text('Delete', style: TextStyle(color: AppColors.expense, fontSize: 13)),
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                              )),
                            ],
                            icon: const Icon(Icons.more_horiz, color: AppColors.textTertiary, size: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showAccountDialog(BuildContext context, WidgetRef ref, Account? existing) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final bankCtrl = TextEditingController(text: existing?.bankName ?? '');
    final lastFourCtrl = TextEditingController(text: existing?.lastFour ?? '');
    final balCtrl = TextEditingController(text: existing != null ? existing.balance.toStringAsFixed(0) : '');
    AccountType selectedType = existing?.type ?? AccountType.savings;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(existing != null ? 'Edit Account' : 'Add Account', style: const TextStyle(color: AppColors.textPrimary)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dialogField(nameCtrl, 'Account Name', Icons.label),
                const SizedBox(height: 12),
                _dialogField(bankCtrl, 'Bank Name (optional)', Icons.account_balance),
                const SizedBox(height: 12),
                DropdownButtonFormField<AccountType>(
                  value: selectedType,
                  dropdownColor: AppColors.surfaceLight,
                  decoration: InputDecoration(
                    labelText: 'Account Type',
                    labelStyle: const TextStyle(color: AppColors.textSecondary),
                    prefixIcon: const Icon(Icons.category, color: AppColors.textTertiary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    filled: true, fillColor: AppColors.cardGlass,
                  ),
                  style: const TextStyle(color: AppColors.textPrimary),
                  items: AccountType.values.map((t) => DropdownMenuItem(value: t, child: Text(_labelFor(t)))).toList(),
                  onChanged: (v) => setDialogState(() => selectedType = v!),
                ),
                const SizedBox(height: 12),
                _dialogField(lastFourCtrl, 'Last 4 digits (optional)', Icons.numbers, maxLen: 4),
                const SizedBox(height: 12),
                _dialogField(balCtrl, 'Current Balance', Icons.monetization_on, keyboardType: TextInputType.number),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) return;
                final balance = double.tryParse(balCtrl.text.trim()) ?? 0;
                final uuid = const Uuid();
                if (existing != null) {
                  ref.read(dataRepositoryProvider).updateAccount(existing.copyWith(
                    name: name,
                    bankName: bankCtrl.text.trim().isEmpty ? null : bankCtrl.text.trim(),
                    type: selectedType,
                    lastFour: lastFourCtrl.text.trim().isEmpty ? null : lastFourCtrl.text.trim(),
                    balance: balance,
                  ));
                } else {
                  ref.read(dataRepositoryProvider).addAccount(Account(
                    id: uuid.v4(),
                    name: name,
                    bankName: bankCtrl.text.trim().isEmpty ? null : bankCtrl.text.trim(),
                    type: selectedType,
                    balance: balance,
                    lastFour: lastFourCtrl.text.trim().isEmpty ? null : lastFourCtrl.text.trim(),
                    createdAt: DateTime.now(),
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

  void _confirmDelete(BuildContext context, WidgetRef ref, Account account) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Delete Account', style: TextStyle(color: AppColors.textPrimary)),
        content: Text('Delete "${account.name}"? Transactions linked to this account will not be deleted.', style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              ref.read(dataRepositoryProvider).deleteAccount(account.id);
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.expense),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _dialogField(TextEditingController ctrl, String label, IconData icon, {int? maxLen, TextInputType? keyboardType}) {
    return TextField(
      controller: ctrl,
      maxLength: maxLen,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.textTertiary),
        counterStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        filled: true, fillColor: AppColors.cardGlass,
      ),
    );
  }

}
