import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppSpacing {
  AppSpacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
}

class AppRadii {
  AppRadii._();

  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double pill = 999;
}

class AppGlass {
  AppGlass._();

  static const double blur = 22;
  static const Color surface = Color(0xD9FFFFFF);
  static const Color surfaceSoft = Color(0xBFFFFFFF);
  static const Color stroke = Color(0xCCFFFFFF);
  static const Color hairline = Color(0x80FFFFFF);

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xF7FFFFFF), Color(0xB8FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x188A7C68),
      blurRadius: 26,
      offset: Offset(0, 14),
    ),
  ];

  static const List<BoxShadow> liftedShadow = [
    BoxShadow(
      color: Color(0x228A7C68),
      blurRadius: 30,
      offset: Offset(0, 16),
    ),
    BoxShadow(
      color: Color(0x147EA88A),
      blurRadius: 34,
      offset: Offset(0, -6),
    ),
  ];

  static ImageFilter get backdropFilter =>
      ImageFilter.blur(sigmaX: blur, sigmaY: blur);

  static Border border([Color color = stroke]) {
    return Border.all(color: color, width: 0.7);
  }
}

class AppMotion {
  AppMotion._();

  static const Duration quick = Duration(milliseconds: 160);
  static const Duration standard = Duration(milliseconds: 240);
  static const Curve ease = Curves.easeOutCubic;
}

class AppIconBadge extends StatelessWidget {
  const AppIconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 40,
    this.iconSize = 20,
  });

  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(AppRadii.sm),
        border: Border.all(color: color.withOpacity(0.08), width: 0.5),
      ),
      child: Icon(icon, size: iconSize, color: color),
    );
  }
}

class AppSectionLabel extends StatelessWidget {
  const AppSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxs,
        vertical: AppSpacing.xxs,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.2,
            ),
      ),
    );
  }
}
