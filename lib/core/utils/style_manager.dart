import 'package:aoun/core/themes/app_colors.dart';
import 'package:aoun/core/utils/font_manger.dart';
import 'package:aoun/core/utils/responsive_extension.dart';
import 'package:flutter/material.dart';

class AppResponsive {
  static double m(BuildContext context, double val) => context.resW(val);
  static double p(BuildContext context, double val) => context.resW(val);
  static double s(BuildContext context, double val) => context.resW(val);
  static double sp(BuildContext context, double val) => context.resSP(val);
}

TextStyle _getTextStyle(
  BuildContext context,
  double fontSize,
  FontWeight fontWeight,
  Color color,
) {
  return TextStyle(
    fontSize: AppResponsive.sp(context, fontSize),
    fontFamily: FontConstants.fontFamily,
    color: color,
    fontWeight: fontWeight,
  );
}

TextStyle getLightStyle(
  BuildContext context, {
  double fontSize = 12,
  required Color color,
}) {
  return _getTextStyle(context, fontSize, FontWeightManager.light, color);
}

TextStyle getRegularStyle(
  BuildContext context, {
  double fontSize = 14,
  required Color color,
}) {
  return _getTextStyle(context, fontSize, FontWeightManager.regular, color);
}

TextStyle getMediumStyle(
  BuildContext context, {
  double fontSize = 16,
  double height = 1.6,
  required Color color,
}) {
  return _getTextStyle(
    context,
    fontSize,
    FontWeightManager.medium,
    color,
  ).copyWith(height: height);
}

TextStyle getBoldStyle(
  BuildContext context, {
  double fontSize = 23,
  required Color color,
}) {
  return _getTextStyle(context, fontSize, FontWeightManager.bold, color);
}

TextStyle getSemiBoldStyle(
  BuildContext context, {
  double fontSize = 19,
  required Color color,
}) {
  return _getTextStyle(context, fontSize, FontWeightManager.semiBold, color);
}

TextStyle getTextWithLine(BuildContext context) {
  return TextStyle(
    color: AppColors.lightBackground,
    fontSize: AppResponsive.sp(context, 15),
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.lineThrough,
    decorationColor: AppColors.lightPrimary,
  );
}
