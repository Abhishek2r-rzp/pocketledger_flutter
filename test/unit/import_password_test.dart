import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pocketledger/core/data_repository.dart';
import 'package:pocketledger/features/import/import_provider.dart';

void main() {
  group('ImportNotifier password handling', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('pocketledger_import_');
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    test('password-protected PDF enters password state', () async {
      final file = File('${tempDir.path}${Platform.pathSeparator}locked.pdf');
      file.writeAsStringSync(
          '%PDF-1.4\ntrailer\n<< /Size 1 /Root 1 0 R /Encrypt 2 0 R >>\n%%EOF');

      final notifier = ImportNotifier(DataRepository()..clearAllData());

      await notifier.processFile(file.path, 'locked.pdf');

      final state = notifier.state;
      expect(state, isA<ImportNeedsPassword>());
      expect((state as ImportNeedsPassword).fileName, 'locked.pdf');
      expect(state.fileType, 'pdf');
    });

    test('empty password keeps PDF in password state with message', () async {
      final file = File('${tempDir.path}${Platform.pathSeparator}locked.pdf');
      file.writeAsStringSync(
          '%PDF-1.4\ntrailer\n<< /Size 1 /Root 1 0 R /Encrypt 2 0 R >>\n%%EOF');

      final notifier = ImportNotifier(DataRepository()..clearAllData());

      await notifier.processFile(file.path, 'locked.pdf');
      await notifier.processPdfWithPassword('   ');

      final state = notifier.state;
      expect(state, isA<ImportNeedsPassword>());
      expect((state as ImportNeedsPassword).message,
          'Enter the PDF password to continue.');
    });
  });
}
