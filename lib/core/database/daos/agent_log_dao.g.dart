// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_log_dao.dart';

// ignore_for_file: type=lint
mixin _$AgentLogDaoMixin on DatabaseAccessor<AppDatabase> {
  $AgentActionLogsTable get agentActionLogs => attachedDatabase.agentActionLogs;
  AgentLogDaoManager get managers => AgentLogDaoManager(this);
}

class AgentLogDaoManager {
  final _$AgentLogDaoMixin _db;
  AgentLogDaoManager(this._db);
  $$AgentActionLogsTableTableManager get agentActionLogs =>
      $$AgentActionLogsTableTableManager(
          _db.attachedDatabase, _db.agentActionLogs);
}
