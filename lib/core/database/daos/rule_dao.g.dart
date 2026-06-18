// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule_dao.dart';

// ignore_for_file: type=lint
mixin _$RuleDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategorizationRulesTable get categorizationRules =>
      attachedDatabase.categorizationRules;
  RuleDaoManager get managers => RuleDaoManager(this);
}

class RuleDaoManager {
  final _$RuleDaoMixin _db;
  RuleDaoManager(this._db);
  $$CategorizationRulesTableTableManager get categorizationRules =>
      $$CategorizationRulesTableTableManager(
          _db.attachedDatabase, _db.categorizationRules);
}
