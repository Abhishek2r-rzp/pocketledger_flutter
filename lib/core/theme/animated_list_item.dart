import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StaggeredList extends StatelessWidget {
  final List<Widget> children;
  final int? itemCount;
  final Duration itemDelay;
  final Duration duration;
  final Curve curve;

  const StaggeredList({
    super.key,
    required this.children,
    this.itemCount,
    this.itemDelay = const Duration(milliseconds: 80),
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    final count = itemCount ?? children.length;
    return Column(
      children: List.generate(count, (i) {
        return children[i]
            .animate()
            .fadeIn(
              duration: duration,
              delay: itemDelay * i,
              curve: curve,
            )
            .slideY(
              begin: 0.1,
              end: 0,
              duration: duration,
              delay: itemDelay * i,
              curve: curve,
            );
      }),
    );
  }
}

extension AnimatedVisibility on Widget {
  Widget fadeSlideIn({
    Duration duration = const Duration(milliseconds: 400),
    Duration delay = Duration.zero,
    Curve curve = Curves.easeOutCubic,
  }) {
    return Animate(
      effects: [
        FadeEffect(duration: duration, delay: delay, curve: curve),
        SlideEffect(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
          duration: duration,
          delay: delay,
          curve: curve,
        ),
      ],
      child: this,
    );
  }

  Widget scaleIn({
    Duration duration = const Duration(milliseconds: 300),
    Duration delay = Duration.zero,
    Curve curve = Curves.easeOutBack,
  }) {
    return Animate(
      effects: [
        ScaleEffect(
          begin: const Offset(0.95, 0.95),
          end: Offset.zero,
          duration: duration,
          delay: delay,
          curve: curve,
        ),
        FadeEffect(duration: duration, delay: delay, curve: Curves.easeOut),
      ],
      child: this,
    );
  }
}
