class TransactionLabel {
  final String id;
  final String name;
  final int color;
  final bool isSystem;

  const TransactionLabel({
    required this.id,
    required this.name,
    this.color = 0xFF9E9E9E,
    this.isSystem = false,
  });

  TransactionLabel copyWith({
    String? id,
    String? name,
    int? color,
    bool? isSystem,
  }) {
    return TransactionLabel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      isSystem: isSystem ?? this.isSystem,
    );
  }
}
