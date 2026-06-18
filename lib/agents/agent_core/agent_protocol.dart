import '../agent_action_log.dart';

enum AgentTaskStatus { pending, running, completed, needsUserReview, failed }

class AgentResult<T> {
  final AgentTaskStatus status;
  final T? output;
  final double confidence;
  final String? explanation;
  final List<AgentActionLog> auditLogs;
  final bool needsReview;

  const AgentResult({
    required this.status,
    this.output,
    required this.confidence,
    this.explanation,
    this.auditLogs = const [],
    this.needsReview = false,
  });
}

abstract class Agent<Input, Output> {
  String get name;
  String get purpose;
  Future<AgentResult<Output>> run(Input input);
}
