// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_payment_dao.dart';

// ignore_for_file: type=lint
mixin _$RecurringPaymentDaoMixin on DatabaseAccessor<AppDatabase> {
  $RecurringPaymentsTable get recurringPayments =>
      attachedDatabase.recurringPayments;
  RecurringPaymentDaoManager get managers => RecurringPaymentDaoManager(this);
}

class RecurringPaymentDaoManager {
  final _$RecurringPaymentDaoMixin _db;
  RecurringPaymentDaoManager(this._db);
  $$RecurringPaymentsTableTableManager get recurringPayments =>
      $$RecurringPaymentsTableTableManager(
          _db.attachedDatabase, _db.recurringPayments);
}
