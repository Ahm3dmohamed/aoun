import 'package:flutter/material.dart';
import 'package:aoun/core/themes/app_colors.dart';
import 'package:aoun/core/utils/font_manger.dart';
import 'package:aoun/core/utils/responsive_extension.dart';

class AppTextStyle {
  static TextStyle _base(
    BuildContext context, {
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: context.resSP(fontSize),
      fontFamily: FontConstants.fontFamily,
      color: color,
      fontWeight: fontWeight,
      height: height,
      decoration: decoration,
    );
  }

  static TextStyle custom(
    BuildContext context, {
    double fontSize = 16,
    FontWeight fontWeight = FontWeightManager.regular,
    Color color = AppColors.darkText,
    double? height,
    TextDecoration? decoration,
  }) {
    return _base(
      context,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
    );
  }

  static TextStyle heading(
    BuildContext context, {
    double fontSize = 22,

    Color color = AppColors.lightText,
  }) {
    return _base(
      context,
      fontSize: fontSize,
      fontWeight: FontWeightManager.bold,
      color: color,
    );
  }

  static TextStyle subHeading(
    BuildContext context, {
    double fontSize = 18,
    Color color = AppColors.darkText,
  }) {
    return _base(
      context,
      fontSize: fontSize,
      fontWeight: FontWeightManager.semiBold,
      color: color,
    );
  }

  static TextStyle body(
    BuildContext context, {
    double fontSize = 14,
    Color color = AppColors.grey,
    required FontWeight fontWeight,
  }) {
    return _base(
      context,
      fontSize: fontSize,
      fontWeight: FontWeightManager.regular,
      color: color,
      height: 1.5,
    );
  }

  static TextStyle caption(
    BuildContext context, {
    double fontSize = 12,
    Color color = AppColors.grey,
  }) {
    return _base(
      context,
      fontSize: fontSize,
      fontWeight: FontWeightManager.light,
      color: color,
    );
  }
}
