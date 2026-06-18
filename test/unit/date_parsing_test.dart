import 'package:flutter_test/flutter_test.dart';

DateTime? parseDateFlexible(String value) {
  if (value.isEmpty) return null;
  final formats = [
    {'regex': r'^(\d{2})/(\d{2})/(\d{2})$', 'order': 'dmy', 'century': 2000},
    {'regex': r'^(\d{2})-(\d{2})-(\d{4})$', 'order': 'dmy', 'century': null},
    {'regex': r'^(\d{4})-(\d{2})-(\d{2})$', 'order': 'ymd', 'century': null},
    {'regex': r'^(\d{2})/(\d{2})/(\d{4})$', 'order': 'dmy', 'century': null},
    {'regex': r'^(\d{2})-(\d{2})-(\d{2})$', 'order': 'dmy', 'century': 2000},
    {'regex': r'^(\d{4})/(\d{2})/(\d{2})$', 'order': 'ymd', 'century': null},
    {'regex': r'^(\d{1,2})-([A-Za-z]{3})-(\d{4})$', 'order': 'dMy', 'century': null},
    {'regex': r'^(\d{1,2})\.(\d{2})\.(\d{4})$', 'order': 'dmy', 'century': null},
    {'regex': r'^(\d{1,2})\.(\d{2})\.(\d{2})$', 'order': 'dmy', 'century': 2000},
    {'regex': r'^(\d{4})\.(\d{2})\.(\d{2})$', 'order': 'ymd', 'century': null},
    {'regex': r'^(\d{1,2}) ([A-Za-z]{3}) (\d{4})$', 'order': 'dMy', 'century': null},
    {'regex': r'^(\d{2}) ([A-Za-z]+) (\d{4})$', 'order': 'dMy', 'century': null},
    {'regex': r'^([A-Za-z]{3}) (\d{1,2}), (\d{4})$', 'order': 'Mdy', 'century': null},
    {'regex': r'^(\d{2})/([A-Za-z]{3})/(\d{4})$', 'order': 'dMy', 'century': null},
  ];

  for (final fmt in formats) {
    final regex = RegExp(fmt['regex'] as String);
    final match = regex.firstMatch(value);
    if (match != null) {
      final order = fmt['order'] as String;
      try {
        if (order == 'dmy') {
          int day = int.parse(match.group(1)!);
          int month = int.parse(match.group(2)!);
          int year = int.parse(match.group(3)!);
          if (fmt['century'] != null) {
            if (year >= 70) {
              year += 1900;
            } else {
              year += fmt['century'] as int;
            }
          }
          return DateTime(year, month, day);
        } else if (order == 'ymd') {
          int year = int.parse(match.group(1)!);
          int month = int.parse(match.group(2)!);
          int day = int.parse(match.group(3)!);
          return DateTime(year, month, day);
        } else if (order == 'dMy') {
          int day = int.parse(match.group(1)!);
          final monthStr = match.group(2)!;
          const months = {
            'jan': 1, 'january': 1,
            'feb': 2, 'february': 2,
            'mar': 3, 'march': 3,
            'apr': 4, 'april': 4,
            'may': 5,
            'jun': 6, 'june': 6,
            'jul': 7, 'july': 7,
            'aug': 8, 'august': 8,
            'sep': 9, 'september': 9,
            'oct': 10, 'october': 10,
            'nov': 11, 'november': 11,
            'dec': 12, 'december': 12,
          };
          final month = months[monthStr.toLowerCase()];
          if (month == null) return null;
          int year = int.parse(match.group(3)!);
          return DateTime(year, month, day);
        } else if (order == 'Mdy') {
          final monthStr = match.group(1)!;
          int day = int.parse(match.group(2)!);
          int year = int.parse(match.group(3)!);
          const months = {
            'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
            'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
          };
          final month = months[monthStr.toLowerCase().substring(0, 3)];
          if (month == null) return null;
          return DateTime(year, month, day);
        }
      } catch (_) {
        return null;
      }
    }
  }
  return null;
}

