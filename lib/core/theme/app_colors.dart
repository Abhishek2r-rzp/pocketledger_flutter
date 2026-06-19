import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFFF7F2E8);
  static const Color backgroundWarm = Color(0xFFFFFBF2);
  static const Color surface = Color(0xFFFFFCF7);
  static const Color surfaceLight = Color(0xFFF0E7D8);
  static const Color cardGlass = Color(0xBFFFFFFF);
  static const Color cardGlassBorder = Color(0xCCFFFFFF);
  static const Color cardGlassHighlight = Color(0xF2FFFFFF);

  static const Color primary = Color(0xFF7EA88A);
  static const Color primaryLight = Color(0xFFA7CDB2);
  static const Color primaryDark = Color(0xFF52745D);

  static const Color accent = Color(0xFF86A9D3);
  static const Color accentLight = Color(0xFFC8D9EF);
  static const Color blush = Color(0xFFEAB9B1);
  static const Color lavender = Color(0xFFC9B8E8);

  static const Color income = Color(0xFF6DAA86);
  static const Color expense = Color(0xFFD9827E);
  static const Color warning = Color(0xFFD9A85C);
  static const Color info = Color(0xFF78A7C8);

  static const Color textPrimary = Color(0xFF25302C);
  static const Color textSecondary = Color(0xFF69756E);
  static const Color textTertiary = Color(0xFF9A8F82);

  static const Color shimmerBase = Color(0x66FFFFFF);
  static const Color shimmerHighlight = Color(0xE6FFFFFF);

  static const Color error = Color(0xFFC96D68);
  static const Color success = Color(0xFF6DAA86);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFA7CDB2), Color(0xFF86A9D3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFC8D9EF), Color(0xFFEAB9B1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient incomeGradient = LinearGradient(
    colors: [Color(0xFFB7D8BD), Color(0xFF6DAA86)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient expenseGradient = LinearGradient(
    colors: [Color(0xFFF1C3B8), Color(0xFFD9827E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFFFFFBF2), Color(0xFFF3E8D7)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const List<Color> chartColors = [
    Color(0xFF7EA88A),
    Color(0xFF86A9D3),
    Color(0xFFEAB9B1),
    Color(0xFFC9B8E8),
    Color(0xFFD9A85C),
    Color(0xFF8FC7BD),
    Color(0xFFDFA4C8),
    Color(0xFFB8B36F),
  ];

  static const Color incomeLow = Color(0x336DAA86);
  static const Color expenseLow = Color(0x33D9827E);
  static const Color whiteLow = Color(0x66FFFFFF);
  static const Color whiteMid = Color(0xBFFFFFFF);
  static const Color blackLow = Color(0x1F25302C);
}
