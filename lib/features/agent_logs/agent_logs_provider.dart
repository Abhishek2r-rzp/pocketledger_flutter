import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/core/models/agent_action_log.dart';

final agentLogFilterProvider = StateProvider<String?>((ref) => null);

class AgentLogsNotifier extends AsyncNotifier<List<AgentActionLog>> {
  @override
  Future<List<AgentActionLog>> build() async {
    final repo = ref.read(dataRepositoryProvider);
    final filter = ref.watch(agentLogFilterProvider);

    var logs = repo.agentLogs;
    if (filter != null) {
      logs = logs.where((l) => l.agentName == filter).toList();
    }
    return logs.reversed.toList();
  }

  Future<void> clearLogs() async {
    final repo = ref.read(dataRepositoryProvider);
    repo.clearAgentLogs();
    ref.invalidateSelf();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

final agentLogsProvider = AsyncNotifierProvider<AgentLogsNotifier, List<AgentActionLog>>(() {
  return AgentLogsNotifier();
});
