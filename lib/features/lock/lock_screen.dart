import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketledger/features/lock/lock_provider.dart';
import 'package:pocketledger/core/theme/app_colors.dart';
import 'package:pocketledger/core/theme/glass_card.dart';

class LockScreen extends ConsumerWidget {
  const LockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(lockAuthStateProvider);
    final notifier = ref.read(lockAuthStateProvider.notifier);
    final hasPasscode = notifier.hasPasscode();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: authState == AuthState.failed || (hasPasscode && (authState == AuthState.unavailable || authState == AuthState.initial))
                ? _PasscodePad(onVerified: () {
                    if (context.mounted) context.go('/');
                  }, ref: ref)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GlassCard(
                        width: 100,
                        height: 100,
                        borderRadius: 24,
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 48,
                          color: AppColors.primaryLight,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'PocketLedger',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Your personal finance tracker',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 48),
                      if (authState == AuthState.authenticating)
                        const CircularProgressIndicator(color: AppColors.primary)
                      else ...[
                        GlassCard(
                          padding: EdgeInsets.zero,
                          width: double.infinity,
                          height: 56,
                          borderRadius: 16,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: authState == AuthState.available
                                ? () async {
                                    final success = await ref.read(lockAuthStateProvider.notifier).authenticate();
                                    if (success && context.mounted) {
                                      context.go('/');
                                    }
                                  }
                                : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.fingerprint,
                                  size: 24,
                                  color: authState == AuthState.available
                                      ? AppColors.primary
                                      : AppColors.textTertiary,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  authState == AuthState.available
                                      ? 'Tap to Unlock'
                                      : 'Biometric Unavailable',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: authState == AuthState.available
                                        ? AppColors.textPrimary
                                        : AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (hasPasscode) ...[
                          const SizedBox(height: 12),
                          GlassCard(
                            padding: EdgeInsets.zero,
                            width: double.infinity,
                            height: 56,
                            borderRadius: 16,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => ref.read(lockAuthStateProvider.notifier).reset(),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.pin, size: 24, color: AppColors.textPrimary),
                                  SizedBox(width: 12),
                                  Text(
                                    'Enter Passcode',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                      if (authState == AuthState.failed)
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text(
                            'Authentication failed. Try again.',
                            style: TextStyle(color: AppColors.expense, fontSize: 14),
                          ),
                        ),
                      if (!hasPasscode) ...[
                        const SizedBox(height: 16),
                        GlassCard(
                          padding: EdgeInsets.zero,
                          width: double.infinity,
                          height: 56,
                          borderRadius: 16,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => context.go('/'),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_forward, size: 24, color: AppColors.primary),
                                const SizedBox(width: 12),
                                Text(
                                  'Enter App',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'No passcode configured. Set one up in Settings.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _PasscodePad extends ConsumerStatefulWidget {
  final VoidCallback onVerified;
  final WidgetRef ref;

  const _PasscodePad({required this.onVerified, required this.ref});

  @override
  _PasscodePadState createState() => _PasscodePadState();
}

class _PasscodePadState extends ConsumerState<_PasscodePad> {
  String _code = '';
  String? _errorMessage;

  void _onDigit(String digit) {
    if (_code.length >= 4) return;
    setState(() {
      _code += digit;
      _errorMessage = null;
    });
    if (_code.length == 4) {
      _verify();
    }
  }

  void _onDelete() {
    if (_code.isEmpty) return;
    setState(() {
      _code = _code.substring(0, _code.length - 1);
      _errorMessage = null;
    });
  }

  void _verify() {
    final success = widget.ref.read(lockAuthStateProvider.notifier).verifyPasscode(_code);
    if (success) {
      widget.onVerified();
    } else {
      setState(() {
        _code = '';
        _errorMessage = 'Incorrect passcode';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GlassCard(
          width: 80,
          height: 80,
          borderRadius: 20,
          child: const Icon(Icons.lock_outline_rounded, size: 40, color: AppColors.primaryLight),
        ),
        const SizedBox(height: 24),
        const Text(
          'Enter Passcode',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (i) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < _code.length
                    ? AppColors.primary
                    : AppColors.cardGlass,
                border: Border.all(
                  color: i < _code.length ? AppColors.primary : AppColors.cardGlassBorder,
                  width: 1.5,
                ),
              ),
            );
          }),
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(_errorMessage!, style: const TextStyle(color: AppColors.expense, fontSize: 14)),
          ),
        const SizedBox(height: 32),
        _Numpad(onDigit: _onDigit, onDelete: _onDelete),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            setState(() {
              _code = '';
              _errorMessage = null;
            });
            widget.ref.read(lockAuthStateProvider.notifier).reset();
          },
          style: TextButton.styleFrom(foregroundColor: AppColors.primaryLight),
          child: const Text('Use biometrics instead'),
        ),
      ],
    );
  }
}

class _Numpad extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onDelete;

  const _Numpad({required this.onDigit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _NumpadRow(['1', '2', '3']),
        _NumpadRow(['4', '5', '6']),
        _NumpadRow(['7', '8', '9']),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 80),
            _NumpadButton('0', onDigit: onDigit),
            SizedBox(
              width: 80,
              height: 72,
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.backspace_outlined),
                  iconSize: 28,
                  color: AppColors.textSecondary,
                  onPressed: onDelete,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _NumpadRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: digits.map((d) => _NumpadButton(d, onDigit: onDigit)).toList(),
    );
  }
}

class _NumpadButton extends StatelessWidget {
  final String digit;
  final ValueChanged<String> onDigit;

  const _NumpadButton(this.digit, {required this.onDigit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 72,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.cardGlass,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardGlassBorder, width: 0.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onDigit(digit),
          splashColor: Colors.white.withOpacity(0.05),
          child: Center(
            child: Text(
              digit,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
