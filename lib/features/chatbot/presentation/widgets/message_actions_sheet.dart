import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aoun/features/chatbot/domain/entities/chat_message.dart';

/// Bottom sheet shown on long-press of a message bubble.
/// Actions: Copy text, Regenerate response (AI messages only).
class MessageActionsSheet extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback? onRegenerate;

  const MessageActionsSheet({
    super.key,
    required this.message,
    this.onRegenerate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle indicator
          Container(
            margin: EdgeInsets.only(top: 10.h, bottom: 6.h),
            width: 36.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Message preview
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Text(
                message.message.length > 120
                    ? '${message.message.substring(0, 120)}...'
                    : message.message,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12.sp,
                  height: 1.4,
                ),
              ),
            ),
          ),

          Divider(color: Colors.white.withOpacity(0.06), height: 1),

          // Copy action
          _ActionTile(
            icon: Icons.copy_rounded,
            label: 'Copy text',
            onTap: () {
              Clipboard.setData(ClipboardData(text: message.message));
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Copied to clipboard'),
                  backgroundColor: const Color(0xFF188894),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              );
            },
          ),

          // Regenerate action — only for AI messages
          if (message.isAi && !message.isError && onRegenerate != null)
            _ActionTile(
              icon: Icons.refresh_rounded,
              label: 'Regenerate response',
              onTap: () {
                Navigator.of(context).pop();
                onRegenerate?.call();
              },
            ),

          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF188894).withOpacity(0.15),
                border: Border.all(
                  color: const Color(0xFF188894).withOpacity(0.25),
                ),
              ),
              child: Icon(icon, color: const Color(0xFF4ECDC4), size: 18.sp),
            ),
            SizedBox(width: 14.w),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.87),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
