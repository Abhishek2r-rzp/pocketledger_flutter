class Category {
  final String id;
  final String name;
  final String? icon;
  final String? color;
  final bool isSystem;

  const Category({
    required this.id,
    required this.name,
    this.icon,
    this.color,
    this.isSystem = false,
  });

  int get colorValue {
    if (color == null) return 0xFF9E9E9E;
    return int.tryParse(color!.replaceFirst('#', '0xFF')) ?? 0xFF9E9E9E;
  }

  static const List<Category> defaults = [
    Category(id: 'food', name: 'Food & Dining', icon: 'restaurant', color: '#FF5722', isSystem: true),
    Category(id: 'transport', name: 'Transport', icon: 'directions_car', color: '#2196F3', isSystem: true),
    Category(id: 'shopping', name: 'Shopping', icon: 'shopping_bag', color: '#9C27B0', isSystem: true),
    Category(id: 'bills', name: 'Bills & Utilities', icon: 'receipt', color: '#F44336', isSystem: true),
    Category(id: 'entertainment', name: 'Entertainment', icon: 'movie', color: '#E91E63', isSystem: true),
    Category(id: 'health', name: 'Health & Fitness', icon: 'favorite', color: '#4CAF50', isSystem: true),
    Category(id: 'education', name: 'Education', icon: 'school', color: '#3F51B5', isSystem: true),
    Category(id: 'salary', name: 'Salary & Income', icon: 'work', color: '#4CAF50', isSystem: true),
    Category(id: 'investment', name: 'Investment', icon: 'trending_up', color: '#009688', isSystem: true),
    Category(id: 'transfer', name: 'Transfer', icon: 'swap_horiz', color: '#607D8B', isSystem: true),
    Category(id: 'uncategorized', name: 'Uncategorized', icon: 'help_outline', color: '#9E9E9E', isSystem: true),
  ];
}
