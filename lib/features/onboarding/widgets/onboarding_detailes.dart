import 'package:aoun/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/app_sizes.dart';

class OnBoardingDetailes extends StatelessWidget {
  final String image;
  final String title;
  final String desc;

  const OnBoardingDetailes({
    super.key,
    required this.image,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.width(24)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: AppSizes.height(300),
            width: AppSizes.width(300),
            fit: BoxFit.contain,
          ),
          SizedBox(height: AppSizes.height(20)),
          Text(
            title,
            style: AppTextStyles.headline2,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.height(16)),
          Text(desc, style: AppTextStyles.body, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
