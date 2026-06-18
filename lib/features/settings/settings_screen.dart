import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/features/settings/settings_provider.dart';
import 'package:pocketledger/services/export_service.dart';
import 'package:pocketledger/core/theme/app_colors.dart';
import 'package:pocketledger/core/theme/glass_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final repo = ref.watch(dataRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _SectionHeader(title: 'Security'),
          const SizedBox(height: 8),
          GlassCard.premium(
            padding: const EdgeInsets.all(4),
            borderRadius: 16,
            child: Column(
              children: [
                _GlassSwitchTile(
                  icon: Icons.fingerprint,
                  iconColor: AppColors.primary,
                  title: 'Biometric Lock',
                  subtitle: 'Require authentication to open app',
                  value: settings.biometricEnabled,
                  onChanged: (v) => ref.read(settingsProvider.notifier).toggleBiometric(v),
                ),
                _GlassDivider(),
                _GlassListTile(
                  icon: Icons.pin,
                  iconColor: AppColors.info,
                  title: 'Passcode Lock',
                  subtitle: settings.passcode != null ? 'Passcode is set' : 'Set a 4-digit passcode',
                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 20),
                  onTap: () => _showPasscodeDialog(context, ref, settings.passcode),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: 'Preferences'),
          const SizedBox(height: 8),
          GlassCard.premium(
            padding: const EdgeInsets.all(4),
            borderRadius: 16,
            child: _GlassListTile(
              icon: Icons.monetization_on_rounded,
              iconColor: AppColors.warning,
              title: 'Currency',
              subtitle: settings.currency,
              trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 20),
              onTap: () => _showCurrencyPicker(context, ref),
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: 'Data Management'),
          const SizedBox(height: 8),
          GlassCard.premium(
            padding: const EdgeInsets.all(4),
            borderRadius: 16,
            child: Column(
              children: [
                _GlassListTile(
                  icon: Icons.file_download_outlined,
                  iconColor: AppColors.income,
                  title: 'Export CSV',
                  subtitle: 'Download all transactions as CSV',
                  onTap: () => _exportCSV(context, ref),
                ),
                _GlassDivider(),
                _GlassListTile(
                  icon: Icons.delete_forever_outlined,
                  iconColor: AppColors.expense,
                  title: 'Delete All Data',
                  subtitle: 'Remove all transactions and settings',
                  titleColor: AppColors.expense,
                  onTap: () => _confirmDeleteAll(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: 'Privacy'),
          const SizedBox(height: 8),
          GlassCard.premium(
            padding: const EdgeInsets.all(4),
            borderRadius: 16,
            child: _GlassListTile(
              icon: Icons.privacy_tip_outlined,
              iconColor: AppColors.info,
              title: 'Privacy Report',
              subtitle: 'View how your data is protected',
              trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 20),
              onTap: () => _showPrivacyReport(context),
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: 'Developer'),
          const SizedBox(height: 8),
          GlassCard.premium(
            padding: const EdgeInsets.all(4),
            borderRadius: 16,
            child: _GlassListTile(
              icon: Icons.article_outlined,
              iconColor: AppColors.primary,
              title: 'Agent Logs',
              subtitle: 'View agent actions and explanations',
              trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 20),
              onTap: () => context.push('/agent-logs'),
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: 'About'),
          const SizedBox(height: 8),
          GlassCard.premium(
            padding: const EdgeInsets.all(4),
            borderRadius: 16,
            child: Column(
              children: [
                _GlassListTile(
                  icon: Icons.account_balance_wallet_rounded,
                  iconColor: AppColors.primary,
                  title: 'PocketLedger',
                  subtitle: 'Version 1.0.0 (build 1)',
                ),
                _GlassDivider(),
                _GlassListTile(
                  icon: Icons.favorite_rounded,
                  iconColor: AppColors.expense,
                  title: 'Made with ❤️ in India',
                  subtitle: 'Offline-first personal finance tracker',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPasscodeDialog(BuildContext context, WidgetRef ref, String? currentPasscode) {
    showDialog(
      context: context,
      builder: (ctx) => _PasscodeSettingsDialog(
        currentPasscode: currentPasscode,
        onSet: (passcode) {
          ref.read(settingsProvider.notifier).setPasscode(passcode);
        },
        onClear: () {
          ref.read(settingsProvider.notifier).clearPasscode();
        },
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final currencies = ['INR', 'USD', 'EUR', 'GBP', 'SGD', 'AED'];
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Currency', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 16),
              ...currencies.map((c) => ListTile(
                    title: Text(c, style: const TextStyle(color: AppColors.textPrimary)),
                    trailing: c == ref.read(settingsProvider).currency
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      ref.read(settingsProvider.notifier).setCurrency(c);
                      Navigator.pop(ctx);
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  Future<void> _exportCSV(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(dataRepositoryProvider);
    final exportService = ExportService();
    final csvContent = await exportService.exportTransactionsToCSV(
      repo.transactions,
      repo.categories,
    );

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/pocketledger_export.csv');
    await file.writeAsString(csvContent);

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'PocketLedger Export',
    );
  }

  void _confirmDeleteAll(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Delete All Data', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'This will permanently delete all your transactions, budgets, import history, and settings. This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(settingsProvider.notifier).reset();
              ref.read(dataRepositoryProvider).clearAllData();
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.expense),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyReport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Privacy Report', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 20),
              _PrivacyItem(Icons.security, 'Local Processing', 'All data is processed on your device. No data leaves your phone.'),
              _PrivacyItem(Icons.cloud_off, 'No Cloud Storage', 'Your financial data is stored locally only. No cloud sync or backup.'),
              _PrivacyItem(Icons.fingerprint, 'Biometric Protection', 'Optional biometric lock to protect your data.'),
              _PrivacyItem(Icons.analytics_outlined, 'No Tracking', 'PocketLedger does not collect analytics, crash reports, or usage data.'),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _GlassSwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _GlassSwitchTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: AppColors.textTertiary, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}

class _GlassListTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  const _GlassListTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor ?? AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _GlassDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Divider(color: AppColors.cardGlassBorder, height: 1, thickness: 0.5),
    );
  }
}

class _PrivacyItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  _PrivacyItem(this.icon, this.title, this.description);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PasscodeSettingsDialog extends StatefulWidget {
  final String? currentPasscode;
  final ValueChanged<String> onSet;
  final VoidCallback onClear;

  const _PasscodeSettingsDialog({
    required this.currentPasscode,
    required this.onSet,
    required this.onClear,
  });

  @override
  _PasscodeSettingsDialogState createState() => _PasscodeSettingsDialogState();
}

class _PasscodeSettingsDialogState extends State<_PasscodeSettingsDialog> {
  late String _step;
  String _code1 = '';
  String _code2 = '';
  String? _error;

  @override
  void initState() {
    super.initState();
    _step = widget.currentPasscode != null ? 'enter_old' : 'enter_new';
  }

  void _onDigit(String d) {
    setState(() => _error = null);
    if (_step == 'enter_old' || _step == 'enter_new') {
      if (_code1.length < 4) {
        _code1 += d;
      }
      if (_code1.length == 4) {
        if (_step == 'enter_old') {
          if (_code1 == widget.currentPasscode) {
            _step = 'enter_new';
            _code1 = '';
          } else {
            _error = 'Incorrect passcode';
            _code1 = '';
          }
        } else {
          _step = 'confirm';
          _code2 = '';
        }
      }
    } else if (_step == 'confirm') {
      if (_code2.length < 4) {
        _code2 += d;
      }
      if (_code2.length == 4) {
        if (_code1 == _code2) {
          widget.onSet(_code1);
          Navigator.pop(context);
        } else {
          _error = 'Passcodes do not match';
          _step = 'enter_new';
          _code1 = '';
          _code2 = '';
        }
      }
    }
  }

  void _onDelete() {
    setState(() => _error = null);
    if (_step == 'confirm') {
      if (_code2.isNotEmpty) _code2 = _code2.substring(0, _code2.length - 1);
    } else {
      if (_code1.isNotEmpty) _code1 = _code1.substring(0, _code1.length - 1);
    }
  }

  String get _title {
    if (_step == 'enter_old') return 'Enter current passcode';
    if (_step == 'enter_new') return 'Enter new passcode';
    return 'Confirm passcode';
  }

  String get _enteredCode => _step == 'confirm' ? _code2 : _code1;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _title,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < _enteredCode.length
                        ? AppColors.primary
                        : AppColors.cardGlass,
                    border: Border.all(
                      color: i < _enteredCode.length ? AppColors.primary : AppColors.cardGlassBorder,
                      width: 1.5,
                    ),
                  ),
                );
              }),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_error!, style: const TextStyle(color: AppColors.expense, fontSize: 13)),
              ),
            const SizedBox(height: 20),
            _NumpadSettings(onDigit: _onDigit, onDelete: _onDelete),
            if (widget.currentPasscode != null) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  widget.onClear();
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(foregroundColor: AppColors.expense),
                child: const Text('Remove passcode'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NumpadSettings extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onDelete;

  const _NumpadSettings({required this.onDigit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: ['1', '2', '3'].map((d) => _NumpadSettingsBtn(d, onDigit)).toList()),
        const SizedBox(height: 4),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: ['4', '5', '6'].map((d) => _NumpadSettingsBtn(d, onDigit)).toList()),
        const SizedBox(height: 4),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: ['7', '8', '9'].map((d) => _NumpadSettingsBtn(d, onDigit)).toList()),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 60),
            _NumpadSettingsBtn('0', onDigit),
            SizedBox(
              width: 60,
              height: 48,
              child: IconButton(
                icon: const Icon(Icons.backspace_outlined, size: 22),
                color: AppColors.textSecondary,
                onPressed: onDelete,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NumpadSettingsBtn extends StatelessWidget {
  final String digit;
  final ValueChanged<String> onDigit;

  const _NumpadSettingsBtn(this.digit, this.onDigit);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 48,
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.cardGlass,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardGlassBorder, width: 0.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => onDigit(digit),
          child: Center(
            child: Text(
              digit,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
