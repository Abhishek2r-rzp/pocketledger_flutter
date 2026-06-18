import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../core/models/import_batch.dart';
import 'agent_core/agent_protocol.dart';

const _uuid = Uuid();

class FileImportInput {
  final String filePath;
  final String fileName;

  const FileImportInput({
    required this.filePath,
    required this.fileName,
  });
}

class FileImportOutput {
  final ImportBatch importBatch;
  final String localCopyPath;

  const FileImportOutput({
    required this.importBatch,
    required this.localCopyPath,
  });
}

class FileImportAgent implements Agent<FileImportInput, FileImportOutput> {
  @override
  String get name => 'FileImportAgent';

  @override
  String get purpose =>
      'Receives user-selected file, detects type, copies to secure local storage';

  Future<String> detectFileType(String fileName) async {
    final ext = p.extension(fileName).toLowerCase();
    switch (ext) {
      case '.csv':
        return 'csv';
      case '.pdf':
        return 'pdf';
      case '.tsv':
        return 'tsv';
      case '.xlsx':
        return 'xlsx';
      case '.ofx':
        return 'ofx';
      case '.qif':
        return 'qif';
      default:
        return 'unknown';
    }
  }

  Future<String> copyToSecureStorage(
      String sourcePath, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final importDir = Directory(p.join(dir.path, 'imports'));
    if (!await importDir.exists()) {
      await importDir.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final safeName = '${timestamp}_${p.basename(fileName)}';
    final destPath = p.join(importDir.path, safeName);

    await File(sourcePath).copy(destPath);
    return destPath;
  }

  @override
  Future<AgentResult<FileImportOutput>> run(FileImportInput input) async {
    try {
      final fileType = await detectFileType(input.fileName);
      if (fileType == 'unknown') {
        return AgentResult(
          status: AgentTaskStatus.failed,
          confidence: 0,
          explanation:
              'Unsupported file type: ${p.extension(input.fileName)}',
        );
      }

      final sourceFile = File(input.filePath);
      if (!await sourceFile.exists()) {
        return AgentResult(
          status: AgentTaskStatus.failed,
          confidence: 0,
          explanation: 'File not found at path: ${input.filePath}',
        );
      }

      final localCopyPath = await copyToSecureStorage(
          input.filePath, input.fileName);

      final importBatch = ImportBatch(
        id: _uuid.v4(),
        fileName: input.fileName,
        fileType: fileType,
        filePath: localCopyPath,
        totalRows: 0,
        importedRows: 0,
        duplicateRows: 0,
        failedRows: 0,
        createdAt: DateTime.now(),
      );

      return AgentResult(
        status: AgentTaskStatus.completed,
        output: FileImportOutput(
          importBatch: importBatch,
          localCopyPath: localCopyPath,
        ),
        confidence: 1.0,
        explanation: 'File imported as $fileType: ${input.fileName}',
      );
    } catch (e) {
      return AgentResult(
        status: AgentTaskStatus.failed,
        confidence: 0,
        explanation: 'File import error: $e',
      );
    }
  }
}
