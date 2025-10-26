import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashBackground extends StatelessWidget {
  final Widget child;
  final bool withOverlay;
  static const String backgroundImage = 'assets/img/header.png';

  const SplashBackground({
    super.key,
    required this.child,
    this.withOverlay = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset(backgroundImage, fit: BoxFit.cover)),

        if (withOverlay)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.teal.withOpacity(0.8),
                  Colors.teal.withOpacity(0.6),
                  Colors.teal.withOpacity(0.4),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

        SafeArea(
          child: SizedBox(height: 1..sh, width: double.infinity, child: child),
        ),
      ],
    );
  }
}
