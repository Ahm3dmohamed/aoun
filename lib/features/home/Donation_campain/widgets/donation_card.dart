import 'package:aoun/core/themes/app_colors.dart';
import 'package:aoun/core/utils/app_text_style.dart';
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
    final int total = remaining + donated;
    final double progress = total > 0 ? donated / total : 0;

    return Container(
      width: 280.w,
      margin: EdgeInsets.only(right: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
            child: Image.asset(
              image,
              height: 150.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.custom(
                    context,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                ),

                SizedBox(height: 8.h),

                LinearProgressIndicator(
                  value: progress,
                  color: AppColors.lightPrimary,
                  backgroundColor: Colors.grey[300],
                  minHeight: 6.h,
                  borderRadius: BorderRadius.circular(8.r),
                ),

                SizedBox(height: 8.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Remaining ${remaining.toStringAsFixed(0)}",
                      style: AppTextStyle.body(
                        context,
                        fontSize: 12,
                        color: Colors.grey[700]!,
                      ),
                    ),
                    Text(
                      "Donate ${donated.toStringAsFixed(0)}",
                      style: AppTextStyle.body(
                        context,
                        fontSize: 12,
                        color: Colors.grey[700]!,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightPrimary,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Donate clicked for "$title"')),
                      );
                    },
                    child: Text(
                      "Donate Now",
                      style: AppTextStyle.custom(
                        context,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
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
