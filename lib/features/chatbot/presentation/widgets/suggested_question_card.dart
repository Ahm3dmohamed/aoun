import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A glassmorphic suggestion card shown in the empty state.
/// Tapping it immediately sends the suggestion as a message.
class SuggestedQuestionCard extends StatefulWidget {
  final String question;
  final IconData icon;
  final VoidCallback onTap;

  const SuggestedQuestionCard({
    super.key,
    required this.question,
    required this.icon,
    required this.onTap,
  });

  @override
  State<SuggestedQuestionCard> createState() => _SuggestedQuestionCardState();
}

class _SuggestedQuestionCardState extends State<SuggestedQuestionCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (_, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: _isPressed
                ? const Color(0xFF1E3A4A)
                : const Color(0xFF162030).withOpacity(0.85),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: _isPressed
                  ? const Color(0xFF188894).withOpacity(0.6)
                  : Colors.white.withOpacity(0.08),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF0E7C7B).withOpacity(0.4),
                      const Color(0xFF188894).withOpacity(0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: const Color(0xFF188894).withOpacity(0.3),
                  ),
                ),
                child: Icon(widget.icon, color: const Color(0xFF4ECDC4), size: 17.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  widget.question,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13.sp,
                    height: 1.35,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: const Color(0xFF188894).withOpacity(0.6),
                size: 12.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
