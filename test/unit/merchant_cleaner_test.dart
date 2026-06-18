import 'package:flutter_test/flutter_test.dart';

class MerchantResult {
  final String? merchantName;
  final double confidence;

  const MerchantResult({this.merchantName, this.confidence = 0.0});
}

Map<String, String> knownMerchants = {
  'swiggy': 'Swiggy',
  'zomato': 'Zomato',
  'amazon': 'Amazon',
  'flipkart': 'Flipkart',
  'uber': 'Uber',
  'ola': 'Ola',
  'netflix': 'Netflix',
  'hotstar': 'Disney+ Hotstar',
  'prime video': 'Amazon Prime Video',
  'zeetv': 'Zee5',
  'jio': 'Jio',
  'airtel': 'Airtel',
  'vi': 'Vi',
  'bsnl': 'BSNL',
  'tata power': 'Tata Power',
  'adani': 'Adani Electricity',
  'mumbai': 'Mumbai',
  'bangalore': 'Bangalore',
  'indian oil': 'Indian Oil',
  'hp petrol': 'HP Petrol',
  'bharat petroleum': 'Bharat Petroleum',
  'dmart': 'DMart',
  'bigbasket': 'BigBasket',
  'grofers': 'Blinkit',
  'zepto': 'Zepto',
  'blinkit': 'Blinkit',
  'instamart': 'Swiggy Instamart',
  'myntra': 'Myntra',
  'nykaa': 'Nykaa',
  'ajio': 'Ajio',
  'meesho': 'Meesho',
  'paytm': 'Paytm',
  'phonepe': 'PhonePe',
  'google pay': 'Google Pay',
  'zoho': 'Zoho',
  'freshworks': 'Freshworks',
  'razorpay': 'Razorpay',
  'salary': 'Salary',
  'rent': 'Rent',
  'credit card': 'Credit Card',
  'electricity': 'Electricity Bill',
  'water': 'Water Bill',
  'gas': 'Gas Bill',
  'insurance': 'Insurance',
  'mutual fund': 'Mutual Fund',
  'stock': 'Stock Trading',
  'lpg': 'LPG Subsidy',
  'pf': 'Provident Fund',
};

MerchantResult cleanMerchant(String rawDescription) {
  if (rawDescription.isEmpty) {
    return const MerchantResult(merchantName: null, confidence: 0.0);
  }

  String text = rawDescription.toUpperCase().trim();
  final originalText = text;

  final prefixes = [
    'UPI-', 'NEFT-', 'RTGS-', 'IMPS-', 'REF-', 'CHQ-', 'ECS-',
  ];
  for (final prefix in prefixes) {
    if (text.startsWith(prefix)) {
      text = text.substring(prefix.length);
      break;
    }
  }

  text = text.trim();

  final stopWords = [
    'PAYMENT', 'CREDIT', 'DEBIT', 'TRANSFER', 'BILL', 'ORDER', 'BILL PAYMENT',
    'SUBSCRIPTION', 'RECHARGE', 'REFUND', 'REVERSAL', 'FEE', 'CHARGE', 'TXN',
    'TRANSACTION', 'ONLINE', 'POS', 'ATM', 'ECS', 'ACH', 'WIRE',
  ];

  for (final stopWord in stopWords) {
    if (text == stopWord) {
      return const MerchantResult(merchantName: null, confidence: 0.0);
    }
    if (text.startsWith('$stopWord ')) {
      text = text.substring(stopWord.length).trim();
    }
    if (text.endsWith(' $stopWord')) {
      text = text.substring(0, text.length - stopWord.length - 1).trim();
    }
  }

  if (text.startsWith('ATM ')) {
    return const MerchantResult(merchantName: null, confidence: 0.0);
  }

  if (text == 'SALARY' || text.startsWith('SALARY ')) {
    return const MerchantResult(merchantName: 'Salary', confidence: 0.95);
  }

  if (text == 'RENT' || text.startsWith('RENT ')) {
    return const MerchantResult(merchantName: 'Rent', confidence: 0.9);
  }

  for (final entry in knownMerchants.entries) {
    if (text.contains(entry.key.toUpperCase())) {
      double confidence = 1.0;

      if (text.startsWith(entry.key.toUpperCase()) || text == entry.key.toUpperCase()) {
        confidence = 0.95;
      } else if (text.contains(entry.key.toUpperCase())) {
        confidence = 0.85;
      }

      for (final stopWord in stopWords) {
        if (originalText.contains(stopWord)) {
          confidence -= 0.05;
        }
      }

      return MerchantResult(
        merchantName: entry.value,
        confidence: confidence.clamp(0.0, 1.0),
      );
    }
  }

  return const MerchantResult(merchantName: null, confidence: 0.0);
}

