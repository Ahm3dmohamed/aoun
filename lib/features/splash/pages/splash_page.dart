import 'dart:async';
import 'package:aoun/core/utils/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:aoun/core/utils/app_images.dart';
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
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Image.asset(
          AppImages.splashLogo,
          height: context.resH(200),
          width: context.resW(200),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
