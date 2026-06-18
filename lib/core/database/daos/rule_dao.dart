import 'package:drift/drift.dart';
import '../database.dart';

part 'rule_dao.g.dart';

@DriftAccessor(tables: [CategorizationRules])
class RuleDao extends DatabaseAccessor<AppDatabase> with _$RuleDaoMixin {
  RuleDao(super.db);

  Future<List<CategorizationRuleEntry>> getAllRules() {
    return (select(categorizationRules)
          ..orderBy([(r) => OrderingTerm(expression: r.priority, mode: OrderingMode.desc)]))
        .get();
  }

  Future<CategorizationRuleEntry?> getRuleById(String id) {
    return (select(categorizationRules)..where((r) => r.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<CategorizationRuleEntry>> getUserRules() {
    return (select(categorizationRules)
          ..where((r) => r.createdByUser.equals(1))
          ..orderBy([(r) => OrderingTerm(expression: r.priority, mode: OrderingMode.desc)]))
        .get();
  }

  Future<List<CategorizationRuleEntry>> getRulesByMatchType(String matchType) {
    return (select(categorizationRules)
          ..where((r) => r.matchType.equals(matchType))
          ..orderBy([(r) => OrderingTerm(expression: r.priority, mode: OrderingMode.desc)]))
        .get();
  }

  Future<List<CategorizationRuleEntry>> getRulesForCategory(String categoryId) {
    return (select(categorizationRules)
          ..where((r) => r.categoryId.equals(categoryId))
          ..orderBy([(r) => OrderingTerm(expression: r.priority, mode: OrderingMode.desc)]))
        .get();
  }

  Future<int> insertRule(CategorizationRuleEntry entry) {
    return into(categorizationRules).insert(entry);
  }

  Future<void> insertRules(List<CategorizationRuleEntry> entries) {
    return batch((b) {
      b.insertAll(categorizationRules, entries);
    });
  }

  Future<int> updateRule(CategorizationRuleEntry entry) {
    return (update(categorizationRules)..whereSamePrimaryKey(entry))
        .write(entry);
  }

  Future<void> updateRuleUsage(String ruleId) {
    return customUpdate(
      'UPDATE categorization_rules SET usage_count = usage_count + 1, updated_at = ? WHERE id = ?',
      variables: [Variable(DateTime.now().millisecondsSinceEpoch), Variable(ruleId)],
    );
  }

  Future<int> deleteRule(String id) {
    return (delete(categorizationRules)..where((r) => r.id.equals(id))).go();
  }

  Future<int> deleteAllRules() {
    return delete(categorizationRules).go();
  }

  Future<int> getRulesCount() {
    return customSelect(
      'SELECT COUNT(*) AS count FROM categorization_rules',
    ).map((row) => row.read<int>('count')).getSingle();
  }
}
