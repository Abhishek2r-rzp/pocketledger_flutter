class PrivacyManager {
  String sanitizeForLogging(String text) {
    String result = text;

    result = result.replaceAllMapped(
      RegExp(r'[\w\.\-]+@[\w\-]+\.\w+'),
      (_) => '[EMAIL]',
    );

    result = result.replaceAllMapped(
      RegExp(r'\b\d{16}\b'),
      (_) => '[CARD_NUMBER]',
    );

    result = result.replaceAllMapped(
      RegExp(r'\b\d{10,12}\b'),
      (_) => '[ACCOUNT_NUMBER]',
    );

    result = result.replaceAllMapped(
      RegExp(r'\b\d{6}\b'),
      (_) => '[PIN]',
    );

    result = result.replaceAllMapped(
      RegExp(r'(?:UPI|PAYTM|PHONEPE|GOOGLEPAY)[-\s:]?[\w\.]+\@[\w]+', caseSensitive: false),
      (_) => '[UPI_ID]',
    );

    result = result.replaceAllMapped(
      RegExp(r'[\w\.]+@(?:upi|paytm|okaxis|oksbi|okicici|okhdfcbank)', caseSensitive: false),
      (_) => '[UPI_VPA]',
    );

    result = result.replaceAllMapped(
      RegExp(r'MOB\s*NO[:\s]*\d{10}'),
      (_) => '[MOBILE]',
    );

    result = result.replaceAllMapped(
      RegExp(r'\+\d{1,3}\s?\d{10}'),
      (_) => '[PHONE]',
    );

    result = result.replaceAllMapped(
      RegExp(r'[A-Z]{4}0[A-Z0-9]{6}'),
      (_) => '[IFSC]',
    );

    return result;
  }

  bool containsFinancialData(String text) {
    final patterns = [
      RegExp(r'\b\d{16}\b'),
      RegExp(r'\b\d{10,12}\b'),
      RegExp(r'(?:UPI|PAYTM|PHONEPE|GOOGLEPAY)[-\s:]?[\w\.]+\@[\w]+', caseSensitive: false),
      RegExp(r'[\w\.]+@(?:upi|paytm|okaxis|oksbi|okicici|okhdfcbank)', caseSensitive: false),
      RegExp(r'[A-Z]{4}0[A-Z0-9]{6}'),
      RegExp(r'(?:salary|deposit|withdrawal|transfer|credit|debit)\s*(?:rs|inr|₹)\s*\d+', caseSensitive: false),
      RegExp(r'(?:account|a/c|acc)\s*(?:no|number|#)[:\s]*\d+', caseSensitive: false),
    ];

    return patterns.any((p) => p.hasMatch(text));
  }
}