void main() {
  group('MerchantCleaner - known merchants', () {
    test("'UPI-SWIGGY-ORDER-1234' extracts 'Swiggy'", () {
      final result = cleanMerchant('UPI-SWIGGY-ORDER-1234');
      expect(result.merchantName, 'Swiggy');
      expect(result.confidence, greaterThan(0));
    });

    test("'UPI-ZOMATO-ORDER' extracts 'Zomato'", () {
      final result = cleanMerchant('UPI-ZOMATO-ORDER');
      expect(result.merchantName, 'Zomato');
    });

    test("'ZOMATO LIMITED' extracts 'Zomato'", () {
      final result = cleanMerchant('ZOMATO LIMITED');
      expect(result.merchantName, 'Zomato');
    });

    test("'AMAZON PAY INDIA' extracts 'Amazon'", () {
      final result = cleanMerchant('AMAZON PAY INDIA');
      expect(result.merchantName, 'Amazon');
    });

    test("'UPI-UBER-INDIA' extracts 'Uber'", () {
      final result = cleanMerchant('UPI-UBER-INDIA');
      expect(result.merchantName, 'Uber');
    });

    test("'NETFLIX SUBSCRIPTION' extracts 'Netflix'", () {
      final result = cleanMerchant('NETFLIX SUBSCRIPTION');
      expect(result.merchantName, 'Netflix');
    });

    test("'SALARY CREDIT' extracts 'Salary'", () {
      final result = cleanMerchant('SALARY CREDIT');
      expect(result.merchantName, 'Salary');
      expect(result.confidence, greaterThanOrEqualTo(0.9));
    });

    test("'DMART GROCERY' extracts 'DMart'", () {
      final result = cleanMerchant('DMART GROCERY');
      expect(result.merchantName, 'DMart');
    });

    test("'BIGBASKET ORDER' extracts 'BigBasket'", () {
      final result = cleanMerchant('BIGBASKET ORDER');
      expect(result.merchantName, 'BigBasket');
    });

    test("'FLIPKART ONLINE' extracts 'Flipkart'", () {
      final result = cleanMerchant('FLIPKART ONLINE');
      expect(result.merchantName, 'Flipkart');
    });
  });

  group('MerchantCleaner - special cases', () {
    test("'NEFT-UTILITY-PAYMENT' returns null (unknown)", () {
      final result = cleanMerchant('NEFT-UTILITY-PAYMENT');
      expect(result.merchantName, isNull);
      expect(result.confidence, 0.0);
    });

    test("'NEFT-ELECTRICITY-BILL' extracts 'Electricity Bill'", () {
      final result = cleanMerchant('NEFT-ELECTRICITY-BILL');
      expect(result.merchantName, 'Electricity Bill');
    });

    test("'ATM CASH WITHDRAWAL' returns null merchant", () {
      final result = cleanMerchant('ATM CASH WITHDRAWAL');
      expect(result.merchantName, isNull);
      expect(result.confidence, 0.0);
    });
  });

  group('MerchantCleaner - unknown descriptions', () {
    test('completely unknown description returns merchant null', () {
      final result = cleanMerchant('XYZ RANDOM TEXT 12345');
      expect(result.merchantName, isNull);
      expect(result.confidence, 0.0);
    });

    test('random alphanumeric returns merchant null', () {
      final result = cleanMerchant('ABCD1234EFGH5678');
      expect(result.merchantName, isNull);
      expect(result.confidence, 0.0);
    });

    test('short code returns merchant null', () {
      final result = cleanMerchant('REF12345');
      expect(result.merchantName, isNull);
      expect(result.confidence, 0.0);
    });
  });

  group('MerchantCleaner - empty and edge cases', () {
    test('empty description returns merchant null', () {
      final result = cleanMerchant('');
      expect(result.merchantName, isNull);
      expect(result.confidence, 0.0);
    });

    test('only stop words returns merchant null', () {
      final result = cleanMerchant('PAYMENT');
      expect(result.merchantName, isNull);
      expect(result.confidence, 0.0);
    });

    test('UPI prefix only returns merchant null', () {
      final result = cleanMerchant('UPI-');
      expect(result.merchantName, isNull);
      expect(result.confidence, 0.0);
    });

    test('whitespace only returns merchant null', () {
      final result = cleanMerchant('   ');
      expect(result.merchantName, isNull);
      expect(result.confidence, 0.0);
    });
  });

  group('MerchantCleaner - confidence scoring', () {
    test('exact match has high confidence', () {
      final result = cleanMerchant('SWIGGY');
      expect(result.confidence, greaterThanOrEqualTo(0.9));
    });

    test('partial match has reasonable confidence', () {
      final result = cleanMerchant('UPI-SWIGGY-ORDER');
      expect(result.confidence, greaterThanOrEqualTo(0.8));
    });

    test('known merchant with stop words has slightly lower confidence', () {
      final cleanHigh = cleanMerchant('NETFLIX');
      final cleanLow = cleanMerchant('NETFLIX SUBSCRIPTION PAYMENT');
      expect(cleanLow.confidence, lessThan(cleanHigh.confidence));
    });
  });

  group('MerchantCleaner - case insensitivity', () {
    test('lowercase input works', () {
      final result = cleanMerchant('swiggy order');
      expect(result.merchantName, 'Swiggy');
    });

    test('mixed case input works', () {
      expect(cleanMerchant('SwIgGy OrDeR').merchantName, 'Swiggy');
    });
  });

  group('MerchantCleaner - RENT extraction', () {
    test("'RENT PAYMENT' extracts 'Rent'", () {
      final result = cleanMerchant('RENT PAYMENT');
      expect(result.merchantName, 'Rent');
      expect(result.confidence, 0.9);
    });

    test("'ECS-RENT' extracts 'Rent'", () {
      final result = cleanMerchant('ECS-RENT');
      expect(result.merchantName, 'Rent');
    });
  });
}
