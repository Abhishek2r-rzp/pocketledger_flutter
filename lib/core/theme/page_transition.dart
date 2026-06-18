import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_colors.dart';

CustomTransitionPage premiumPageTransition({
  required Widget child,
  String? transitionType,
  LocalKey? key,
  bool maintainState = false,
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    maintainState: maintainState,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final type = transitionType ?? 'slideUp';

      switch (type) {
        case 'fade':
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        case 'scale':
          return ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        case 'slideUp':
        default:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.06),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
      }
    },
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 250),
  );
}

CustomTransitionPage glassPageTransition({
  required Widget child,
  LocalKey? key,
  bool maintainState = false,
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    maintainState: maintainState,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return DecoratedBoxTransition(
        position: DecorationPosition.foreground,
        decoration: DecorationTween(
          begin: const BoxDecoration(
            color: Colors.transparent,
          ),
          end: BoxDecoration(
            color: AppColors.background.withOpacity(0.3),
          ),
        ).animate(animation),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
  );
}
