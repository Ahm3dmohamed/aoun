import 'package:aoun/core/extensions/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:aoun/core/routing/app_routes.dart';
import 'package:aoun/core/utils/app_images.dart';
import 'package:aoun/features/onboarding/widgets/onboarding_detailes.dart';
import 'package:aoun/features/onboarding/widgets/onboarding_navigation.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final _controller = PageController();
  bool isLastPage = false;
  int currentIndex = 0;

  late final AnimationController _arrowController;

  final List<List<Color>> gradients = const [
    [Color(0xFF009688), Color(0xFF006D77)],
    [Color(0xFF3AAFA9), Color(0xFF2B7A78)],
    [Color(0xFF11998E), Color(0xFF38EF7D)],
  ];

  late List<OnBoardingDetails> pages;

  @override
  void initState() {
    super.initState();

    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _arrowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;

    pages = [
      OnBoardingDetails(
        image: AppImages.onboarding1,
        title: t.onboardTitle1,
        desc: t.onboardDesc1,
      ),
      OnBoardingDetails(
        image: AppImages.onboarding2,
        title: t.onboardTitle2,
        desc: t.onboardDesc2,
      ),
      OnBoardingDetails(
        image: AppImages.onboarding3,
        title: t.onboardTitle3,
        desc: t.onboardDesc3,
      ),
    ];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradients[currentIndex],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                    isLastPage = index == pages.length - 1;
                  });
                },
                itemBuilder: (_, index) => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: pages[index],
                ),
              ),

              Positioned.fill(
                child: OnBoardingNavigation(
                  controller: _controller,
                  isLastPage: isLastPage,
                  pageCount: pages.length,
                  gradients: gradients,
                  currentIndex: currentIndex,
                  arrowController: _arrowController,
                  onNext: () {
                    if (isLastPage) {
                      _goToLogin(context);
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOutCubic,
                      );
                    }
                  },
                  onSkip: () => _goToLogin(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }
}
