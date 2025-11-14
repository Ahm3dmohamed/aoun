import 'package:aoun/core/extensions/localization_extension.dart';
import 'package:aoun/core/themes/app_colors.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/features/splash/splash_background.dart';
import 'package:aoun/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;

    return SplashBackground(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/img/splash_logo.png', height: 100.h),

            Text(
              loc.homeIntroTitle,
              style: AppTextStyle.heading(
                context,
                fontSize: 20,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 10.h),

            Text(
              loc.homeIntroSubtitle,
              style: AppTextStyle.body(
                context,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 25.h),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: AppColors.lightPrimary,
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(loc.donateTapped)));
              },
              child: Text(
                loc.donateNow,
                style: AppTextStyle.custom(
                  context,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
