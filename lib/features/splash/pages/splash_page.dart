import 'dart:async';
import 'package:flutter/material.dart';
import 'package:aoun/core/utils/app_images.dart';
import 'package:aoun/core/utils/app_sizes.dart';
import 'package:aoun/core/routing/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRouter.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Image.asset(
          AppImages.splashLogo,
          height: AppSizes.height(200),
          width: AppSizes.width(200),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
