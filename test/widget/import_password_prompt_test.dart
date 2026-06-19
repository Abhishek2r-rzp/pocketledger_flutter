import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/features/import/import_provider.dart';
import 'package:pocketledger/features/import/import_screen.dart';

void main() {
  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('pocketledger_import_ui_');
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  testWidgets('password-protected PDF prompt validates empty password',
      (tester) async {
    final repository = DataRepository()..clearAllData();
    final container = ProviderContainer(
      overrides: [
        dataRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    final file =
        File('${tempDir.path}${Platform.pathSeparator}locked_statement.pdf');
    file.writeAsStringSync(
        '%PDF-1.4\ntrailer\n<< /Size 1 /Root 1 0 R /Encrypt 2 0 R >>\n%%EOF');

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) {
                final state = ref.watch(importProvider);
                if (state is! ImportNeedsPassword) {
                  return const SizedBox.shrink();
                }

                return PasswordPrompt(
                  fileName: state.fileName,
                  fileType: state.fileType,
                  message: state.message,
                  onSubmit: (password) => ref
                      .read(importProvider.notifier)
                      .processPdfWithPassword(password),
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.runAsync(() async {
      await container
          .read(importProvider.notifier)
          .processFile(file.path, 'locked_statement.pdf');
    });
    await tester.pump();

    expect(find.text('Password Protected PDF'), findsOneWidget);
    expect(find.text('locked_statement.pdf'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(find.text('Unlock & Parse'));
    await tester.pump();

    expect(find.text('Enter the PDF password to continue.'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
