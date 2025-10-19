import 'package:aoun/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:lottie/lottie.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final _controller = PageController();
  bool isLastPage = false;

  late final AnimationController _arrowController;

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
    final pages = [
      _onboard(
        "assets/img/Charity-rafiki.png",
        "Support Each Other",
        "Join hands with Aoun to bring hope and care to people in need. Together, we make compassion a habit.",
      ),
      _onboard(
        "assets/img/Charity market-amico.png",
        "Easy & Trusted Donations",
        "Contribute to verified causes effortlessly. Every donation you make directly reaches those who need it most.",
      ),
      _onboard(
        "assets/img/Humanitarian Help-bro.png",
        "Make a Difference",
        "Your small act of kindness can create a lasting impact and change lives for the better.",
      ),
    ];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 1),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF009688), Color(0xFF006D77)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 🔹 Skip button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _goToLogin(context),
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              // 🔹 PageView
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: pages.length,
                  onPageChanged: (index) {
                    setState(() => isLastPage = index == pages.length - 1);
                  },
                  itemBuilder: (_, index) => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.1, 0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                    child: pages[index],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Smooth Page Indicator
              SmoothPageIndicator(
                controller: _controller,
                count: pages.length,
                effect: const ExpandingDotsEffect(
                  activeDotColor: Colors.white,
                  dotColor: Colors.white54,
                  dotHeight: 10,
                  dotWidth: 10,
                  expansionFactor: 5,
                ),
              ),

              const SizedBox(height: 30),

              // 🔹 Animated Icon Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GestureDetector(
                  onTap: () {
                    if (isLastPage) {
                      _goToLogin(context);
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOutCubic,
                      );
                    }
                  },
                  child: Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ScaleTransition(
                      scale: Tween(begin: 0.9, end: 1.1).animate(
                        CurvedAnimation(
                          parent: _arrowController,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: Icon(
                        isLastPage
                            ? Icons.check_rounded
                            : Icons.arrow_forward_rounded,
                        color: const Color(0xFF006D77),
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _onboard(String image, String title, String desc) {
    return Padding(
      key: ValueKey(image),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(tag: image, child: Image.asset(image, height: 260)),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.8,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _goToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRouter.login);
  }
}
