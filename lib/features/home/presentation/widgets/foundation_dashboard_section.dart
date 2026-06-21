import 'package:aoun/core/routing/app_routes.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/features/foundations/domain/entities/donation_entity.dart';
import 'package:aoun/features/foundations/domain/entities/foundation_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoundationDashboardSection extends StatelessWidget {
  final FoundationEntity foundation;
  final List<DonationEntity> receivedDonations;
  final ScrollController? parentScrollController;

  const FoundationDashboardSection({
    super.key,
    required this.foundation,
    required this.receivedDonations,
    this.parentScrollController,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final progress = (foundation.totalDonations / foundation.targetAmount)
        .clamp(0.0, 1.0);
    final uniqueDonors = receivedDonations
        .map((d) => d.donorName)
        .toSet()
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isAr ? 'لوحة التحكم للمؤسسة' : 'Foundation Dashboard',
              style: AppTextStyle.heading(
                context,
                fontSize: 18.sp,
                color: Colors.white,
              ),
            ),
            if (foundation.isVerified)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: Colors.greenAccent.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      color: Colors.greenAccent,
                      size: 14.r,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      isAr ? 'موثق' : 'Verified',
                      style: AppTextStyle.caption(
                        context,
                        fontSize: 10.sp,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        SizedBox(height: 12.h),

        // Main Dashboard Info Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.12),
                Colors.white.withOpacity(0.04),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 54.r,
                    height: 54.r,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.teal.shade300, Colors.blue.shade500],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Icon(
                      Icons.business_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                foundation.name,
                                style: AppTextStyle.heading(
                                  context,
                                  fontSize: 18.sp,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (foundation.isVerified) ...[
                              SizedBox(width: 6.w),
                              Icon(
                                Icons.verified_rounded,
                                color: Colors.tealAccent,
                                size: 18.r,
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
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
              SizedBox(height: 18.h),
              Divider(color: Colors.white.withOpacity(0.1)),
              SizedBox(height: 12.h),

              Text(
                '${isAr ? 'نوع التبرع المفضل:' : 'Preferred Donation:'} ${foundation.donationType}',
                style: AppTextStyle.body(
                  context,
                  fontSize: 13.sp,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 16.h),

              // Progress Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isAr ? 'التقدم المحرز للجمع' : 'Collection Progress',
                    style: AppTextStyle.caption(
                      context,
                      fontSize: 12.sp,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: AppTextStyle.custom(
                      context,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6.h,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.teal.shade300,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${foundation.totalDonations.toStringAsFixed(0)} raised',
                    style: AppTextStyle.caption(
                      context,
                      fontSize: 11.sp,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    'Target: \$${foundation.targetAmount.toStringAsFixed(0)}',
                    style: AppTextStyle.caption(
                      context,
                      fontSize: 11.sp,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),

        // Statistics Cards Row
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.monetization_on_outlined,
                iconColor: Colors.teal.shade300,
                title: isAr ? 'إجمالي التبرعات' : 'Total Donations',
                value: '\$${foundation.totalDonations.toStringAsFixed(0)}',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.people_outline_rounded,
                iconColor: Colors.blue.shade300,
                title: isAr ? 'إجمالي المتبرعين' : 'Total Donors',
                value: '$uniqueDonors',
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),

        // Quick Actions Grid (Create Case, Edit Profile, View Donations)
        Text(
          isAr ? 'الإجراءات السريعة' : 'Quick Actions',
          style: AppTextStyle.heading(
            context,
            fontSize: 16.sp,
            color: Colors.white,
          ),
        ),

        // SizedBox(height: 12.h),
        // Row(
        //   children: [
        //     Expanded(
        //       child: _buildActionButton(
        //         context,
        //         icon: Icons.add_circle_outline_rounded,
        //         label: isAr ? 'إنشاء حالة' : 'Create Case',
        //         onTap: () => Navigator.pushNamed(context, AppRoutes.request),
        //       ),
        //     ),

        //     SizedBox(width: 10.w),
        //     Expanded(
        //       child: _buildActionButton(
        //         context,
        //         icon: Icons.history_rounded,
        //         label: isAr ? 'عرض السجل' : 'View Donations',
        //         onTap: () {
        //           if (parentScrollController != null && parentScrollController!.hasClients) {
        //             parentScrollController!.animateTo(
        //               parentScrollController!.position.maxScrollExtent,
        //               duration: const Duration(milliseconds: 600),
        //               curve: Curves.easeInOut,
        //             );
        //           }
        //         },
        //       ),
        //     ),
        //   ],
        // ),
        SizedBox(height: 28.h),

        // Recent Donations Ledger
        Text(
          isAr ? 'طلبات التبرع المستلمة' : 'Donation Requests Received',
          style: AppTextStyle.heading(
            context,
            fontSize: 16.sp,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12.h),

        if (receivedDonations.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.assignment_turned_in_outlined,
                  color: Colors.white38,
                  size: 36.r,
                ),
                SizedBox(height: 10.h),
                Text(
                  isAr
                      ? 'لا توجد تبرعات مستلمة بعد.'
                      : 'No donations received yet.',
                  style: AppTextStyle.body(
                    context,
                    color: Colors.white54,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: receivedDonations.length,
            itemBuilder: (context, index) {
              final donation = receivedDonations[index];
              final rawCreatedAt = (donation.createdAt as dynamic) ?? '';
              final dateStr = rawCreatedAt.contains('T')
                  ? rawCreatedAt.split('T')[0]
                  : rawCreatedAt;
              final donorName = (donation.donorName as dynamic) ?? '';
              final purpose = (donation.purpose as dynamic) ?? 'Money';
              final amount = (donation.amount as dynamic)?.toDouble() ?? 0.0;
              final details = (donation.details as dynamic) ?? '';

              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18.r,
                          backgroundColor: Colors.teal.shade700.withOpacity(
                            0.5,
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            size: 18.r,
                            color: Colors.teal.shade200,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              donorName,
                              style: AppTextStyle.heading(
                                context,
                                fontSize: 14.sp,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              dateStr,
                              style: AppTextStyle.caption(
                                context,
                                fontSize: 11.sp,
                                color: Colors.white54,
                              ),
                            ),
                            if (purpose != 'Money') ...[
                              SizedBox(height: 4.h),
                              SizedBox(
                                width: 150.w,
                                child: Text(
                                  '$purpose: $details',
                                  style: AppTextStyle.caption(
                                    context,
                                    fontSize: 12.sp,
                                    color: Colors.teal.shade100,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    Text(
                      purpose == 'Money'
                          ? '+\$${amount.toStringAsFixed(0)}'
                          : '+${amount.toStringAsFixed(0)} items',
                      style: AppTextStyle.custom(
                        context,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade300,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24.r),
          SizedBox(height: 6.h),
          Text(
            title,
            style: AppTextStyle.caption(
              context,
              fontSize: 11.sp,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: AppTextStyle.heading(
              context,
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.tealAccent, size: 22.r),
            SizedBox(height: 6.h),
            Text(
              label,
              style: AppTextStyle.custom(
                context,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
