import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedTranslateButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String text;

  const AnimatedTranslateButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.text,
  });

  @override
  State<AnimatedTranslateButton> createState() => _AnimatedTranslateButtonState();
}

class _AnimatedTranslateButtonState extends State<AnimatedTranslateButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(_fadeAnimation.value),
                    Theme.of(context).colorScheme.secondary.withOpacity(_fadeAnimation.value),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8 * _fadeAnimation.value,
                    spreadRadius: 2 * _fadeAnimation.value,
                  ),
                  BoxShadow(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                    blurRadius: 8 * _fadeAnimation.value,
                    spreadRadius: 2 * _fadeAnimation.value,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: widget.isLoading ? null : widget.onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.isLoading)
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    else
                      Transform.rotate(
                        angle: _rotateAnimation.value,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.translate,
                              color: Colors.white.withOpacity(
                                (math.sin(_controller.value * math.pi) + 1) / 2,
                              ),
                              size: 24,
                            ),
                            Transform.scale(
                              scale: 1.2,
                              child: Icon(
                                Icons.language,
                                color: Colors.white.withOpacity(
                                  (math.cos(_controller.value * math.pi) + 1) / 2,
                                ),
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(width: 12),
                    Text(
                      widget.text,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
