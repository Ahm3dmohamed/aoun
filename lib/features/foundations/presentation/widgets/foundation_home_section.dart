import 'package:aoun/core/routing/app_routes.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/features/cases/domain/entities/case_entity.dart';
import 'package:aoun/features/home/presentation/widgets/case_card.dart';
import 'package:aoun/features/foundations/domain/entities/donation_entity.dart';
import 'package:aoun/features/foundations/domain/entities/foundation_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoundationHomeSection extends StatelessWidget {
  final FoundationEntity foundation;
  final List<DonationEntity> receivedDonations;
  final List<CaseEntity> cases;

  const FoundationHomeSection({
    super.key,
    required this.foundation,
    required this.receivedDonations,
    required this.cases,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final progress = (foundation.totalDonations / foundation.targetAmount).clamp(0.0, 1.0);
    
    // Calculate unique donors count
    final uniqueDonors = receivedDonations.map((d) => d.donorName).toSet().length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // My Foundation Title Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isAr ? 'لوحة التحكم للمؤسسة' : 'Foundation Dashboard',
              style: AppTextStyle.heading(context, fontSize: 18.sp, color: Colors.white),
            ),
            IconButton(
              icon: const Icon(Icons.edit_note_rounded, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isAr ? 'ميزة تعديل الملف الشخصي قيد التطوير' : 'Profile editing is coming soon!'),
                    backgroundColor: Colors.teal,
                  ),
                );
              },
              tooltip: isAr ? 'تعديل الملف' : 'Edit Profile',
            ),
          ],
        ),
        
        SizedBox(height: 12.h),

        // Main Dashboard card
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
                      gradient: LinearGradient(colors: [Colors.teal.shade300, Colors.blue.shade500]),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Icon(Icons.business_rounded, color: Colors.white, size: 28),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          foundation.name,
                          style: AppTextStyle.heading(context, fontSize: 18.sp, color: Colors.white),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                foundation.foundationType.toUpperCase(),
                                style: AppTextStyle.caption(context, fontSize: 10.sp, color: Colors.teal.shade200),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(Icons.location_on_outlined, size: 14.r, color: Colors.white70),
                            SizedBox(width: 2.w),
                            Text(
                              foundation.location,
                              style: AppTextStyle.caption(context, fontSize: 12.sp, color: Colors.white70),
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
                '${isAr ? 'نوع التبرع المطلوب:' : 'Required Donation:'} ${foundation.donationType}',
                style: AppTextStyle.body(
                  context,
                  fontSize: 13.sp,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.normal,
                ),
              ),

              SizedBox(height: 16.h),

              // Progress row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isAr ? 'تقدم جمع التبرعات' : 'Donation Progress',
                    style: AppTextStyle.caption(context, fontSize: 12.sp, color: Colors.white70),
                  ),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: AppTextStyle.custom(context, fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.white),
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
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade300),
                ),
              ),
              SizedBox(height: 6.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${foundation.totalDonations.toStringAsFixed(0)} raised',
                    style: AppTextStyle.caption(context, fontSize: 11.sp, color: Colors.white70),
                  ),
                  Text(
                    'Target: \$${foundation.targetAmount.toStringAsFixed(0)}',
                    style: AppTextStyle.caption(context, fontSize: 11.sp, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 20.h),

        // Quick Stats Cards Grid
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.monetization_on_outlined, color: Colors.teal.shade300, size: 24.r),
                    SizedBox(height: 6.h),
                    Text(
                      isAr ? 'إجمالي التبرعات' : 'Total Donations',
                      style: AppTextStyle.caption(context, fontSize: 11.sp, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '\$${foundation.totalDonations.toStringAsFixed(0)}',
                      style: AppTextStyle.heading(context, fontSize: 16.sp, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.people_outline_rounded, color: Colors.blue.shade300, size: 24.r),
                    SizedBox(height: 6.h),
                    Text(
                      isAr ? 'إجمالي المتبرعين' : 'Total Donors',
                      style: AppTextStyle.caption(context, fontSize: 11.sp, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '$uniqueDonors',
                      style: AppTextStyle.heading(context, fontSize: 16.sp, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 28.h),

        // Quick Actions Grid (Create Case, View Donations)
        Text(
          isAr ? 'الإجراءات السريعة' : 'Quick Actions',
          style: AppTextStyle.heading(
            context,
            fontSize: 16.sp,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                icon: Icons.add_circle_outline_rounded,
                label: isAr ? 'إنشاء حالة' : 'Create Case',
                onTap: () => Navigator.pushNamed(context, AppRoutes.request),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildActionButton(
                context,
                icon: Icons.history_rounded,
                label: isAr ? 'عرض السجل' : 'View Donations',
                onTap: () {},
              ),
            ),
          ],
        ),
        SizedBox(height: 28.h),

        // Active Cases Section
        Builder(
          builder: (context) {
            final foundationCases = cases.where((c) {
              if (c.foundationName == null) return false;
              return c.foundationName!.trim().toLowerCase() == foundation.name.trim().toLowerCase();
            }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAr ? 'حالاتنا النشطة' : 'Our Active Cases',
                  style: AppTextStyle.heading(
                    context,
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12.h),
                if (foundationCases.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.volunteer_activism_outlined,
                          color: Colors.white38,
                          size: 36.r,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          isAr
                              ? 'لا توجد حالات مضافة من مؤسستك بعد.'
                              : 'No cases added by your foundation yet.',
                          style: AppTextStyle.body(
                            context,
                            color: Colors.white54,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade400,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          ),
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.request),
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: Text(isAr ? 'إنشاء حالة أولى' : 'Create First Case'),
                        ),
                      ],
                    ),
                  )
                else
                  SizedBox(
                    height: 380.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: foundationCases.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 300.w,
                          child: Padding(
                            padding: EdgeInsets.only(right: 16.w),
                            child: CaseCard(caseItem: foundationCases[index]),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          }
        ),
        SizedBox(height: 28.h),

        // Recent Donations / Requests Received list
        Text(
          isAr ? 'طلبات التبرع المستلمة' : 'Donation Requests Received',
          style: AppTextStyle.heading(context, fontSize: 16.sp, color: Colors.white),
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
                Icon(Icons.assignment_turned_in_outlined, color: Colors.white38, size: 36.r),
                SizedBox(height: 10.h),
                Text(
                  isAr ? 'لا توجد تبرعات مستلمة بعد.' : 'No donations received yet.',
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
              final dateStr = donation.createdAt.split('T')[0];

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
                          backgroundColor: Colors.teal.shade700.withOpacity(0.5),
                          child: Icon(Icons.person_rounded, size: 18.r, color: Colors.teal.shade200),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              donation.donorName,
                              style: AppTextStyle.heading(context, fontSize: 14.sp, color: Colors.white),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              dateStr,
                              style: AppTextStyle.caption(context, fontSize: 11.sp, color: Colors.white54),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '+\$${donation.amount.toStringAsFixed(0)}',
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
