import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/features/foundations/domain/entities/foundation_entity.dart';
import 'package:aoun/features/foundations/presentation/widgets/foundation_card.dart';
import 'package:aoun/features/recommendations/presentation/widgets/recommended_donations_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DonorHomeSection extends StatelessWidget {
  final List<FoundationEntity> foundations;

  const DonorHomeSection({super.key, required this.foundations});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    final newestFoundations = List<FoundationEntity>.from(foundations);
    newestFoundations.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Newest Foundations Section ──
        if (foundations.isNotEmpty) ...[
          _buildSectionHeader(
            context,
            isAr ? 'المؤسسات المضافة حديثاً' : 'Newest Foundations',
          ),
          SizedBox(height: 12.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: newestFoundations.length,
            itemBuilder: (context, index) {
              return FoundationCard(foundation: newestFoundations[index]);
            },
          ),
        ] else
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Text(
                isAr
                    ? 'لا توجد مؤسسات متاحة حالياً.'
                    : 'No foundations available at this time.',
                style: AppTextStyle.body(
                  context,
                  color: Colors.white70,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
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
