import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/core/repository.dart';
import 'package:pocketledger/core/security/biometric_manager.dart';

enum AuthState { initial, available, unavailable, authenticating, authenticated, failed }

class LockAuthNotifier extends StateNotifier<AuthState> {
  final BiometricManager _biometricManager;
  final Repository _repo;

  LockAuthNotifier(this._biometricManager, this._repo) : super(AuthState.initial) {
    _checkAvailability();
  }

  Future<void> _checkAvailability() async {
    final canUse = await _biometricManager.canUseBiometrics();
    state = canUse ? AuthState.available : AuthState.unavailable;
  }

  Future<bool> authenticate() async {
    state = AuthState.authenticating;
    final success = await _biometricManager.authenticate();
    state = success ? AuthState.authenticated : AuthState.failed;
    return success;
  }

  bool hasPasscode() => _repo.settings.passcode != null && _repo.settings.passcode!.length == 4;

  bool verifyPasscode(String input) {
    if (!hasPasscode()) return false;
    if (input == _repo.settings.passcode) {
      state = AuthState.authenticated;
      return true;
    }
    state = AuthState.failed;
    return false;
  }

  void setPasscode(String passcode, String? oldPasscode) {
    if (oldPasscode != null && _repo.settings.passcode != null) {
      if (oldPasscode != _repo.settings.passcode) return;
    }
    final updated = _repo.settings.copyWith(passcode: passcode);
    _repo.updateSettings(updated);
  }

  void clearPasscode() {
    final updated = _repo.settings.copyWith(passcode: null);
    _repo.updateSettings(updated);
  }

  void reset() => state = AuthState.initial;
}

final lockAuthStateProvider = StateNotifierProvider<LockAuthNotifier, AuthState>((ref) {
  return LockAuthNotifier(BiometricManager(), ref.watch(dataRepositoryProvider));
});
