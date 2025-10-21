import 'package:aoun/core/utils/app_radius.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blueAccent,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: AppTextStyles.headline2,
      iconTheme: const IconThemeData(color: Colors.black),
    ),
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.headline1,
      titleLarge: AppTextStyles.headline2,
      bodyLarge: AppTextStyles.body,
      bodyMedium: AppTextStyles.small,
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      elevation: 4,
    ),
  );
}
