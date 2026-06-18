enum InsightType { spending, saving, recurring, comparison, anomaly, summary }
enum InsightSeverity { info, warning, alert }

class Insight {
  final String id;
  final String title;
  final String description;
  final InsightType type;
  final InsightSeverity severity;
  final String? relatedCategoryId;
  final double? relatedAmount;
  final DateTime createdAt;

  const Insight({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.severity,
    this.relatedCategoryId,
    this.relatedAmount,
    required this.createdAt,
  });
}
