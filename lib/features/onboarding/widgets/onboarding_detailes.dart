import 'package:flutter/material.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/core/themes/app_colors.dart';
import 'package:aoun/core/utils/responsive_extension.dart';

class OnBoardingDetails extends StatelessWidget {
  final String image;
  final String title;
  final String desc;

  const OnBoardingDetails({
    super.key,
    required this.image,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.resW(24)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: context.resH(300),
            width: context.resW(300),
            fit: BoxFit.contain,
          ),
          SizedBox(height: context.resH(10)),

          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyle.heading(context),
          ),

          SizedBox(height: context.resH(10)),

          Text(
            desc,
            textAlign: TextAlign.center,
            style: AppTextStyle.body(
              context,
              fontWeight: FontWeight.w500,
            ).copyWith(color: AppColors.lightCard),
          ),
        ],
      ),
    );
  }
}
