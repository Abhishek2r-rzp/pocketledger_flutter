import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/features/import/import_provider.dart';
import 'package:pocketledger/features/import/import_screen.dart';

class _PasswordPromptImportNotifier extends ImportNotifier {
  String? submittedPassword;

  _PasswordPromptImportNotifier() : super(DataRepository()..clearAllData()) {
    state = const ImportNeedsPassword(
      'locked_statement.pdf',
      fileType: 'pdf',
      message: 'That password did not unlock the PDF. Try again.',
    );
  }

  @override
  Future<void> processPdfWithPassword(String password) async {
    submittedPassword = password;
  }
}

void main() {
  testWidgets('password-protected PDF prompt submits password', (tester) async {
    final notifier = _PasswordPromptImportNotifier();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          importProvider.overrideWith((ref) => notifier),
        ],
        child: const MaterialApp(home: ImportScreen()),
      ),
    );

    expect(find.text('Password Protected PDF'), findsOneWidget);
    expect(find.text('locked_statement.pdf'), findsOneWidget);
    expect(find.text('That password did not unlock the PDF. Try again.'),
        findsOneWidget);

    await tester.enterText(find.byType(TextField), 'bank-password');
    await tester.tap(find.text('Unlock & Parse'));
    await tester.pump();

    expect(notifier.submittedPassword, 'bank-password');
  });
}
