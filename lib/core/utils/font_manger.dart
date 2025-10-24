import 'package:flutter/material.dart';
import 'responsive_extension.dart';

class FontConstants {
  static const String fontFamily = "Poppins";
}

class FontWeightManager {
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

class FontSize {
  static double s12(BuildContext context) => context.resSP(12.0);
  static double s14(BuildContext context) => context.resSP(14.0);
  static double s16(BuildContext context) => context.resSP(16.0);
  static double s17(BuildContext context) => context.resSP(17.0);
  static double s18(BuildContext context) => context.resSP(18.0);
  static double s20(BuildContext context) => context.resSP(20.0);
  static double s22(BuildContext context) => context.resSP(22.0);
  static double s24(BuildContext context) => context.resSP(24.0);
  static double s26(BuildContext context) => context.resSP(26.0);
  static double s28(BuildContext context) => context.resSP(28.0);
  static double s45(BuildContext context) => context.resSP(45.0);
  static double s48(BuildContext context) => context.resSP(48.0);
}
