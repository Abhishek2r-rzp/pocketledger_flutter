import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/features/dashboard/dashboard_screen.dart';
import 'package:pocketledger/features/import/import_provider.dart';
import 'package:pocketledger/features/import/import_screen.dart';
import 'package:pocketledger/features/transactions/transactions_screen.dart';

String _createPasswordMarkedPdf(String content, String dirPath) {
  final lines = content.split('\n');
  final textOps = StringBuffer();
  for (final line in lines) {
    final escaped = line
        .replaceAll('\\', '\\\\')
        .replaceAll('(', '\\(')
        .replaceAll(')', '\\)');
    textOps.write('($escaped) Tj\n');
    textOps.write('0 -14 Td\n');
  }

  final streamContent = utf8.encode('BT\n/F1 10 Tf\n10 750 Td\n${textOps}ET\n');
  final bytes = BytesBuilder();

  void write(String value) => bytes.add(utf8.encode(value));
  void writeBytes(List<int> value) => bytes.add(value);

  write('%PDF-1.4\n');
  write('1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n');
  write('2 0 obj\n<< /Type /Pages /Kids [3 0 R] /Count 1 >>\nendobj\n');
  write(
    '3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792]\n'
    '   /Contents 4 0 R /Resources << /Font << /F1 5 0 R >> >> >>\nendobj\n',
  );
  write('4 0 obj\n<< /Length ${streamContent.length} >>\nstream\n');
  writeBytes(streamContent);
  write('\nendstream\nendobj\n');
  write(
    '5 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Courier >>\nendobj\n',
  );
  write('2 0 obj\n<< /Filter /Standard /V 1 /R 2 /Length 40 >>\nendobj\n');
  write(
    'trailer\n<< /Size 6 /Root 1 0 R /Encrypt 2 0 R >>\n%%EOF\n',
  );

  final file =
      File('$dirPath${Platform.pathSeparator}locked_bank_statement.pdf');
  file.writeAsBytesSync(bytes.toBytes());
  return file.path;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Password PDF import UI E2E', () {
    late Directory tempDir;
    late DataRepository repository;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('pocketledger_pdf_e2e_');
      repository = DataRepository()..clearAllData();
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    testWidgets(
      'uploads a password-protected PDF and shows imported transactions',
      (tester) async {
        final pdfText = [
          'Date                Description              Amount      Balance',
          '01/03/2025          SALARY CREDIT             85000       125000',
          '02/03/2025          SWIGGY FOOD               -450        124550',
          '03/03/2025          UBER RIDE                 -320        124230',
        ].join('\n');
        final pdfPath = _createPasswordMarkedPdf(pdfText, tempDir.path);

        final router = GoRouter(
          initialLocation: '/import',
          routes: [
            GoRoute(path: '/', builder: (_, __) => const DashboardScreen()),
            GoRoute(path: '/import', builder: (_, __) => const ImportScreen()),
            GoRoute(
              path: '/transactions',
              builder: (_, __) => const TransactionsScreen(),
            ),
          ],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              dataRepositoryProvider.overrideWithValue(repository),
            ],
            child: MaterialApp.router(routerConfig: router),
          ),
        );
        await tester.pump();

        expect(find.text('Import Statement'), findsOneWidget);
        expect(find.text('Select Bank Statement'), findsOneWidget);

        final container = ProviderScope.containerOf(
          tester.element(find.byType(ImportScreen)),
        );
        await tester.runAsync(() async {
          await container
              .read(importProvider.notifier)
              .processFile(pdfPath, 'locked_bank_statement.pdf');
        });
        await tester.pump();

        expect(find.text('Password Protected PDF'), findsOneWidget);
        expect(find.text('locked_bank_statement.pdf'), findsOneWidget);

        await tester.enterText(find.byType(TextField), 'statement-password');
        await tester.runAsync(() async {
          await container
              .read(importProvider.notifier)
              .processPdfWithPassword('statement-password');
        });
        await tester.pump();

        final previewState = container.read(importProvider);
        expect(previewState, isA<ImportPreview>());
        expect((previewState as ImportPreview).totalCount, 3);
        expect(find.text('Total transactions'), findsOneWidget);
        expect(find.text('3'), findsWidgets);

        await tester.tap(find.text('Confirm Import'));
        await tester.pumpAndSettle();

        expect(repository.transactions, hasLength(3));
        expect(repository.transactions.map((t) => t.description),
            contains('SWIGGY FOOD'));
        expect(repository.importBatches.single.fileType, 'pdf');

        router.go('/transactions');
        await tester.pumpAndSettle();

        expect(find.text('Transactions'), findsOneWidget);
        expect(find.text('SALARY CREDIT'), findsOneWidget);
        expect(find.text('SWIGGY FOOD'), findsOneWidget);
        expect(find.text('UBER RIDE'), findsOneWidget);
        expect(find.text('₹450.00'), findsOneWidget);
        expect(find.text('₹320.00'), findsOneWidget);
      },
    );
  });
}
