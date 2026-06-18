class CreditCard {
  final String id;
  final String name;
  final String? issuer;
  final String lastFour;
  final double creditLimit;
  final double availableCredit;
  final int billingDay;
  final int dueDay;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CreditCard({
    required this.id,
    required this.name,
    this.issuer,
    required this.lastFour,
    required this.creditLimit,
    this.availableCredit = 0,
    this.billingDay = 1,
    this.dueDay = 15,
    this.isActive = true,
    required this.createdAt,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? createdAt;

  double get outstandingAmount => creditLimit - availableCredit;
  bool get isOverLimit => outstandingAmount > creditLimit;

  CreditCard copyWith({
    String? id,
    String? name,
    String? issuer,
    String? lastFour,
    double? creditLimit,
    double? availableCredit,
    int? billingDay,
    int? dueDay,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearIssuer = false,
  }) {
    return CreditCard(
      id: id ?? this.id,
      name: name ?? this.name,
      issuer: clearIssuer ? null : (issuer ?? this.issuer),
      lastFour: lastFour ?? this.lastFour,
      creditLimit: creditLimit ?? this.creditLimit,
      availableCredit: availableCredit ?? this.availableCredit,
      billingDay: billingDay ?? this.billingDay,
      dueDay: dueDay ?? this.dueDay,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
