import 'package:aoun/features/auth/forgot_password/pages/forget_password_page.dart';
import 'package:aoun/features/auth/forgot_password/pages/reset_password_page.dart';
import 'package:aoun/features/auth/log_in/pages/login_page.dart';
import 'package:aoun/features/auth/register/pages/register_page.dart';
import 'package:aoun/features/home/main_home_navigation.dart';
import 'package:aoun/features/onboarding/pages/onboarding_page.dart';
import 'package:aoun/features/splash/pages/splash_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String donationCampaigns = '/donation_campaigns';
  static const String home = '/home';
  static const String resetPassword = '/reset_password';
  static const String forgotPassword = '/forgot_password';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(const SplashPage());
      case onboarding:
        return _buildRoute(const OnboardingPage());
      case login:
        return _buildRoute(const LoginPage());
      case register:
        return _buildRoute(const RegisterPage());
      case home:
        return _buildRoute(const MainHomeNavigation());
      case resetPassword:
        return _buildRoute(const ResetPasswordPage());
      case forgotPassword:
        return _buildRoute(const ForgotPasswordPage());
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
