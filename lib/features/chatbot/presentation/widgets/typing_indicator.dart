import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Animated three-dot typing indicator shown while AI is generating a response.
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  static const int _dotCount = 3;
  static const Duration _dotDuration = Duration(milliseconds: 500);
  static const Duration _staggerDelay = Duration(milliseconds: 160);

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _dotCount,
      (i) => AnimationController(vsync: this, duration: _dotDuration),
    );

    _animations = _controllers
        .map(
          (c) => Tween<double>(begin: 0, end: -6).animate(
            CurvedAnimation(parent: c, curve: Curves.easeInOut),
          ),
        )
        .toList();

    // Stagger the dot animations
    for (int i = 0; i < _dotCount; i++) {
      Future.delayed(_staggerDelay * i, () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_dotCount, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (_, __) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Transform.translate(
              offset: Offset(0, _animations[i].value),
              child: Container(
                width: 7.w,
                height: 7.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF188894),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
