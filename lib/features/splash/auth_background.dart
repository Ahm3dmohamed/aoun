import 'package:aoun/core/themes/app_colors.dart';
import 'package:aoun/core/utils/app_images.dart';
import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  final bool withOverlay;

  const AuthBackground({
    super.key,
    required this.child,
    this.withOverlay = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppImages.authBackground, fit: BoxFit.cover),
          ),

          if (withOverlay)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.lightPrimary,
                    Colors.teal.withOpacity(0.4),
                    Colors.teal.withOpacity(0.6),
                    Colors.teal.withOpacity(0.8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

          SafeArea(
            child: Center(
              child: SizedBox(width: double.infinity, child: child),
            ),
          ),
        ],
      ),
    );
  }
}
