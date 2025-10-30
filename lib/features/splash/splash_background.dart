import 'package:aoun/core/themes/app_colors.dart';
import 'package:aoun/core/utils/app_images.dart';
import 'package:flutter/material.dart';

class SplashBackground extends StatelessWidget {
  final Widget child;
  final bool withOverlay;

  const SplashBackground({
    super.key,
    required this.child,
    this.withOverlay = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(AppImages.backGround, fit: BoxFit.cover),
        ),

        if (withOverlay)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.lightPrimary,
                  Colors.teal.withOpacity(0.3),
                  Colors.teal.withOpacity(0.6),
                  Colors.teal.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

        SafeArea(child: SizedBox(child: child)),
      ],
    );
  }
}
