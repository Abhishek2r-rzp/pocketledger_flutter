import 'package:drift/drift.dart';
import '../database.dart';

part 'recurring_payment_dao.g.dart';

@DriftAccessor(tables: [RecurringPayments])
class RecurringPaymentDao extends DatabaseAccessor<AppDatabase>
    with _$RecurringPaymentDaoMixin {
  RecurringPaymentDao(super.db);

  Future<List<RecurringPaymentEntry>> getAllPayments() {
    return (select(recurringPayments)
          ..orderBy([(p) => OrderingTerm(expression: p.confidence, mode: OrderingMode.desc)]))
        .get();
  }

  Future<RecurringPaymentEntry?> getPaymentById(String id) {
    return (select(recurringPayments)..where((p) => p.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<RecurringPaymentEntry>> getPaymentsByStatus(String status) {
    return (select(recurringPayments)
          ..where((p) => p.status.equals(status))
          ..orderBy([(p) => OrderingTerm(expression: p.confidence, mode: OrderingMode.desc)]))
        .get();
  }

  Future<List<RecurringPaymentEntry>> getDetectedPayments() {
    return (select(recurringPayments)
          ..where((p) => p.status.equals('detected'))
          ..orderBy([(p) => OrderingTerm(expression: p.confidence, mode: OrderingMode.desc)]))
        .get();
  }

  Future<List<RecurringPaymentEntry>> getConfirmedPayments() {
    return (select(recurringPayments)
          ..where((p) => p.status.equals('confirmed'))
          ..orderBy([(p) => OrderingTerm(expression: p.nextExpectedDate, mode: OrderingMode.asc)]))
        .get();
  }

  Future<RecurringPaymentEntry?> getPaymentByMerchant(String merchantName) {
    return (select(recurringPayments)
          ..where((p) => p.merchantName.equals(merchantName)))
        .getSingleOrNull();
  }

  Future<int> insertPayment(RecurringPaymentEntry entry) {
    return into(recurringPayments).insert(entry);
  }

  Future<void> insertPayments(List<RecurringPaymentEntry> entries) {
    return batch((b) {
      b.insertAll(recurringPayments, entries);
    });
  }

  Future<int> updatePayment(RecurringPaymentEntry entry) {
    return (update(recurringPayments)..whereSamePrimaryKey(entry)).write(entry);
  }

  Future<int> clearAll() async {
    return delete(recurringPayments).go();
  }

  Future<int> deletePayment(String id) {
    return (delete(recurringPayments)..where((p) => p.id.equals(id))).go();
  }

  Future<int> getPaymentsCount() {
    return customSelect(
      'SELECT COUNT(*) AS count FROM recurring_payments',
    ).map((row) => row.read<int>('count')).getSingle();
  }

  Future<List<RecurringPaymentEntry>> getUpcomingPayments({int days = 30}) {
    final now = DateTime.now();
    final future = now.add(Duration(days: days));
    final nowMs = now.millisecondsSinceEpoch;
    final futureMs = future.millisecondsSinceEpoch;

    return (select(recurringPayments)
          ..where((p) =>
              p.status.equals('confirmed') &
              p.nextExpectedDate.isNotNull() &
              p.nextExpectedDate.isBetween(Variable(nowMs), Variable(futureMs)))
          ..orderBy([
            (p) => OrderingTerm(expression: p.nextExpectedDate, mode: OrderingMode.asc)
          ]))
        .get();
  }
}
