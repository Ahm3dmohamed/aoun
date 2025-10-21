import 'package:flutter/material.dart';
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
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: onSkip,
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white,
              size: 28,
            ),
            tooltip: 'Skip',
          ),
        ),

        const Spacer(),

        SmoothPageIndicator(
          controller: controller,
          count: pageCount,
          effect: const ExpandingDotsEffect(
            activeDotColor: Colors.white,
            dotColor: Colors.white54,
            dotHeight: 10,
            dotWidth: 10,
            expansionFactor: 4,
            spacing: 8,
          ),
        ),

        const SizedBox(height: 25),

        GestureDetector(
          onTap: onNext,
          child: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
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
                size: 34,
              ),
            ),
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}
