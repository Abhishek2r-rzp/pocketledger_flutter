import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFF0A0E1A);
  static const Color surface = Color(0xFF111827);
  static const Color surfaceLight = Color(0xFF1F2937);
  static const Color cardGlass = Color(0x14FFFFFF);
  static const Color cardGlassBorder = Color(0x1AFFFFFF);
  static const Color cardGlassHighlight = Color(0x08FFFFFF);

  static const Color primary = Color(0xFF7C5CFC);
  static const Color primaryLight = Color(0xFFA78BFA);
  static const Color primaryDark = Color(0xFF5B3DC4);

  static const Color accent = Color(0xFF00D4AA);
  static const Color accentLight = Color(0xFF5EEAD4);

  static const Color income = Color(0xFF00D4AA);
  static const Color expense = Color(0xFFFF4757);
  static const Color warning = Color(0xFFF77F00);
  static const Color info = Color(0xFF60A5FA);

  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textTertiary = Color(0xFF64748B);

  static const Color shimmerBase = Color(0x1AFFFFFF);
  static const Color shimmerHighlight = Color(0x30FFFFFF);

  static const Color error = Color(0xFFFF4757);
  static const Color success = Color(0xFF00D4AA);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7C5CFC), Color(0xFFA78BFA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF00D4AA), Color(0xFF5EEAD4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient incomeGradient = LinearGradient(
    colors: [Color(0xFF00D4AA), Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient expenseGradient = LinearGradient(
    colors: [Color(0xFFFF4757), Color(0xFFFB7185)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFF111827), Color(0xFF1A1F2E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const List<Color> chartColors = [
    Color(0xFF7C5CFC),
    Color(0xFF00D4AA),
    Color(0xFFFF4757),
    Color(0xFFF77F00),
    Color(0xFF60A5FA),
    Color(0xFFEC4899),
    Color(0xFF8B5CF6),
    Color(0xFF14B8A6),
  ];
}
