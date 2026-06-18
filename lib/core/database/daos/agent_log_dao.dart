import 'package:drift/drift.dart';
import '../database.dart';

part 'agent_log_dao.g.dart';

@DriftAccessor(tables: [AgentActionLogs])
class AgentLogDao extends DatabaseAccessor<AppDatabase>
    with _$AgentLogDaoMixin {
  AgentLogDao(super.db);

  Future<List<AgentActionLogEntry>> getAllLogs() {
    return (select(agentActionLogs)
          ..orderBy([(l) => OrderingTerm(expression: l.createdAt, mode: OrderingMode.desc)]))
        .get();
  }

  Future<AgentActionLogEntry?> getLogById(String id) {
    return (select(agentActionLogs)..where((l) => l.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<AgentActionLogEntry>> getRecentLogs({int limit = 50}) {
    return (select(agentActionLogs)
          ..orderBy([(l) => OrderingTerm(expression: l.createdAt, mode: OrderingMode.desc)])
          ..limit(limit))
        .get();
  }

  Future<List<AgentActionLogEntry>> getLogsByAgent(String agentName,
      {int limit = 50}) {
    return (select(agentActionLogs)
          ..where((l) => l.agentName.equals(agentName))
          ..orderBy([(l) => OrderingTerm(expression: l.createdAt, mode: OrderingMode.desc)])
          ..limit(limit))
        .get();
  }

  Future<List<AgentActionLogEntry>> getLogsByActionType(String actionType,
      {int limit = 50}) {
    return (select(agentActionLogs)
          ..where((l) => l.actionType.equals(actionType))
          ..orderBy([(l) => OrderingTerm(expression: l.createdAt, mode: OrderingMode.desc)])
          ..limit(limit))
        .get();
  }

  Future<List<AgentActionLogEntry>> getLogsForTransaction(
      String transactionId) {
    return (select(agentActionLogs)
          ..where((l) => l.relatedTransactionId.equals(transactionId))
          ..orderBy([(l) => OrderingTerm(expression: l.createdAt, mode: OrderingMode.desc)]))
        .get();
  }

  Future<List<AgentActionLogEntry>> getLogsForImportBatch(
      String importBatchId) {
    return (select(agentActionLogs)
          ..where((l) => l.relatedImportBatchId.equals(importBatchId))
          ..orderBy([(l) => OrderingTerm(expression: l.createdAt, mode: OrderingMode.desc)]))
        .get();
  }

  Future<int> insertLog(AgentActionLogEntry entry) {
    return into(agentActionLogs).insert(entry);
  }

  Future<void> insertLogs(List<AgentActionLogEntry> entries) {
    return batch((b) {
      b.insertAll(agentActionLogs, entries);
    });
  }

  Future<int> deleteOldLogs(Duration olderThan) {
    final cutoff = DateTime.now().subtract(olderThan);
    final cutoffMs = cutoff.millisecondsSinceEpoch;
    return customUpdate(
      'DELETE FROM agent_action_logs WHERE created_at IS NOT NULL AND created_at < ?',
      variables: [Variable<int>(cutoffMs)],
    );
  }

  Future<int> deleteLog(String id) {
    return (delete(agentActionLogs)..where((l) => l.id.equals(id))).go();
  }

  Future<int> clearAllLogs() {
    return delete(agentActionLogs).go();
  }

  Future<int> getLogsCount() {
    return customSelect(
      'SELECT COUNT(*) AS count FROM agent_action_logs',
    ).map((row) => row.read<int>('count')).getSingle();
  }

  Future<List<AgentSummary>> getAgentSummary() {
    return customSelect(
      '''
      SELECT
        agent_name,
        action_type,
        COUNT(*) AS action_count,
        AVG(confidence) AS avg_confidence
      FROM agent_action_logs
      GROUP BY agent_name, action_type
      ORDER BY action_count DESC
      ''',
    ).map((row) {
      return AgentSummary(
        agentName: row.read<String>('agent_name'),
        actionType: row.read<String>('action_type'),
        actionCount: row.read<int>('action_count'),
        avgConfidence: row.read<double>('avg_confidence'),
      );
    }).get();
  }
}

class AgentSummary {
  final String agentName;
  final String actionType;
  final int actionCount;
  final double avgConfidence;

  AgentSummary({
    required this.agentName,
    required this.actionType,
    required this.actionCount,
    required this.avgConfidence,
  });
}
