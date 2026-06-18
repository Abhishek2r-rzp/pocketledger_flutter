import 'package:drift/drift.dart';
import '../database.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  Future<List<CategoryEntry>> getAllCategories() => select(categories).get();

  Future<CategoryEntry?> getCategoryById(String id) {
    return (select(categories)..where((c) => c.id.equals(id)))
        .getSingleOrNull();
  }

  Future<CategoryEntry?> getCategoryByName(String name) {
    return (select(categories)..where((c) => c.name.equals(name)))
        .getSingleOrNull();
  }

  Future<List<CategoryEntry>> getCategoriesByType(String type) {
    return (select(categories)
          ..where((c) => c.type.equals(type))
          ..orderBy([(c) => OrderingTerm(expression: c.name)]))
        .get();
  }

  Future<List<CategoryEntry>> getSystemCategories() {
    return (select(categories)
          ..where((c) => c.isSystem.equals(1))
          ..orderBy([(c) => OrderingTerm(expression: c.name)]))
        .get();
  }

  Future<List<CategoryEntry>> getCustomCategories() {
    return (select(categories)
          ..where((c) => c.isSystem.equals(0))
          ..orderBy([(c) => OrderingTerm(expression: c.name)]))
        .get();
  }

  Future<List<CategoryEntry>> getChildCategories(String parentId) {
    return (select(categories)
          ..where((c) => c.parentCategoryId.equals(parentId))
          ..orderBy([(c) => OrderingTerm(expression: c.name)]))
        .get();
  }

  Future<int> insertCategory(CategoryEntry entry) {
    return into(categories).insert(entry);
  }

  Future<void> insertCategories(List<CategoryEntry> entries) {
    return batch((b) {
      b.insertAll(categories, entries);
    });
  }

  Future<int> updateCategory(CategoryEntry entry) {
    return (update(categories)..whereSamePrimaryKey(entry)).write(entry);
  }

  Future<int> deleteCategory(String id) {
    return (delete(categories)..where((c) => c.id.equals(id))).go();
  }

  Future<int> getCategoriesCount() {
    return customSelect(
      'SELECT COUNT(*) AS count FROM categories',
    ).map((row) => row.read<int>('count')).getSingle();
  }
}
