import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Skeleton loading state shown while fetching chat history.
class LoadingChatView extends StatefulWidget {
  const LoadingChatView({super.key});

  @override
  State<LoadingChatView> createState() => _LoadingChatViewState();
}

class _LoadingChatViewState extends State<LoadingChatView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;
  late final Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _shimmerAnim = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      children: [
        _SkeletonBubble(isUser: false, width: 0.65.sw, shimmerAnim: _shimmerAnim),
        SizedBox(height: 10.h),
        _SkeletonBubble(isUser: true, width: 0.45.sw, shimmerAnim: _shimmerAnim),
        SizedBox(height: 10.h),
        _SkeletonBubble(isUser: false, width: 0.78.sw, shimmerAnim: _shimmerAnim),
        SizedBox(height: 10.h),
        _SkeletonBubble(isUser: false, width: 0.55.sw, shimmerAnim: _shimmerAnim),
        SizedBox(height: 10.h),
        _SkeletonBubble(isUser: true, width: 0.5.sw, shimmerAnim: _shimmerAnim),
        SizedBox(height: 10.h),
        _SkeletonBubble(isUser: false, width: 0.70.sw, shimmerAnim: _shimmerAnim),
      ],
    );
  }
}

class _SkeletonBubble extends StatelessWidget {
  final bool isUser;
  final double width;
  final Animation<double> shimmerAnim;

  const _SkeletonBubble({
    required this.isUser,
    required this.width,
    required this.shimmerAnim,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            _CircleSkeleton(size: 32.w, shimmerAnim: shimmerAnim),
            SizedBox(width: 8.w),
          ],
          AnimatedBuilder(
            animation: shimmerAnim,
            builder: (_, __) => Container(
              width: width,
              height: 48.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [
                    (shimmerAnim.value - 0.5).clamp(0.0, 1.0),
                    shimmerAnim.value.clamp(0.0, 1.0),
                    (shimmerAnim.value + 0.5).clamp(0.0, 1.0),
                  ],
                  colors: [
                    const Color(0xFF1A2332),
                    const Color(0xFF253447),
                    const Color(0xFF1A2332),
                  ],
                ),
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 8.w),
            _CircleSkeleton(size: 32.w, shimmerAnim: shimmerAnim),
          ],
        ],
      ),
    );
  }
}

class _CircleSkeleton extends StatelessWidget {
  final double size;
  final Animation<double> shimmerAnim;

  const _CircleSkeleton({required this.size, required this.shimmerAnim});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shimmerAnim,
      builder: (_, __) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            stops: [
              (shimmerAnim.value - 0.5).clamp(0.0, 1.0),
              shimmerAnim.value.clamp(0.0, 1.0),
              (shimmerAnim.value + 0.5).clamp(0.0, 1.0),
            ],
            colors: [
              const Color(0xFF1A2332),
              const Color(0xFF253447),
              const Color(0xFF1A2332),
            ],
          ),
        ),
      ),
    );
  }
}
