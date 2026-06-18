import 'package:pocketledger/core/models/parsed_transaction_draft.dart';

class XLSXParser {
  Future<List<ParsedTransactionDraft>> parse(String filePath) async {
    throw UnsupportedError(
      'XLSX support requires CSV conversion. Please export your file as CSV format and try again.',
    );
  }
}
