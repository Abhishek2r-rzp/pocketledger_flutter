import 'package:flutter_test/flutter_test.dart';
import 'package:pocketledger/core/data_repository.dart';

void main() {
  group('DataRepository', () {
    test('starts without mock financial records', () {
      final repository = DataRepository();

      expect(repository.transactions, isEmpty);
      expect(repository.importBatches, isEmpty);
      expect(repository.reviewItems, isEmpty);
      expect(repository.budgets, isEmpty);
      expect(repository.recurringPayments, isEmpty);
      expect(repository.agentLogs, isEmpty);
      expect(repository.labels, isEmpty);
      expect(repository.creditCards, isEmpty);
      expect(repository.accounts, isEmpty);
      expect(repository.categories, isNotEmpty);
    });
  });
}
