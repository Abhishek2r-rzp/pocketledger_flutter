import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_design_system.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.borderRadius = AppRadii.lg,
    this.onTap,
    this.onLongPress,
    this.gradient,
    this.shadows,
    this.border,
    this.backgroundColor,
  });

  const GlassCard.premium({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.borderRadius = AppRadii.lg,
    this.onTap,
    this.onLongPress,
  })  : gradient = AppGlass.surfaceGradient,
        shadows = AppGlass.liftedShadow,
        border = const Border.fromBorderSide(
          BorderSide(color: AppGlass.stroke, width: 0.7),
        ),
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
                colors: [AppGlass.surface, AppGlass.surfaceSoft],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
          borderRadius: BorderRadius.circular(borderRadius),
          border: border ??
              const Border.fromBorderSide(
                BorderSide(color: AppGlass.hairline, width: 0.7),
              ),
          boxShadow: shadows ?? AppGlass.softShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: BackdropFilter(
            filter: AppGlass.backdropFilter,
            child: Padding(
              padding: padding ?? const EdgeInsets.all(AppSpacing.md),
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
      padding: const EdgeInsets.all(AppSpacing.sm),
      borderRadius: AppRadii.md,
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
