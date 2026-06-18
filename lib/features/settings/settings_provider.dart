import 'package:flutter_riverpod/legacy.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/core/repository.dart';
import 'package:pocketledger/core/models/user_settings.dart';

class SettingsNotifier extends StateNotifier<UserSettings> {
  final Repository _repo;

  SettingsNotifier(this._repo) : super(_repo.settings);

  Future<void> toggleBiometric(bool enabled) async {
    final updated = state.copyWith(
      appLockEnabled: enabled,
      biometricEnabled: enabled,
    );
    _repo.updateSettings(updated);
    state = updated;
  }

  Future<void> setCurrency(String currency) async {
    final updated = state.copyWith(currency: currency);
    _repo.updateSettings(updated);
    state = updated;
  }

  Future<void> toggleDebugMode(bool enabled) async {
    final updated = state.copyWith(debugModeEnabled: enabled);
    _repo.updateSettings(updated);
    state = updated;
  }

  Future<void> setPasscode(String passcode) async {
    final updated = state.copyWith(passcode: passcode);
    _repo.updateSettings(updated);
    state = updated;
  }

  Future<void> clearPasscode() async {
    final updated = state.copyWith(passcode: null);
    _repo.updateSettings(updated);
    state = updated;
  }

  Future<void> reset() async {
    const updated = UserSettings();
    _repo.updateSettings(updated);
    state = updated;
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, UserSettings>((ref) {
  final repo = ref.watch(dataRepositoryProvider);
  return SettingsNotifier(repo);
});
