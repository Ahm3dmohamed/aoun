import 'package:aoun/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.clickedButton,
          foregroundColor: Color(0xffFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(34.r),
          ),
          textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(text),
      ),
    );
  }
}
