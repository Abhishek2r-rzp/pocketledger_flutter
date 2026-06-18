import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/core/models/recurring_payment.dart';
import 'package:pocketledger/core/models/enums.dart';

class RecurringPaymentsNotifier extends AsyncNotifier<List<RecurringPayment>> {
  @override
  Future<List<RecurringPayment>> build() async {
    final repo = ref.read(dataRepositoryProvider);
    return repo.recurringPayments.where((p) => p.active).toList();
  }

  Future<void> confirmPayment(String id) async {
    final repo = ref.read(dataRepositoryProvider);
    final payment = repo.recurringPayments.where((p) => p.id == id).firstOrNull;
    if (payment != null) {
      repo.updateRecurringPayment(payment.copyWith(active: true));
    }
    ref.invalidateSelf();
  }

  Future<void> rejectPayment(String id) async {
    final repo = ref.read(dataRepositoryProvider);
    final payment = repo.recurringPayments.where((p) => p.id == id).firstOrNull;
    if (payment != null) {
      repo.updateRecurringPayment(payment.copyWith(active: false));
    }
    ref.invalidateSelf();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

final recurringPaymentsProvider = AsyncNotifierProvider<RecurringPaymentsNotifier, List<RecurringPayment>>(() {
  return RecurringPaymentsNotifier();
});
