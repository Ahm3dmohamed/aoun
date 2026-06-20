import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/features/recommendations/presentation/cubit/recommendations_cubit.dart';
import 'package:aoun/features/recommendations/presentation/cubit/recommendations_state.dart';
import 'package:aoun/features/recommendations/presentation/widgets/recommendation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecommendedDonationsSection extends StatelessWidget {
  const RecommendedDonationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return BlocBuilder<RecommendationsCubit, RecommendationsState>(
      builder: (context, state) {
        if (state is RecommendationsLoading || state is RecommendationsInitial) {
          return _buildLoadingSkeleton(context);
        }

        if (state is RecommendationsError) {
          return _buildError(context, state.message, isAr);
        }

        if (state is RecommendationsLoaded) {
          if (state.recommendations.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Section header ─────────────────────────────
              _buildHeader(context, isAr),
              SizedBox(height: 14.h),

              // ── Horizontal list ────────────────────────────
              SizedBox(
                height: 310.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.recommendations.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        right: isAr ? 0 : 14.w,
                        left: isAr ? 14.w : 0,
                      ),
                      child: RecommendationCard(
                        recommendation: state.recommendations[index],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 24.h),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isAr) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: Colors.blueAccent.withOpacity(0.3),
                ),
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 16.r,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              isAr ? 'التبرعات المقترحة لك' : 'Recommended For You',
              style: AppTextStyle.heading(
                context,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => context
              .read<RecommendationsCubit>()
              .refresh(),
          child: Icon(
            Icons.refresh_rounded,
            size: 20.r,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingSkeleton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Skeleton header
        Container(
          height: 20.h,
          width: 180.w,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
        SizedBox(height: 14.h),
        SizedBox(
          height: 310.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(right: 14.w),
              child: Container(
                width: 260.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 130.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.r),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 12.h,
                            width: 80.w,
                            color: Colors.white.withOpacity(0.08),
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            height: 14.h,
                            width: 180.w,
                            color: Colors.white.withOpacity(0.08),
                          ),
                          SizedBox(height: 6.h),
                          Container(
                            height: 10.h,
                            width: 120.w,
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildError(BuildContext context, String message, bool isAr) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.redAccent.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded,
              color: Colors.redAccent, size: 20.r),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              isAr
                  ? 'تعذر تحميل التوصيات'
                  : 'Could not load recommendations',
              style: AppTextStyle.caption(
                context,
                fontSize: 13,
                color: Colors.white70,
              ),
            ),
          ),
          TextButton(
            onPressed: () =>
                context.read<RecommendationsCubit>().refresh(),
            child: Text(
              isAr ? 'إعادة' : 'Retry',
              style: AppTextStyle.caption(
                context,
                fontSize: 12,
                color: Colors.blueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
