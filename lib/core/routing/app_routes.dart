import 'package:aoun/features/auth/forgot_password/pages/forget_password_page.dart';
import 'package:aoun/features/auth/forgot_password/pages/reset_password_page.dart';
import 'package:aoun/features/auth/forgot_password/presentation/cubit/forgot_password_cubit.dart';
import 'package:aoun/features/auth/log_in/pages/login_page.dart';
import 'package:aoun/features/auth/log_in/presentation/cubit/login_cubit.dart';
import 'package:aoun/features/auth/register/pages/register_page.dart';
import 'package:aoun/features/home/home_page.dart';
import 'package:aoun/features/home/main_home_navigation.dart';
import 'package:aoun/features/onboarding/pages/onboarding_page.dart';
import 'package:aoun/features/profile/presentation/pages/profile_page.dart';
import 'package:aoun/features/request_assistance/pages/request_assistance.dart';
import 'package:aoun/features/splash/pages/splash_page.dart';
import 'package:aoun/features/maps/presentation/pages/nearby_map_page.dart';
import 'package:aoun/features/maps/presentation/cubit/maps_cubit.dart';
import 'package:aoun/features/chatbot/presentation/pages/chatbot_page.dart';
import 'package:aoun/features/chatbot/presentation/cubit/chatbot_cubit.dart';
import 'package:aoun/core/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String donationCampaigns = '/donation_campaigns';
  static const String mainhome = '/mainhome';
  static const String home = '/home';

  static const String resetPassword = '/reset_password';
  static const String forgotPassword = '/forgot_password';
  static const String profile = '/profile';
  static const String request = '/request';
  static const String maps = '/maps';
  static const String chatbot = '/chatbot';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(const SplashPage(), settings: settings);
      case onboarding:
        return _buildRoute(const OnboardingPage(), settings: settings);
      case login:
        final args = settings.arguments as Map<String, dynamic>?;
        final email = args?['email'] as String?;
        final password = args?['password'] as String?;
        return _buildRoute(
          BlocProvider<LoginCubit>(
            create: (_) => sl<LoginCubit>(),
            child: LoginPage(email: email, password: password),
          ),
          settings: settings,
        );
      case register:
        return _buildRoute(const RegisterPage(), settings: settings);
      case home:
        return _buildRoute(const HomePage(), settings: settings);
      case mainhome:
        return _buildRoute(const MainHomeNavigation(), settings: settings);
      case request:
        return _buildRoute(const RequestAssistancePage(), settings: settings);
      case resetPassword:
        return _buildRoute(
          BlocProvider<ForgotPasswordCubit>(
            create: (_) => sl<ForgotPasswordCubit>(),
            child: const ResetPasswordPage(),
          ),
          settings: settings,
        );
      case forgotPassword:
        return _buildRoute(const ForgotPasswordPage(), settings: settings);
      case profile:
        return _buildRoute(const ProfilePage(), settings: settings);
      case maps:
        return _buildRoute(
          BlocProvider<MapsCubit>(
            create: (context) => sl<MapsCubit>(),
            child: const NearbyMapPage(),
          ),
          settings: settings,
        );
      case chatbot:
        return _buildRoute(
          BlocProvider<ChatbotCubit>(
            create: (context) => sl<ChatbotCubit>()..loadHistory(),
            child: const ChatbotPage(),
          ),
          settings: settings,
        );
      default:
        return _errorRoute();
    }
  }

  static Route _buildRoute(Widget page, {RouteSettings? settings}) {
    return PageRouteBuilder(
      settings: settings,
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
