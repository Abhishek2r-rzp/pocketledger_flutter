class AgentActionLog {
  final String id;
  final String agentName;
  final String actionType;
  final String? inputSummary;
  final String? outputSummary;
  final double confidence;
  final String? explanation;
  final String? transactionId;
  final String? batchId;
  final DateTime createdAt;

  const AgentActionLog({
    required this.id,
    required this.agentName,
    required this.actionType,
    this.inputSummary,
    this.outputSummary,
    required this.confidence,
    this.explanation,
    this.transactionId,
    this.batchId,
    required this.createdAt,
  });
}
