import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/core/models/import_batch.dart';

class ImportHistoryNotifier extends AsyncNotifier<List<ImportBatch>> {
  @override
  Future<List<ImportBatch>> build() async {
    final repo = ref.read(dataRepositoryProvider);
    return repo.importBatches.reversed.toList();
  }

  Future<void> deleteBatch(String id) async {
    final repo = ref.read(dataRepositoryProvider);
    repo.deleteImportBatch(id);
    ref.invalidateSelf();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

final importHistoryProvider = AsyncNotifierProvider<ImportHistoryNotifier, List<ImportBatch>>(() {
  return ImportHistoryNotifier();
});
