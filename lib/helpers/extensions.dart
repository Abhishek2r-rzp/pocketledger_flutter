import 'package:intl/intl.dart';

extension DateTimeFormatting on DateTime {
  String get formatted => DateFormat('dd MMM yyyy').format(this);
  String get formattedWithTime => DateFormat('dd MMM yyyy, HH:mm').format(this);
  String get monthYear => DateFormat('MMM yyyy').format(this);
  String get dayMonth => DateFormat('dd MMM').format(this);
  String get iso => DateFormat('yyyy-MM-dd').format(this);
  String get monthName => DateFormat('MMMM').format(this);
  String get yearString => DateFormat('yyyy').format(this);
  String get shortDate => DateFormat('dd/MM/yy').format(this);

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}

extension StringNormalization on String {
  String get normalized {
    return trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .toLowerCase();
  }

  String get normalizeMerchant {
    return trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .toLowerCase()
        .replaceAll(RegExp(r'(?:pvt\s*ltd|ltd|private\s*limited|inc|corp|llc)'), '')
        .trim();
  }

  bool fuzzyMatches(String pattern) {
    return normalized.contains(pattern.normalized);
  }

  bool get looksLikeTransactionDescription {
    return length > 5 &&
        contains(RegExp(r'[A-Za-z]')) &&
        !startsWith(RegExp(r'[0-9]{10,}'));
  }
}

extension DoubleFormatting on double {
  String get toIndianRupee {
    final formatter = NumberFormat.currency(
      symbol: '₹',
      locale: 'en_IN',
      decimalDigits: 2,
    );
    return formatter.format(this);
  }

  String get toIndianRupeeWithoutDecimal {
    final formatter = NumberFormat.currency(
      symbol: '₹',
      locale: 'en_IN',
      decimalDigits: 0,
    );
    return formatter.format(this);
  }

  String toCurrency(String currencyCode) {
    if (currencyCode == 'INR') return toIndianRupee;
    try {
      final formatter = NumberFormat.currency(
        symbol: _currencySymbol(currencyCode),
        decimalDigits: 2,
      );
      return formatter.format(this);
    } catch (_) {
      return '$currencyCode ${toStringAsFixed(2)}';
    }
  }

  String get toPercentage => '${toStringAsFixed(1)}%';

  String get toShortForm {
    if (this >= 10000000) {
      return '${(this / 10000000).toStringAsFixed(2)}Cr';
    } else if (this >= 100000) {
      return '${(this / 100000).toStringAsFixed(2)}L';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toStringAsFixed(0);
  }

  String toFormatted({int decimals = 2}) {
    final formatter = NumberFormat('#,##0.${'0' * decimals}');
    return formatter.format(this);
  }
}

String _currencySymbol(String code) {
  switch (code.toUpperCase()) {
    case 'INR':
      return '₹';
    case 'USD':
      return '\$';
    case 'EUR':
      return '€';
    case 'GBP':
      return '£';
    case 'AED':
      return 'د.إ';
    case 'SGD':
      return 'S\$';
    case 'CAD':
      return 'C\$';
    case 'AUD':
      return 'A\$';
    default:
      return '$code ';
  }
}

extension CurrencyFormatting on String {
  String toCurrencySymbol() => _currencySymbol(this);
}

extension EnumParsing on String {
  T? toEnum<T>(List<T> values) {
    for (final value in values) {
      if (value.toString().split('.').last == this) return value;
    }
    return null;
  }
}
