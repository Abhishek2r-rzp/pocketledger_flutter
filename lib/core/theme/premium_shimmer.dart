import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class PremiumShimmer extends StatefulWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const PremiumShimmer({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 8,
  });

  @override
  State<PremiumShimmer> createState() => _PremiumShimmerState();
}

class _PremiumShimmerState extends State<PremiumShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = _controller.value;
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        gradient: LinearGradient(
          colors: [
            AppColors.shimmerBase,
            AppColors.shimmerHighlight,
            AppColors.shimmerBase,
          ],
          stops: [
            (value - 0.3).clamp(0.0, 1.0),
            value,
            (value + 0.3).clamp(0.0, 1.0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  static const _cardGradient = LinearGradient(
    colors: [Color(0x14FFFFFF), Color(0x08FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final _cardBorder = Border.all(
    color: Colors.white.withOpacity(0.08),
    width: 0.5,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: _cardGradient,
          borderRadius: BorderRadius.circular(20),
          border: _cardBorder,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PremiumShimmer(width: 80, height: 12, borderRadius: 4),
                  SizedBox(height: 8),
                  PremiumShimmer(width: 120, height: 20, borderRadius: 4),
                  SizedBox(height: 6),
                  PremiumShimmer(width: 60, height: 10, borderRadius: 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