void main() {
  group('DateParser - format 1: dd/MM/yy', () {
    test('parses 01/03/25', () {
      expect(parseDateFlexible('01/03/25'), DateTime(2025, 3, 1));
    });
    test('parses 15/12/24', () {
      expect(parseDateFlexible('15/12/24'), DateTime(2024, 12, 15));
    });
    test('parses 31/01/23', () {
      expect(parseDateFlexible('31/01/23'), DateTime(2023, 1, 31));
    });
  });

  group('DateParser - format 2: dd-MM-yyyy', () {
    test('parses 01-03-2025', () {
      expect(parseDateFlexible('01-03-2025'), DateTime(2025, 3, 1));
    });
    test('parses 25-12-2024', () {
      expect(parseDateFlexible('25-12-2024'), DateTime(2024, 12, 25));
    });
  });

  group('DateParser - format 3: yyyy-MM-dd', () {
    test('parses 2025-03-01', () {
      expect(parseDateFlexible('2025-03-01'), DateTime(2025, 3, 1));
    });
    test('parses 2024-12-25', () {
      expect(parseDateFlexible('2024-12-25'), DateTime(2024, 12, 25));
    });
  });

  group('DateParser - format 4: dd/MM/yyyy', () {
    test('parses 01/03/2025', () {
      expect(parseDateFlexible('01/03/2025'), DateTime(2025, 3, 1));
    });
    test('parses 25/12/2024', () {
      expect(parseDateFlexible('25/12/2024'), DateTime(2024, 12, 25));
    });
  });

  group('DateParser - format 5: dd-MM-yy', () {
    test('parses 01-03-25', () {
      expect(parseDateFlexible('01-03-25'), DateTime(2025, 3, 1));
    });
    test('parses 25-12-24', () {
      expect(parseDateFlexible('25-12-24'), DateTime(2024, 12, 25));
    });
  });

  group('DateParser - format 6: yyyy/MM/dd', () {
    test('parses 2025/03/01', () {
      expect(parseDateFlexible('2025/03/01'), DateTime(2025, 3, 1));
    });
  });

  group('DateParser - format 7: dd-MMM-yyyy', () {
    test('parses 15-Mar-2025', () {
      expect(parseDateFlexible('15-Mar-2025'), DateTime(2025, 3, 15));
    });
    test('parses 01-Jan-2025', () {
      expect(parseDateFlexible('01-Jan-2025'), DateTime(2025, 1, 1));
    });
    test('parses 25-Dec-2024', () {
      expect(parseDateFlexible('25-Dec-2024'), DateTime(2024, 12, 25));
    });
  });

  group('DateParser - format 8: dd.MM.yyyy', () {
    test('parses 01.03.2025', () {
      expect(parseDateFlexible('01.03.2025'), DateTime(2025, 3, 1));
    });
  });

  group('DateParser - format 9: dd.MM.yy', () {
    test('parses 01.03.25', () {
      expect(parseDateFlexible('01.03.25'), DateTime(2025, 3, 1));
    });
  });

  group('DateParser - format 10: yyyy.MM.dd', () {
    test('parses 2025.03.01', () {
      expect(parseDateFlexible('2025.03.01'), DateTime(2025, 3, 1));
    });
  });

  group('DateParser - format 11: dd MMM yyyy', () {
    test('parses 15 Mar 2025', () {
      expect(parseDateFlexible('15 Mar 2025'), DateTime(2025, 3, 15));
    });
    test('parses 1 Jan 2025', () {
      expect(parseDateFlexible('1 Jan 2025'), DateTime(2025, 1, 1));
    });
  });

  group('DateParser - format 12: dd MMMM yyyy', () {
    test('parses 15 March 2025', () {
      expect(parseDateFlexible('15 March 2025'), DateTime(2025, 3, 15));
    });
    test('parses 01 January 2025', () {
      expect(parseDateFlexible('01 January 2025'), DateTime(2025, 1, 1));
    });
  });

  group('DateParser - format 13: MMM dd, yyyy', () {
    test('parses Mar 15, 2025', () {
      expect(parseDateFlexible('Mar 15, 2025'), DateTime(2025, 3, 15));
    });
    test('parses Jan 1, 2025', () {
      expect(parseDateFlexible('Jan 1, 2025'), DateTime(2025, 1, 1));
    });
  });

  group('DateParser - format 14: dd/MMM/yyyy', () {
    test('parses 15/Mar/2025', () {
      expect(parseDateFlexible('15/Mar/2025'), DateTime(2025, 3, 15));
    });
    test('parses 01/Jan/2025', () {
      expect(parseDateFlexible('01/Jan/2025'), DateTime(2025, 1, 1));
    });
  });

  group('DateParser - invalid dates', () {
    test('returns null for empty string', () {
      expect(parseDateFlexible(''), isNull);
    });

    test('returns null for completely invalid format', () {
      expect(parseDateFlexible('not-a-date'), isNull);
    });

    test('returns null for random string', () {
      expect(parseDateFlexible('abc-def-ghi'), isNull);
    });

    test('returns null for numbers-only without separator', () {
      expect(parseDateFlexible('20250301'), isNull);
    });
  });

  group('DateParser - edge cases', () {
    test('handles last day of month', () {
      expect(parseDateFlexible('31/01/25'), DateTime(2025, 1, 31));
    });

    test('handles february leap year', () {
      expect(parseDateFlexible('29/02/2024'), DateTime(2024, 2, 29));
    });

    test('handles single digit day with dd/MM/yy', () {
      expect(parseDateFlexible('01/03/25'), DateTime(2025, 3, 1));
    });

    test('parses date with year 70+ as 1900s', () {
      expect(parseDateFlexible('01/01/70'), DateTime(1970, 1, 1));
      expect(parseDateFlexible('31/12/99'), DateTime(1999, 12, 31));
    });

    test('parses date with year <70 as 2000s', () {
      expect(parseDateFlexible('01/01/25'), DateTime(2025, 1, 1));
      expect(parseDateFlexible('31/12/24'), DateTime(2024, 12, 31));
    });
  });
}
