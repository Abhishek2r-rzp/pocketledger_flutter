import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/core/repository.dart';
import 'package:pocketledger/core/models/user_settings.dart';

class OnboardingPageNotifier extends StateNotifier<int> {
  OnboardingPageNotifier() : super(0);

  void setPage(int page) => state = page;
  void nextPage() => state = state + 1;
  void previousPage() => state = state - 1;
  void reset() => state = 0;
}

final onboardingPageProvider = StateNotifierProvider<OnboardingPageNotifier, int>((ref) {
  return OnboardingPageNotifier();
});

class OnboardingCompletedNotifier extends StateNotifier<bool> {
  final Repository _repo;

  OnboardingCompletedNotifier(this._repo) : super(_repo.settings.firstLaunchCompleted);

  void complete() {
    _repo.updateSettings(_repo.settings.copyWith(
      appLockEnabled: true,
      biometricEnabled: true,
      firstLaunchCompleted: true,
    ));
    state = true;
  }
}

final onboardingCompletedProvider = StateNotifierProvider<OnboardingCompletedNotifier, bool>((ref) {
  final repo = ref.watch(dataRepositoryProvider);
  return OnboardingCompletedNotifier(repo);
});
