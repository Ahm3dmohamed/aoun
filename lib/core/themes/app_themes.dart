import 'package:aoun/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:aoun/core/utils/app_radius.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.lightPrimary,
    scaffoldBackgroundColor: const Color(0xFF0E7C7B),
    // scaffoldBackgroundColor: AppColors.lightPrimary,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.lightText),
      // titleTextStyle: AppTextStyles.headline2.copyWith(
      //   color: AppColors.lightText,
      // ),
    ),

    textTheme: TextTheme(
      // headlineLarge: AppTextStyles.headline1.copyWith(
      //   color: AppColors.lightText,
      // ),
      // titleLarge: AppTextStyles.headline2.copyWith(color: AppColors.lightText),
      // bodyLarge: AppTextStyles.body.copyWith(
      //   color: AppColors.lightText.withOpacity(0.9),
      // ),
      // bodyMedium: AppTextStyles.small.copyWith(
      //   color: AppColors.lightText.withOpacity(0.8),
      // ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 3, 59, 65),
        foregroundColor: Colors.white,
        // textStyle: AppTextStyles.body,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.lightCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      elevation: 4,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimary,
    scaffoldBackgroundColor: AppColors.darkBackground,

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.darkText),
      // titleTextStyle: AppTextStyles.headline2.copyWith(
      //   color: AppColors.darkText,
      // ),
    ),

    textTheme: TextTheme(
      // headlineLarge: AppTextStyles.headline1.copyWith(
      //   color: AppColors.darkText,
      // ),
      // titleLarge: AppTextStyles.headline2.copyWith(color: AppColors.darkText),
      // bodyLarge: AppTextStyles.body.copyWith(
      //   color: AppColors.darkText.withOpacity(0.9),
      // ),
      // bodyMedium: AppTextStyles.small.copyWith(
      //   color: AppColors.darkText.withOpacity(0.8),
      // ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: Colors.white,
        // textStyle: AppTextStyles.body,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: AppColors.darkText),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      elevation: 4,
    ),
  );
}
