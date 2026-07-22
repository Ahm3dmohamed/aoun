import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// AppBar for the chatbot screen with AI avatar, title,
/// online indicator, and collapsible search field.
class ChatHeader extends StatefulWidget implements PreferredSizeWidget {
  final bool isSearchVisible;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchToggle;
  final VoidCallback onClearSearch;
  final VoidCallback onClearHistory;

  const ChatHeader({
    super.key,
    required this.isSearchVisible,
    required this.searchController,
    required this.onSearchChanged,
    required this.onSearchToggle,
    required this.onClearSearch,
    required this.onClearHistory,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (isSearchVisible ? 50.h : 0));

  @override
  State<ChatHeader> createState() => _ChatHeaderState();
}

class _ChatHeaderState extends State<ChatHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF0A1628),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          // AI Avatar with pulse indicator
          Stack(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF0E7C7B), Color(0xFF188894)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(Icons.auto_awesome, color: Colors.white, size: 20.sp),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (_, __) => Opacity(
                    opacity: _pulseAnim.value,
                    child: Container(
                      width: 11.w,
                      height: 11.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF4CAF50),
                        border: Border.all(color: const Color(0xFF0A1628), width: 2),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Aoun AI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              Text(
                'Always here to help',
                style: TextStyle(
                  color: const Color(0xFF4ECDC4),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        if (!widget.isSearchVisible) ...[
          IconButton(
            icon: Icon(
              Icons.delete_sweep_rounded,
              color: Colors.white.withOpacity(0.8),
              size: 22.sp,
            ),
            onPressed: widget.onClearHistory,
            tooltip: 'Clear history',
          ),
        ],
        IconButton(
          icon: Icon(
            widget.isSearchVisible ? Icons.close_rounded : Icons.search_rounded,
            color: Colors.white.withOpacity(0.8),
          ),
          onPressed: widget.isSearchVisible
              ? widget.onClearSearch
              : widget.onSearchToggle,
          tooltip: widget.isSearchVisible ? 'Close search' : 'Search messages',
        ),
        SizedBox(width: 4.w),
      ],
      bottom: widget.isSearchVisible
          ? PreferredSize(
              preferredSize: Size.fromHeight(50.h),
              child: _SearchBar(
                controller: widget.searchController,
                onChanged: widget.onSearchChanged,
                onClose: widget.onClearSearch,
              ),
            )
          : null,
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClose;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Container(
        height: 38.h,
        decoration: BoxDecoration(
          color: const Color(0xFF1A2332),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFF188894).withOpacity(0.4)),
        ),
        child: TextField(
          controller: controller,
          autofocus: true,
          style: TextStyle(color: Colors.white, fontSize: 13.sp),
          decoration: InputDecoration(
            hintText: 'Search in conversation...',
            hintStyle: TextStyle(color: Colors.white38, fontSize: 13.sp),
            prefixIcon: Icon(Icons.search, color: Colors.white38, size: 18.sp),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 8.h),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
