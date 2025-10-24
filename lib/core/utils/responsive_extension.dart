import 'package:flutter/material.dart';

extension ResponsiveExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  double resW(double size) => size * screenWidth / 375;
  double resH(double size) => size * screenHeight / 812;
  double resSP(double size) => size * (screenWidth / 375);
}
