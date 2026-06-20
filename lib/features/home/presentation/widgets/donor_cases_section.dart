import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/features/cases/domain/entities/case_entity.dart';
import 'package:aoun/features/home/presentation/widgets/case_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DonorCasesSection extends StatelessWidget {
  final List<CaseEntity> cases;

  const DonorCasesSection({super.key, required this.cases});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    if (cases.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: Text(
            isAr
                ? 'لا توجد حالات متاحة حالياً.'
                : 'No active cases available at this time.',
            style: AppTextStyle.body(
              context,
              color: Colors.white70,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      );
    }

    // Filter categories dynamically
    final urgentCases = cases
        .where((c) => c.urgency.toLowerCase() == 'high')
        .toList();

    // Recommended could be medical or higher target cases, fallback to first few if none match
    final recommended = cases
        .where(
          (c) =>
              c.targetAmount >= 150000 || c.category.toLowerCase() == 'medical',
        )
        .toList();
    final recommendedDisplay = recommended.isNotEmpty
        ? recommended
        : cases.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Horizontal Urgent Cases (if any exist)
        if (urgentCases.isNotEmpty) ...[
          // _buildSectionHeader(context, isAr ? 'حالات عاجلة' : 'Urgent Cases'),
          // SizedBox(height: 12.h),
          SizedBox(
            height: 380.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: urgentCases.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 300.w,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: CaseCard(caseItem: urgentCases[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyle.heading(
            context,
            fontSize: 18.sp,
            color: Colors.white,
          ),
        ),
        Icon(
          isAr
              ? Icons.arrow_back_ios_new_rounded
              : Icons.arrow_forward_ios_rounded,
          size: 14.r,
          color: Colors.teal.shade200,
        ),
      ],
    );
  }
}
