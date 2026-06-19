import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_colors.dart';

class GlassCard extends StatelessWidget {
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
          colors: [Color(0xF2FFFFFF), Color(0x99FFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shadows = _premiumShadows,
        border = _premiumBorder,
        backgroundColor = null;

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

  static final List<BoxShadow> _premiumShadows = [
    const BoxShadow(
      color: Color(0x1F8A7C68),
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
    BoxShadow(
      color: AppColors.primary.withOpacity(0.12),
      blurRadius: 36,
      offset: const Offset(0, -4),
    ),
  ];

  static const Border _premiumBorder = Border(
    top: BorderSide(color: AppColors.cardGlassBorder, width: 0.5),
    bottom: BorderSide(color: AppColors.cardGlassBorder, width: 0.5),
    left: BorderSide(color: AppColors.cardGlassBorder, width: 0.5),
    right: BorderSide(color: AppColors.cardGlassBorder, width: 0.5),
  );

  @override
  Widget build(BuildContext context) {
    final Widget card = RepaintBoundary(
      child: Container(
        height: height,
        width: width,
        margin: margin ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          color: backgroundColor,
          gradient: gradient ??
              const LinearGradient(
                colors: [Color(0xF2FFFFFF), Color(0xA6FFFFFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
          borderRadius: BorderRadius.circular(borderRadius),
          border: border ??
              const Border(
                top: BorderSide(color: Color(0x14FFFFFF), width: 0.5),
                bottom: BorderSide(color: Color(0x14FFFFFF), width: 0.5),
                left: BorderSide(color: Color(0x14FFFFFF), width: 0.5),
                right: BorderSide(color: Color(0x14FFFFFF), width: 0.5),
              ),
          boxShadow: shadows ??
              const [
                BoxShadow(
                  color: Color(0x1A8A7C68),
                  blurRadius: 22,
                  offset: Offset(0, 10),
                ),
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
      ),
    );

    if (onTap != null || onLongPress != null) {
      return RepaintBoundary(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: onTap,
            onLongPress: onLongPress,
            splashColor: AppColors.primary.withOpacity(0.08),
            highlightColor: Colors.white.withOpacity(0.25),
            child: card,
          ),
        ),
      );
    }

    return card;
  }
}

class GlassCardSmall extends StatelessWidget {
  const GlassCardSmall({
    super.key,
    required this.child,
    this.onTap,
    this.accentColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final borderColor = (accentColor ?? AppColors.primary).withOpacity(0.15);

    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 16,
      onTap: onTap,
      border: Border(
        top: BorderSide(
          color: borderColor,
          width: 0.5,
        ),
        bottom: BorderSide(
          color: borderColor,
          width: 0.5,
        ),
        left: BorderSide(
          color: borderColor,
          width: 0.5,
        ),
        right: BorderSide(
          color: borderColor,
          width: 0.5,
        ),
      ),
      child: child,
    );
  }
}
