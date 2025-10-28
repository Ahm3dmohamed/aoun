import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      style: TextStyle(color: Colors.white, fontSize: 16.sp),
      decoration: InputDecoration(
        labelText: label,

        hintText: hint,
        labelStyle: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(color: Colors.white, fontSize: 14.sp),
        hintStyle: TextStyle(color: Colors.white, fontSize: 14.sp),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(34.r),
          borderSide: BorderSide(color: Colors.white),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(34.r),
          borderSide: BorderSide(color: Colors.white),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(34.r),
          borderSide: BorderSide(color: Colors.white),
        ),

        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
    );
  }
}
