import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;
  final double borderRadius;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Gradient? gradient;
  final List<BoxShadow>? shadows;
  final Border? border;
  final Color? backgroundColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.borderRadius = 20,
    this.onTap,
    this.onLongPress,
    this.gradient,
    this.shadows,
    this.border,
    this.backgroundColor,
  });

  GlassCard.premium({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.borderRadius = 20,
    this.onTap,
    this.onLongPress,
  })  : gradient = const LinearGradient(
          colors: [Color(0x14FFFFFF), Color(0x08FFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shadows = _premiumShadows,
        border = _premiumBorder,
        backgroundColor = null;

  static final List<BoxShadow> _premiumShadows = [
    BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 8)),
    BoxShadow(color: AppColors.primary.withOpacity(0.05), blurRadius: 48, offset: const Offset(0, -4)),
  ];

  static final Border _premiumBorder = Border.all(
    color: AppColors.cardGlassBorder,
    width: 0.5,
  );

  @override
  Widget build(BuildContext context) {
    final Widget card = Container(
      height: height,
      width: width,
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: backgroundColor,
        gradient: gradient ??
            LinearGradient(
              colors: [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.03),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ??
            Border.all(color: Colors.white.withOpacity(0.08), width: 0.5),
        boxShadow: shadows ??
            [
              BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 8)),
            ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null || onLongPress != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          onLongPress: onLongPress,
          splashColor: Colors.white.withOpacity(0.05),
          highlightColor: Colors.white.withOpacity(0.02),
          child: card,
        ),
      );
    }

    return card;
  }
}

class GlassCardSmall extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? accentColor;

  const GlassCardSmall({
    super.key,
    required this.child,
    this.onTap,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 16,
      onTap: onTap,
      border: Border.all(
        color: (accentColor ?? AppColors.primary).withOpacity(0.15),
        width: 0.5,
      ),
      child: child,
    );
  }
}
