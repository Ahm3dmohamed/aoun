import 'package:aoun/core/extensions/localization_extension.dart';
import 'package:aoun/core/themes/app_colors.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DonationCard extends StatelessWidget {
  final String image;
  final String title;
  final int remaining;
  final int donated;

  const DonationCard({
    super.key,
    required this.image,
    required this.title,
    required this.remaining,
    required this.donated,
  });

  @override
  Widget build(BuildContext context) {
    final total = remaining + donated;
    final progress = donated / total;
    final loc = context.l10n;
    return Container(
      width: 280.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            image,
            height: 150.h,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyle.heading(context, fontSize: 16)),

                SizedBox(height: 8.h),
                LinearProgressIndicator(
                  value: progress,
                  color: AppColors.lightPrimary,
                  backgroundColor: Colors.grey[300],
                ),

                SizedBox(height: 8.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${loc.remaining} $remaining"),
                    Text("${loc.donated} $donated"),
                  ],
                ),

                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(loc.donateNow),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
