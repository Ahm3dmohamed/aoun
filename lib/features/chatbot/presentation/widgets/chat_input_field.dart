import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The message input field with send button and placeholder icons
/// for voice (architecture ready) and attachments.
class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isLoading;
  final ValueChanged<String> onSend;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isLoading,
    required this.onSend,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField>
    with SingleTickerProviderStateMixin {
  bool _hasText = false;
  late final AnimationController _sendBtnController;
  late final Animation<double> _sendBtnScale;

  @override
  void initState() {
    super.initState();
    _sendBtnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _sendBtnScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sendBtnController, curve: Curves.elasticOut),
    );
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
      if (hasText) {
        _sendBtnController.forward();
      } else {
        _sendBtnController.reverse();
      }
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _sendBtnController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = widget.controller.text.trim();
    if (text.isEmpty || widget.isLoading) return;
    widget.onSend(text);
    widget.controller.clear();
    setState(() => _hasText = false);
    _sendBtnController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628).withOpacity(0.9),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.08), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Voice placeholder button
            _ActionButton(
              icon: Icons.mic_none_rounded,
              tooltip: 'Voice input (coming soon)',
              onTap: () {},
            ),
            SizedBox(width: 8.w),

            // Text field
            Expanded(
              child: Container(
                constraints: BoxConstraints(maxHeight: 120.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2332),
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: widget.focusNode.hasFocus
                        ? const Color(0xFF188894)
                        : Colors.white.withOpacity(0.1),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        focusNode: widget.focusNode,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.92),
                          fontSize: 14.sp,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ask me anything...',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 14.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                        ),
                        onSubmitted: (_) => _handleSend(),
                        textInputAction: TextInputAction.newline,
                      ),
                    ),
                    // Attachment placeholder
                    Padding(
                      padding: EdgeInsets.only(right: 4.w, bottom: 4.h),
                      child: _ActionButton(
                        icon: Icons.attach_file_rounded,
                        tooltip: 'Attach file (coming soon)',
                        onTap: () {},
                        size: 20.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),

            // Send / Loading button
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: widget.isLoading
                  ? _LoadingIndicator(key: const ValueKey('loading'))
                  : ScaleTransition(
                      key: const ValueKey('send'),
                      scale: _hasText
                          ? _sendBtnScale
                          : const AlwaysStoppedAnimation(1.0),
                      child: _SendButton(
                        enabled: _hasText,
                        onTap: _handleSend,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final double? size;

  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Icon(
          icon,
          color: Colors.white.withOpacity(0.4),
          size: size ?? 22.sp,
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _SendButton({required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: enabled
              ? const LinearGradient(
                  colors: [Color(0xFF0E7C7B), Color(0xFF188894)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: enabled ? null : const Color(0xFF1A2332),
        ),
        child: Icon(
          Icons.send_rounded,
          color: enabled ? Colors.white : Colors.white.withOpacity(0.3),
          size: 20.sp,
        ),
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44.w,
      height: 44.w,
      child: const Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF188894)),
          ),
        ),
      ),
    );
  }
}
