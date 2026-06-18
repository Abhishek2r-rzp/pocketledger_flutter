import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../test_helpers.dart';

class MockImportViewModel {
  bool isImporting = false;
  bool isProcessing = false;
  String? lastErrorMessage;
  int? importedCount;
  int? duplicateCount;
  int? failedCount;
  List<Transaction> previewTransactions = [];
  bool hasCompleted = false;
}

final importViewModelProvider = Provider<MockImportViewModel>((ref) {
  return MockImportViewModel();
});

class ImportScreen extends ConsumerWidget {
  const ImportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(importViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Import Transactions')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Icon(Icons.cloud_upload, size: 80, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            const Text(
              'Import your bank statement',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select a CSV or PDF file to import transactions.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: vm.isImporting ? null : () {},
                icon: vm.isImporting
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.file_open),
                label: Text(vm.isImporting ? 'Importing...' : 'Select File'),
              ),
            ),
            if (vm.isProcessing) ...[
              const SizedBox(height: 24),
              const LinearProgressIndicator(),
              const SizedBox(height: 8),
              const Text('Processing your file...'),
            ],
            if (vm.previewTransactions.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Preview (${vm.previewTransactions.length} transactions)',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: vm.previewTransactions.length,
                  itemBuilder: (context, index) {
                    final txn = vm.previewTransactions[index];
                    return ListTile(
                      dense: true,
                      title: Text(txn.merchantName ?? txn.rawDescription),
                      subtitle: Text(txn.transactionDate.toString().split(' ')[0]),
                      trailing: Text('₹${txn.amount.toStringAsFixed(2)}'),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Confirm Import'),
              ),
            ],
            if (vm.hasCompleted) ...[
              const SizedBox(height: 24),
              Icon(Icons.check_circle, size: 48, color: Colors.green),
              Text('Successfully imported ${vm.importedCount} transactions'),
              if (vm.duplicateCount != null && vm.duplicateCount! > 0)
                Text('${vm.duplicateCount} duplicates skipped'),
              if (vm.failedCount != null && vm.failedCount! > 0)
                Text('${vm.failedCount} failed'),
            ],
            if (vm.lastErrorMessage != null) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(vm.lastErrorMessage!, style: TextStyle(color: Colors.red.shade800)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

void main() {
  group('ImportScreen', () {
    testWidgets('import button is visible', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const MaterialApp(home: ImportScreen()),
        ),
      );

      expect(find.text('Select File'), findsOneWidget);
      expect(find.byIcon(Icons.file_open), findsOneWidget);
    });

    testWidgets('import title and description are visible', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const MaterialApp(home: ImportScreen()),
        ),
      );

      expect(find.text('Import Transactions'), findsOneWidget);
      expect(find.text('Import your bank statement'), findsOneWidget);
      expect(find.text('Select a CSV or PDF file to import transactions.'), findsOneWidget);
    });

    testWidgets('upload icon is displayed', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const MaterialApp(home: ImportScreen()),
        ),
      );

      expect(find.byIcon(Icons.cloud_upload), findsOneWidget);
    });

    testWidgets('processing indicator shows during import', (tester) async {
      final vm = MockImportViewModel();
      vm.isProcessing = true;
      vm.isImporting = true;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importViewModelProvider.overrideWith((ref) => vm),
          ],
          child: const MaterialApp(home: ImportScreen()),
        ),
      );

      expect(find.text('Importing...'), findsOneWidget);
      expect(find.text('Processing your file...'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('preview shows results after import', (tester) async {
      final vm = MockImportViewModel();
      vm.previewTransactions = [
        createTestTransaction(
          id: '1', merchantName: 'Swiggy', amount: 450.0,
          transactionDate: DateTime(2025, 3, 1),
        ),
        createTestTransaction(
          id: '2', merchantName: 'Amazon', amount: 1299.0,
          transactionDate: DateTime(2025, 3, 3),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importViewModelProvider.overrideWith((ref) => vm),
          ],
          child: const MaterialApp(home: ImportScreen()),
        ),
      );

      expect(find.text('Preview (2 transactions)'), findsOneWidget);
      expect(find.text('Swiggy'), findsOneWidget);
      expect(find.text('Amazon'), findsOneWidget);
      expect(find.text('Confirm Import'), findsOneWidget);
    });

    testWidgets('button is disabled while importing', (tester) async {
      final vm = MockImportViewModel();
      vm.isImporting = true;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importViewModelProvider.overrideWith((ref) => vm),
          ],
          child: const MaterialApp(home: ImportScreen()),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('success state shows import summary', (tester) async {
      final vm = MockImportViewModel();
      vm.hasCompleted = true;
      vm.importedCount = 10;
      vm.duplicateCount = 2;
      vm.failedCount = 1;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importViewModelProvider.overrideWith((ref) => vm),
          ],
          child: const MaterialApp(home: ImportScreen()),
        ),
      );

      expect(find.text('Successfully imported 10 transactions'), findsOneWidget);
      expect(find.text('2 duplicates skipped'), findsOneWidget);
      expect(find.text('1 failed'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('error state shows error message', (tester) async {
      final vm = MockImportViewModel();
      vm.lastErrorMessage = 'Failed to parse CSV file';

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importViewModelProvider.overrideWith((ref) => vm),
          ],
          child: const MaterialApp(home: ImportScreen()),
        ),
      );

      expect(find.text('Failed to parse CSV file'), findsOneWidget);
    });

    testWidgets('no duplicates message hidden when zero', (tester) async {
      final vm = MockImportViewModel();
      vm.hasCompleted = true;
      vm.importedCount = 10;
      vm.duplicateCount = 0;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importViewModelProvider.overrideWith((ref) => vm),
          ],
          child: const MaterialApp(home: ImportScreen()),
        ),
      );

      expect(find.text('0 duplicates skipped'), findsNothing);
    });

    testWidgets('no failed message hidden when zero', (tester) async {
      final vm = MockImportViewModel();
      vm.hasCompleted = true;
      vm.importedCount = 10;
      vm.failedCount = 0;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importViewModelProvider.overrideWith((ref) => vm),
          ],
          child: const MaterialApp(home: ImportScreen()),
        ),
      );

      expect(find.text('0 failed'), findsNothing);
    });
  });
}
