import 'package:aoun/features/onboarding/pages/onboarding_page.dart';
import 'package:aoun/features/splash/pages/splash_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/home';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(const SplashPage());
      case onboarding:
        return _buildRoute(const OnboardingPage());
      // case login:
      //   return _buildRoute(const LoginPage());
      // case home:
      //   return _buildRoute(const HomePage());
      default:
        return _errorRoute();
    }
  }

  static Route _buildRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween(begin: 0.0, end: 1.0);
        return FadeTransition(opacity: animation.drive(tween), child: child);
      },
    );
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) =>
          const Scaffold(body: Center(child: Text('Page Not Found'))),
    );
  }
}
