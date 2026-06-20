import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/features/foundations/domain/entities/foundation_entity.dart';
import 'package:aoun/features/foundations/presentation/pages/donation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoundationCard extends StatelessWidget {
  final FoundationEntity foundation;

  const FoundationCard({super.key, required this.foundation});

  @override
  Widget build(BuildContext context) {
    final progress = (foundation.totalDonations / foundation.targetAmount).clamp(0.0, 1.0);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.12),
            Colors.white.withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foundation Logo/Image
                Container(
                  width: 64.r,
                  height: 64.r,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.teal.shade300,
                        Colors.blue.shade500,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14.r),
                    child: foundation.imageUrl != null && foundation.imageUrl!.startsWith('http')
                        ? Image.network(
                            foundation.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.volunteer_activism_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          )
                        : const Icon(
                            Icons.volunteer_activism_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                  ),
                ),
                SizedBox(width: 16.w),
                // Title and Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        foundation.name,
                        style: AppTextStyle.heading(
                          context,
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              foundation.foundationType.toUpperCase(),
                              style: AppTextStyle.caption(
                                context,
                                fontSize: 10.sp,
                                color: Colors.teal.shade200,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.location_on_outlined,
                            size: 14.r,
                            color: Colors.white70,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              foundation.location,
                              style: AppTextStyle.caption(
                                context,
                                fontSize: 12.sp,
                                color: Colors.white70,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            // Donation Goal Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  foundation.donationType,
                  style: AppTextStyle.body(
                    context,
                    fontSize: 13.sp,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: AppTextStyle.custom(
                    context,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6.h,
                backgroundColor: Colors.white.withOpacity(0.12),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade300),
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${isAr ? 'تم جمع:' : 'Raised:'} \$${foundation.totalDonations.toStringAsFixed(0)}',
                  style: AppTextStyle.caption(
                    context,
                    fontSize: 11.sp,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  '${isAr ? 'الهدف:' : 'Goal:'} \$${foundation.targetAmount.toStringAsFixed(0)}',
                  style: AppTextStyle.caption(
                    context,
                    fontSize: 11.sp,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            // Buttons Row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DonationPage(
                            foundation: foundation,
                            viewOnly: true,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      isAr ? 'التفاصيل' : 'View Details',
                      style: AppTextStyle.custom(
                        context,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade400,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DonationPage(
                            foundation: foundation,
                            viewOnly: false,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      isAr ? 'تبرع الآن' : 'Donate',
                      style: AppTextStyle.custom(
                        context,
                        fontSize: 13.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
