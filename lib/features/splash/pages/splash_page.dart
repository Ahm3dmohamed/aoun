import 'dart:async';

import 'package:aoun/core/routing/app_routes.dart';
import 'package:flutter/material.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/img/splash_logo.png', height: 150),
            // Icon(Icons.volunteer_activism, size: 100, color: Colors.white),
            // SizedBox(height: 20),
            // Text(
            //   'Aoun - Together We Care',
            //   style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            // ),
          ],
        ),
      ),
    );
  }
}
