import 'package:aoun/core/themes/app_colors.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/features/cases/domain/entities/case_entity.dart';
import 'package:aoun/features/foundations/domain/entities/foundation_entity.dart';
import 'package:aoun/features/foundations/presentation/pages/donation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CaseCard extends StatelessWidget {
  final CaseEntity caseItem;

  const CaseCard({super.key, required this.caseItem});

  @override
  Widget build(BuildContext context) {
    String getCaseImage(String category) {
      switch (category.toLowerCase()) {
        case 'medical':
          return 'https://images.unsplash.com/photo-1631815588090-d4bfec5b1ccb?w=1200';

        case 'food':
          return 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=1200';

        case 'clothes':
          return 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=1200';

        case 'blood':
          return 'https://images.unsplash.com/photo-1615461066841-6116e61058f4?w=1200';

        default:
          return 'https://images.unsplash.com/photo-1516627145497-ae6968895b74?w=1200';
      }
    }

    final imageUrls = caseItem.imagePath?.isNotEmpty == true
        ? caseItem.imagePath!
        : getCaseImage(caseItem.category);
    final progress = caseItem.progressPercent;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    final image = caseItem.imagePath != null && caseItem.imagePath!.isNotEmpty
        ? 'https://untakable-tien-unwadable.ngrok-free.dev/storage/${caseItem.imagePath}'
        : null;

    Color urgencyColor;
    String urgencyText;
    if (caseItem.urgency.toLowerCase() == 'high') {
      urgencyColor = Colors.redAccent;
      urgencyText = isAr ? 'عاجل' : 'Urgent';
    } else {
      urgencyColor = Colors.orangeAccent;
      urgencyText = isAr ? 'طبيعي' : 'Normal';
    }

    String categoryName = caseItem.category;
    if (caseItem.category.toLowerCase() == 'medical') {
      categoryName = isAr ? 'طبي' : 'Medical';
    } else if (caseItem.category.toLowerCase() == 'blood') {
      categoryName = isAr ? 'دم' : 'Blood';
    } else if (caseItem.category.toLowerCase() == 'food') {
      categoryName = isAr ? 'طعام' : 'Food';
    } else if (caseItem.category.toLowerCase() == 'clothes') {
      categoryName = isAr ? 'ملابس' : 'Clothes';
    } else if (caseItem.category.toLowerCase() == 'money') {
      categoryName = isAr ? 'مال' : 'Money';
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 100.h,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                  child: Image.network(
                    imageUrls,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;

                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (_, __, ___) {
                      return Container(
                        color: Colors.grey.shade800,
                        child: const Center(
                          child: Icon(
                            Icons.volunteer_activism,
                            size: 40,
                            color: Colors.white54,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 10.h,
                left: isAr ? null : 10.w,
                right: isAr ? 10.w : null,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    categoryName,
                    style: AppTextStyle.caption(
                      context,
                      fontSize: 11,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8.h,
                left: isAr ? 10.w : null,
                right: isAr ? null : 10.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: urgencyColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    urgencyText,
                    style: AppTextStyle.caption(
                      context,
                      fontSize: 11,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  caseItem.title,
                  style: AppTextStyle.subHeading(
                    context,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),

                Text(
                  caseItem.description,
                  style: AppTextStyle.body(
                    context,
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.h),

                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.white60,
                      size: 14.r,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        caseItem.location,
                        style: AppTextStyle.caption(
                          context,
                          fontSize: 11,
                          color: Colors.white60,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6.h,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress >= 1.0
                          ? Colors.greenAccent
                          : AppColors.lightPrimary,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: AppTextStyle.caption(
                        context,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          isAr ? 'تبرع: ' : 'Donated: ',
                          style: AppTextStyle.caption(
                            context,
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          '${caseItem.donatedAmount.toStringAsFixed(0)} \$',
                          style: AppTextStyle.caption(
                            context,
                            fontSize: 11,
                            color: Colors.tealAccent,
                          ),
                        ),
                        Text(
                          ' / ${caseItem.targetAmount.toStringAsFixed(0)} \$',
                          style: AppTextStyle.caption(
                            context,
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 9.h),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: progress >= 1.0
                          ? Colors.grey.withOpacity(0.2)
                          : AppColors.lightPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                    ),
                    onPressed: progress >= 1.0
                        ? null
                        : () {
                            final dummyFoundation = FoundationEntity(
                              id: 'case_${caseItem.id}',
                              name: caseItem.title,
                              email: 'case@aoun.com',
                              phone: '',
                              foundationType: 'case',
                              donationType: caseItem.category,
                              location: caseItem.location,
                              createdAt: caseItem.createdAt.toIso8601String(),
                              totalDonations: caseItem.donatedAmount,
                              targetAmount: caseItem.targetAmount,
                              description: caseItem.description,
                              imageUrl: imageUrls,
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DonationPage(
                                  foundation: dummyFoundation,
                                  viewOnly: false,
                                ),
                              ),
                            );
                          },

                    child: Text(
                      progress >= 1.0
                          ? (isAr ? 'مكتمل' : 'Completed')
                          : (isAr ? 'تبرع الآن' : 'Donate Now'),
                      style: AppTextStyle.custom(
                        context,
                        fontSize: 13,
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
