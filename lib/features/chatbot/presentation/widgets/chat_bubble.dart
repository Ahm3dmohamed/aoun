import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aoun/features/chatbot/domain/entities/chat_message.dart';
import 'package:aoun/features/chatbot/presentation/widgets/typing_indicator.dart';
import 'package:aoun/features/chatbot/presentation/widgets/message_actions_sheet.dart';

/// Renders a single chat message bubble.
/// User messages: right-aligned teal gradient.
/// AI messages: left-aligned dark glassmorphism card.
/// Loading: shows animated typing indicator.
/// Error: red-tinted bubble with error icon.
class ChatBubble extends StatefulWidget {
  final ChatMessage message;
  final String? searchQuery;
  final bool isHighlighted;
  final VoidCallback? onRegenerate;

  const ChatBubble({
    super.key,
    required this.message,
    this.searchQuery,
    this.isHighlighted = false,
    this.onRegenerate,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entryController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutBack,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeIn,
    );
    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.message.isUser;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          child: Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[
                _AiAvatar(),
                SizedBox(width: 8.w),
              ],
              Flexible(child: _buildBubble(context, isUser)),
              if (isUser) ...[
                SizedBox(width: 8.w),
                _UserAvatar(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBubble(BuildContext context, bool isUser) {
    if (widget.message.isLoading) {
      return _LoadingBubble();
    }

    return GestureDetector(
      onLongPress: () => _showActions(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: BoxConstraints(maxWidth: 0.72.sw),
        decoration: BoxDecoration(
          gradient: isUser
              ? const LinearGradient(
                  colors: [Color(0xFF0E7C7B), Color(0xFF188894)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: widget.message.isError
              ? const Color(0xFF3B1A1A)
              : isUser
                  ? null
                  : const Color(0xFF1A2332),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
          border: (!isUser && !widget.message.isError)
              ? Border.all(color: Colors.white.withOpacity(0.08), width: 1)
              : widget.message.isError
                  ? Border.all(color: const Color(0xFFE57373).withOpacity(0.4), width: 1)
                  : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (widget.message.isError)
              Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Color(0xFFE57373), size: 14),
                    SizedBox(width: 4.w),
                    Text(
                      'Error',
                      style: TextStyle(
                        color: const Color(0xFFE57373),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            _buildMessageText(isUser),
            SizedBox(height: 4.h),
            _buildTimestamp(isUser),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageText(bool isUser) {
    final text = widget.message.message;
    final query = widget.searchQuery ?? '';

    if (query.isEmpty || !text.toLowerCase().contains(query.toLowerCase())) {
      return Text(
        text,
        style: TextStyle(
          color: isUser
              ? Colors.white
              : widget.message.isError
                  ? const Color(0xFFE57373)
                  : Colors.white.withOpacity(0.92),
          fontSize: 14.sp,
          height: 1.45,
        ),
      );
    }

    // Highlight search matches
    return _HighlightedText(
      text: text,
      query: query,
      baseStyle: TextStyle(
        color: isUser ? Colors.white : Colors.white.withOpacity(0.92),
        fontSize: 14.sp,
        height: 1.45,
      ),
    );
  }

  Widget _buildTimestamp(bool isUser) {
    final time = widget.message.timestamp;
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return Text(
      '$hour:$minute',
      style: TextStyle(
        color: Colors.white.withOpacity(0.45),
        fontSize: 10.sp,
      ),
    );
  }

  void _showActions(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => MessageActionsSheet(
        message: widget.message,
        onRegenerate: widget.onRegenerate,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Supporting sub-widgets
// ---------------------------------------------------------------------------

class _AiAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF0E7C7B), Color(0xFF188894)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(Icons.auto_awesome, color: Colors.white, size: 16.sp),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF2A3A4A),
      ),
      child: Icon(Icons.person, color: Colors.white70, size: 18.sp),
    );
  }
}

class _LoadingBubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 0.4.sw),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
          bottomRight: Radius.circular(18),
          bottomLeft: Radius.circular(4),
        ),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: const TypingIndicator(),
    );
  }
}

class _HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle baseStyle;

  const _HighlightedText({
    required this.text,
    required this.query,
    required this.baseStyle,
  });

  @override
  Widget build(BuildContext context) {
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      final idx = lowerText.indexOf(lowerQuery, start);
      if (idx == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (idx > start) {
        spans.add(TextSpan(text: text.substring(start, idx)));
      }
      spans.add(TextSpan(
        text: text.substring(idx, idx + query.length),
        style: const TextStyle(
          backgroundColor: Color(0xFFFFD54F),
          color: Color(0xFF1A1A2E),
          fontWeight: FontWeight.bold,
        ),
      ));
      start = idx + query.length;
    }

    return RichText(
      text: TextSpan(style: baseStyle, children: spans),
    );
  }
}
