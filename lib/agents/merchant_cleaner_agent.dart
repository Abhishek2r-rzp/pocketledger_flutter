import '../core/models/transaction.dart';
import 'agent_core/agent_protocol.dart';

class MerchantInput {
  final List<Transaction> transactions;

  const MerchantInput({required this.transactions});
}

class MerchantOutput {
  final List<Transaction> cleanedTransactions;

  const MerchantOutput({required this.cleanedTransactions});
}

class MerchantCleanerAgent implements Agent<MerchantInput, MerchantOutput> {
  @override
  String get name => 'MerchantCleanerAgent';

  @override
  String get purpose =>
      'Converts noisy descriptions into cleaner merchant names';

  static const Map<String, String> merchantPatterns = {
    'SWIGGY': 'Swiggy',
    'ZOMATO': 'Zomato',
    'AMAZON': 'Amazon',
    'UBER': 'Uber',
    'OLA': 'Ola',
    'FLIPKART': 'Flipkart',
    'MYNTRA': 'Myntra',
    'BIGBASKET': 'BigBasket',
    'ZEPTO': 'Zepto',
    'BLINKIT': 'Blinkit',
    'NETFLIX': 'Netflix',
    'SPOTIFY': 'Spotify',
    'PRIME VIDEO': 'Prime Video',
    'AIRTEL': 'Airtel',
    'JIO': 'Jio',
    'DMART': 'DMart',
    'RELIANCE FRESH': 'Reliance Fresh',
    'INDIANOIL': 'IndianOil',
    'BPCL': 'BPCL',
    'HPCL': 'HPCL',
    'IRCTC': 'IRCTC',
    'MAKEMYTRIP': 'MakeMyTrip',
    'ZERODHA': 'Zerodha',
    'GROWW': 'Groww',
    'APOLLO': 'Apollo',
    '1MG': '1mg',
    'PRACTO': 'Practo',
    'URBAN COMPANY': 'Urban Company',
    'SALARY': 'Salary',
    'RENT': 'Rent',
    'GOOGLE PAY': 'Google Pay',
    'PHONEPE': 'PhonePe',
    'PAYTM': 'Paytm',
    'GOOGLE PLAY': 'Google Play',
    'APPLE': 'Apple',
    'MCDONALD\'S': "McDonald's",
    'DOMINOS': "Domino's",
    'PIZZA HUT': 'Pizza Hut',
    'KFC': 'KFC',
    'STARBUCKS': 'Starbucks',
    'DUNKIN': "Dunkin'",
    'SUBWAY': 'Subway',
    'HDFC': 'HDFC',
    'ICICI': 'ICICI',
    'SBI': 'SBI',
    'AXIS': 'Axis',
    'KOTAK': 'Kotak',
    'YES BANK': 'Yes Bank',
    'LIC': 'LIC',
    'HUL': 'HUL',
    'TATA': 'Tata',
    'Reliance': 'Reliance',
    'AMAZON PAY': 'Amazon Pay',
    'NYKAA': 'Nykaa',
    'AJIO': 'Ajio',
    'MEESHO': 'Meesho',
    'TATACLIQ': 'Tata CLiQ',
  };

  ({String? merchant, double confidence, String explanation}) cleanMerchant(
      String description) {
    final upper = description.toUpperCase().trim();

    for (final entry in merchantPatterns.entries) {
      if (upper.contains(entry.key)) {
        return (
          merchant: entry.value,
          confidence: entry.key == upper ? 1.0 : 0.85,
          explanation:
              'Matched pattern "${entry.key}" -> "${entry.value}"',
        );
      }
    }

    final words = description.split(RegExp(r'\s+'));
    if (words.length <= 3 && words.any((w) => w.length > 2)) {
      final candidate = words.join(' ');
      return (
        merchant: candidate,
        confidence: 0.4,
        explanation: 'Short description used as merchant name',
      );
    }

    if (description.contains('UPI-') || description.contains('UPI/')) {
      final parts = description.split(RegExp(r'[/\-]'));
      if (parts.length >= 2) {
        return (
          merchant: parts[1].trim(),
          confidence: 0.5,
          explanation: 'Extracted merchant from UPI reference',
        );
      }
    }

    if (description.contains('IMPS') ||
        description.contains('NEFT') ||
        description.contains('RTGS')) {
      final parts = description.split(RegExp(r'[/\-]'));
      for (int i = 1; i < parts.length; i++) {
        final trimmed = parts[i].trim();
        if (trimmed.isNotEmpty &&
            !trimmed.contains('IMPS') &&
            !trimmed.contains('NEFT') &&
            !trimmed.contains('RTGS')) {
          return (
            merchant: trimmed,
            confidence: 0.45,
            explanation: 'Extracted from bank transfer reference',
          );
        }
      }
    }

    return (
      merchant: null,
      confidence: 0.0,
      explanation: 'No merchant pattern matched',
    );
  }

  @override
  Future<AgentResult<MerchantOutput>> run(MerchantInput input) async {
    try {
      final cleaned = <Transaction>[];
      int matched = 0;

      for (final tx in input.transactions) {
        final result = cleanMerchant(tx.description);
        cleaned.add(tx.copyWith(
          merchantName: result.merchant ?? tx.merchantName,
        ));
        if (result.merchant != null) matched++;
      }

      final matchRate =
          input.transactions.isEmpty ? 1.0 : matched / input.transactions.length;

      return AgentResult(
        status: AgentTaskStatus.completed,
        output: MerchantOutput(cleanedTransactions: cleaned),
        confidence: matchRate,
        explanation:
            'Cleaned $matched of ${input.transactions.length} merchant names (${(matchRate * 100).toStringAsFixed(0)}%)',
      );
    } catch (e) {
      return AgentResult(
        status: AgentTaskStatus.failed,
        confidence: 0,
        explanation: 'Merchant cleaning error: $e',
      );
    }
  }
}
