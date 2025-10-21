import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static TextStyle headline1 = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static TextStyle headline2 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle subtitle1 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle body = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle small = TextStyle(fontSize: 14.sp, color: Colors.grey[700]);
}
