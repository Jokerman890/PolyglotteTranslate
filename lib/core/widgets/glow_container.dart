import 'package:flutter/material.dart';
import 'dart:math' as math;

class GlowContainer extends StatefulWidget {
  final Widget child;
  final double borderRadius;

  const GlowContainer({
    super.key,
    required this.child,
    this.borderRadius = 12.0,
  });

  @override
  State<GlowContainer> createState() => _GlowContainerState();
}

class _GlowContainerState extends State<GlowContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<Color> _rainbowColors = const [
    Color(0xFFFF0000),  // Rot
    Color(0xFFFF7F00),  // Orange
    Color(0xFFFFFF00),  // Gelb
    Color(0xFF00FF00),  // Grün
    Color(0xFF0000FF),  // Blau
    Color(0xFF4B0082),  // Indigo
    Color(0xFF9400D3),  // Violett
    Color(0xFFFF0000),  // Rot (für nahtlosen Übergang)
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final double t = _animation.value;
        final int colorIndex = (t * (_rainbowColors.length - 1)).floor();
        final double localT = (t * (_rainbowColors.length - 1)) - colorIndex;
        final Color currentColor = Color.lerp(
          _rainbowColors[colorIndex],
          _rainbowColors[colorIndex + 1],
          localT,
        )!;

        return Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius - 1),
                border: Border.all(
                  color: currentColor.withOpacity(0.8),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: currentColor.withOpacity(0.3),
                    blurRadius: 2,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: child,
              ),
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
