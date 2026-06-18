class AgentLogEntry {
  final String id;
  final String agentName;
  final String action;
  final String description;
  final double confidence;
  final String explanation;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;

  AgentLogEntry({
    required this.id,
    required this.agentName,
    required this.action,
    required this.description,
    this.confidence = 1.0,
    this.explanation = '',
    this.metadata,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'agentName': agentName,
        'action': action,
        'description': description,
        'confidence': confidence,
        'explanation': explanation,
        'metadata': metadata,
        'timestamp': timestamp.toIso8601String(),
      };

  factory AgentLogEntry.fromMap(Map<String, dynamic> map) => AgentLogEntry(
        id: map['id'] as String,
        agentName: map['agentName'] as String,
        action: map['action'] as String,
        description: map['description'] as String,
        confidence: (map['confidence'] as num?)?.toDouble() ?? 1.0,
        explanation: map['explanation'] as String? ?? '',
        metadata: map['metadata'] as Map<String, dynamic>?,
        timestamp: DateTime.parse(map['timestamp'] as String),
      );
}
