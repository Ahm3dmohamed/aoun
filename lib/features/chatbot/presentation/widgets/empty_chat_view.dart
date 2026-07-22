import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aoun/features/chatbot/presentation/widgets/suggested_question_card.dart';

/// Displayed when there are no messages.
/// Shows AI branding and 5 suggested question cards.
class EmptyChatView extends StatefulWidget {
  final ValueChanged<String> onSuggestionTap;

  const EmptyChatView({super.key, required this.onSuggestionTap});

  @override
  State<EmptyChatView> createState() => _EmptyChatViewState();
}

class _EmptyChatViewState extends State<EmptyChatView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  static const List<_Suggestion> _suggestions = [
    _Suggestion('How can I donate?', Icons.volunteer_activism_rounded),
    _Suggestion('Find charity cases near me.', Icons.location_on_rounded),
    _Suggestion('Show urgent medical cases.', Icons.local_hospital_rounded),
    _Suggestion('How does the recommendation system work?', Icons.auto_awesome_rounded),
    _Suggestion('What charities are available?', Icons.business_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            children: [
              SizedBox(height: 16.h),
              // AI Brand avatar
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0E7C7B), Color(0xFF1A9E9C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF188894).withOpacity(0.4),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Icon(Icons.auto_awesome, color: Colors.white, size: 36.sp),
              ),
              SizedBox(height: 16.h),
              Text(
                'Aoun AI Assistant',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Ask me anything about donations,\ncharities, and how to help.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 13.sp,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 28.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'SUGGESTED QUESTIONS',
                  style: TextStyle(
                    color: const Color(0xFF188894),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              ...List.generate(_suggestions.length, (i) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: SuggestedQuestionCard(
                    question: _suggestions[i].text,
                    icon: _suggestions[i].icon,
                    onTap: () => widget.onSuggestionTap(_suggestions[i].text),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _Suggestion {
  final String text;
  final IconData icon;
  const _Suggestion(this.text, this.icon);
}
