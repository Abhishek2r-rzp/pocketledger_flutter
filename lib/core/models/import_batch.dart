class ImportBatch {
  final String id;
  final String fileName;
  final String fileType;
  final String filePath;
  final int totalRows;
  final int importedRows;
  final int duplicateRows;
  final int failedRows;
  final DateTime createdAt;

  const ImportBatch({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.filePath,
    this.totalRows = 0,
    this.importedRows = 0,
    this.duplicateRows = 0,
    this.failedRows = 0,
    required this.createdAt,
  });
}
