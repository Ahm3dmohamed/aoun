import 'package:aoun/core/extensions/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:aoun/core/routing/app_routes.dart';
import 'package:aoun/core/utils/app_images.dart';
import 'package:aoun/features/onboarding/widgets/onboarding_detailes.dart';
import 'package:aoun/features/onboarding/widgets/onboarding_navigation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late final AnimationController _arrowController;

  int _currentIndex = 0;
  bool get _isLastPage => _currentIndex == _pages.length - 1;

  final List<List<Color>> _gradients = const [
    [Color(0xFF009688), Color(0xFF006D77)],
    [Color(0xFF3AAFA9), Color(0xFF2B7A78)],
    [Color(0xFF11998E), Color(0xFF38EF7D)],
  ];

  late final List<OnBoardingDetails> _pages;

  @override
  void initState() {
    super.initState();

    // Arrow animation
    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    // Pages will be initialized in didChangeDependencies for l10n
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final t = context.l10n;
    _pages = [
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
  }

  @override
  void dispose() {
    _pageController.dispose();
    _arrowController.dispose();
    super.dispose();
  }

  Future<void> _saveApiKey() async {
    await _storage.write(
      key: "openrouter_api_key",
      value:
          "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",
    );
  }

  void _goToLogin() async {
    await _saveApiKey();
    if (!mounted) return;
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushReplacementNamed(AppRoutes.login);
  }

  void _onNext() {
    if (_isLastPage) {
      _goToLogin();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _onSkip() {
    _goToLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _gradients[_currentIndex],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: KeyedSubtree(
                    key: ValueKey(index),
                    child: _pages[index],
                  ),
                ),
              ),
              Positioned.fill(
                child: OnBoardingNavigation(
                  controller: _pageController,
                  isLastPage: _isLastPage,
                  pageCount: _pages.length,
                  gradients: _gradients,
                  currentIndex: _currentIndex,
                  arrowController: _arrowController,
                  onNext: _onNext,
                  onSkip: _onSkip,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
