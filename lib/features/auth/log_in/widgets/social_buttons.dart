import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  Widget _buildSocialButton({
    required IconData icon,
    required Color background,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 50.h,
        width: 60.w,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 24.sp),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          icon: FontAwesomeIcons.google,
          background: const Color(0xFFDB4437),
          onTap: () {},
        ),
        SizedBox(width: 16.w),

        _buildSocialButton(
          icon: FontAwesomeIcons.facebookF,
          background: const Color(0xFF1877F2),
          onTap: () {},
        ),
        SizedBox(width: 16.w),

        _buildSocialButton(
          icon: FontAwesomeIcons.xTwitter,
          background: Colors.black,
          onTap: () {},
        ),
      ],
    );
  }
}
