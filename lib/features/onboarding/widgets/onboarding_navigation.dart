import 'package:aoun/core/extensions/localization_extension.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingNavigation extends StatelessWidget {
  final PageController controller;
  final bool isLastPage;
  final int pageCount;
  final List<List<Color>> gradients;
  final int currentIndex;
  final AnimationController arrowController;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const OnBoardingNavigation({
    super.key,
    required this.controller,
    required this.isLastPage,
    required this.pageCount,
    required this.gradients,
    required this.currentIndex,
    required this.arrowController,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onSkip,
              child: Text(
                context.l10n.skip,
                style: AppTextStyle.custom(
                  context,
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const Spacer(),

          SmoothPageIndicator(
            controller: controller,
            count: pageCount,
            effect: ExpandingDotsEffect(
              activeDotColor: Colors.white,
              dotColor: Colors.white54,
              dotHeight: 10.h,
              dotWidth: 10.w,
              expansionFactor: 4,
              spacing: 8.w,
            ),
          ),

          SizedBox(height: 9.h),

          GestureDetector(
            onTap: onNext,
            child: Container(
              height: 70.h,
              width: 70.w,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 10.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: ScaleTransition(
                scale: Tween(begin: 0.9, end: 1.1).animate(
                  CurvedAnimation(
                    parent: arrowController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: Icon(
                  isLastPage
                      ? Icons.favorite_rounded
                      : Icons.arrow_forward_rounded,
                  color: gradients[currentIndex].last,
                  size: 34.sp,
                ),
              ),
            ),
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
