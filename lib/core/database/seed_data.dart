import '../database/database.dart';
import '../database/daos/category_dao.dart';

class SeedData {
  static const _defaultCategories = [
    ('food', 'Food', 'restaurant', 'expense', null),
    ('food_delivery', 'Food Delivery', 'delivery_dining', 'expense', null),
    ('groceries', 'Groceries', 'shopping_cart', 'expense', null),
    ('rent', 'Rent', 'home', 'expense', null),
    ('bills', 'Bills', 'receipt', 'expense', null),
    ('utilities', 'Utilities', 'electrical_services', 'expense', null),
    ('shopping', 'Shopping', 'local_mall', 'expense', null),
    ('travel', 'Travel', 'flight', 'expense', null),
    ('transport', 'Transport', 'directions_bus', 'expense', null),
    ('fuel', 'Fuel', 'local_gas_station', 'expense', null),
    ('entertainment', 'Entertainment', 'movie', 'expense', null),
    ('health', 'Health', 'local_hospital', 'expense', null),
    ('investments', 'Investments', 'trending_up', 'expense', null),
    ('transfers', 'Transfers', 'swap_horiz', 'transfer', null),
    ('salary', 'Salary', 'account_balance', 'income', null),
    ('refunds', 'Refunds', 'undo', 'refund', null),
    ('subscriptions', 'Subscriptions', 'subscriptions', 'expense', null),
    ('fees_charges', 'Fees & Charges', 'money_off', 'expense', null),
    ('cash_withdrawal', 'Cash Withdrawal', 'currency_rupee', 'expense', null),
    ('other', 'Other', 'category', 'expense', null),
  ];

  static Future<void> seedIfEmpty(CategoryDao categoryDao) async {
    final count = await categoryDao.getCategoriesCount();
    if (count > 0) return;

    final now = DateTime.now();
    final entries = _defaultCategories.map((c) {
      final (id, name, icon, type, _) = c;
      return CategoryEntry(
        id: id,
        name: name,
        icon: icon,
        type: type,
        isSystem: 1,
        createdAt: now,
        updatedAt: now,
      );
    }).toList();

    await categoryDao.insertCategories(entries);
  }
}
