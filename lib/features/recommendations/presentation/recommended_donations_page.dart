import 'dart:ui';
import 'package:aoun/core/themes/app_colors.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/features/recommendations/domain/entities/recommendation_entity.dart';
import 'package:aoun/features/recommendations/presentation/cubit/recommendations_cubit.dart';
import 'package:aoun/features/recommendations/presentation/cubit/recommendations_state.dart';
import 'package:aoun/features/recommendations/presentation/widgets/recommendation_card.dart';
import 'package:aoun/features/splash/splash_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Filter options
enum _Filter { all, urgent, topPick, medical, food, education }

class RecommendedDonationsPage extends StatefulWidget {
  const RecommendedDonationsPage({super.key});

  @override
  State<RecommendedDonationsPage> createState() =>
      _RecommendedDonationsPageState();
}

class _RecommendedDonationsPageState extends State<RecommendedDonationsPage>
    with SingleTickerProviderStateMixin {
  _Filter _activeFilter = _Filter.all;
  late final AnimationController _headerAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _headerAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _headerAnim, curve: Curves.easeOut);
    context.read<RecommendationsCubit>().loadRecommendations();
  }

  @override
  void dispose() {
    _headerAnim.dispose();
    super.dispose();
  }

  List<RecommendationEntity> _applyFilter(List<RecommendationEntity> list) {
    switch (_activeFilter) {
      case _Filter.urgent:
        return list
            .where(
              (r) =>
                  r.urgency.toLowerCase() == 'high' ||
                  r.urgency.toLowerCase() == 'critical',
            )
            .toList();
      case _Filter.topPick:
        return list.where((r) => r.recommendationScore >= 90).toList();
      case _Filter.medical:
        return list
            .where((r) => r.category.toLowerCase() == 'medical')
            .toList();
      case _Filter.food:
        return list.where((r) => r.category.toLowerCase() == 'food').toList();
      case _Filter.education:
        return list
            .where((r) => r.category.toLowerCase() == 'education')
            .toList();
      case _Filter.all:
        return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      body: SplashBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Sticky Header ───────────────────────────────────
              FadeTransition(
                opacity: _fadeAnim,
                child: _buildHeader(context, isAr),
              ),

              // ── Filter Chips ────────────────────────────────────
              FadeTransition(opacity: _fadeAnim, child: _buildFilterBar(isAr)),

              // ── Content ─────────────────────────────────────────
              Expanded(
                child: BlocBuilder<RecommendationsCubit, RecommendationsState>(
                  builder: (context, state) {
                    if (state is RecommendationsLoading ||
                        state is RecommendationsInitial) {
                      return _buildLoadingSkeleton();
                    }

                    if (state is RecommendationsError) {
                      return _buildError(state.message, isAr);
                    }

                    if (state is RecommendationsLoaded) {
                      final filtered = _applyFilter(state.recommendations);
                      if (state.recommendations.isEmpty) {
                        return _buildEmptyState(isAr);
                      }
                      return _buildList(filtered, state.recommendations, isAr);
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Header
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, bool isAr) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // AI icon bubble
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF6366F1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 20.r,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAr ? 'مقترحة بالذكاء الاصطناعي' : 'AI Recommendations',
                      style: AppTextStyle.heading(
                        context,
                        fontSize: 20,
                        color: Colors.white,
                      ).copyWith(fontWeight: FontWeight.w800, height: 1.2),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      isAr ? 'قضايا مختارة خصيصاً لك' : 'Curated just for you',
                      style: AppTextStyle.caption(
                        context,
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
              // Refresh button
              BlocBuilder<RecommendationsCubit, RecommendationsState>(
                builder: (context, state) {
                  final isLoading = state is RecommendationsLoading;
                  return GestureDetector(
                    onTap: isLoading
                        ? null
                        : () => context.read<RecommendationsCubit>().refresh(),
                    child: Container(
                      width: 38.w,
                      height: 38.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      child: isLoading
                          ? Padding(
                              padding: EdgeInsets.all(10.w),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white54,
                              ),
                            )
                          : Icon(
                              Icons.refresh_rounded,
                              size: 18.r,
                              color: Colors.white60,
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Stats bar
          BlocBuilder<RecommendationsCubit, RecommendationsState>(
            builder: (context, state) {
              if (state is! RecommendationsLoaded ||
                  state.recommendations.isEmpty) {
                return const SizedBox.shrink();
              }
              final list = state.recommendations;
              final urgentCount = list
                  .where(
                    (r) =>
                        r.urgency.toLowerCase() == 'high' ||
                        r.urgency.toLowerCase() == 'critical',
                  )
                  .length;
              final topCount = list
                  .where((r) => r.recommendationScore >= 90)
                  .length;
              final totalTarget = list.fold<double>(
                0,
                (sum, r) => sum + r.remainingAmount,
              );

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    _StatItem(
                      value: '${list.length}',
                      label: isAr ? 'قضايا' : 'Cases',
                      color: const Color(0xFF60A5FA),
                    ),
                    _StatDivider(),
                    _StatItem(
                      value: '$urgentCount',
                      label: isAr ? 'عاجل' : 'Urgent',
                      color: const Color(0xFFEF4444),
                    ),
                    _StatDivider(),
                    _StatItem(
                      value: '$topCount',
                      label: isAr ? 'الأفضل' : 'Top Picks',
                      color: const Color(0xFF22C55E),
                    ),
                    _StatDivider(),
                    _StatItem(
                      value: '\$${_formatAmount(totalTarget)}',
                      label: isAr ? 'متبقي' : 'Needed',
                      color: const Color(0xFFFBBF24),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 14.h),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Filter Bar
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildFilterBar(bool isAr) {
    final filters = [
      (_Filter.all, isAr ? 'الكل' : 'All', Icons.grid_view_rounded),
      (_Filter.topPick, isAr ? 'الأفضل' : 'Top Picks', Icons.star_rounded),
      (_Filter.urgent, isAr ? 'عاجل' : 'Urgent', Icons.bolt_rounded),
      (_Filter.medical, isAr ? 'طبي' : 'Medical', Icons.local_hospital_rounded),
      (_Filter.food, isAr ? 'غذاء' : 'Food', Icons.fastfood_rounded),
      (_Filter.education, isAr ? 'تعليم' : 'Education', Icons.school_rounded),
    ];

    return SizedBox(
      height: 42.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: const BouncingScrollPhysics(),
        itemCount: filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, i) {
          final (filter, label, icon) = filters[i];
          final isActive = _activeFilter == filter;
          return GestureDetector(
            onTap: () => setState(() => _activeFilter = filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 0),
              decoration: BoxDecoration(
                gradient: isActive
                    ? const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF6366F1)],
                      )
                    : null,
                color: isActive ? null : Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isActive
                      ? Colors.transparent
                      : Colors.white.withOpacity(0.15),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 13.r,
                    color: isActive ? Colors.white : Colors.white60,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    label,
                    style: AppTextStyle.caption(
                      context,
                      fontSize: 12,
                      color: isActive ? Colors.white : Colors.white60,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // List
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildList(
    List<RecommendationEntity> filtered,
    List<RecommendationEntity> all,
    bool isAr,
  ) {
    return RefreshIndicator(
      color: AppColors.lightPrimary,
      backgroundColor: const Color(0xFF1E1E2E),
      onRefresh: () => context.read<RecommendationsCubit>().refresh(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
            sliver: filtered.isEmpty
                ? SliverFillRemaining(child: _buildNoResultsForFilter(isAr))
                : SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: RecommendationCard(
                          recommendation: filtered[index],
                          width: double.infinity,
                        ),
                      );
                    }, childCount: filtered.length),
                  ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Loading Skeleton
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildLoadingSkeleton() {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: _ShimmerCard(),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Empty / Error States
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildNoResultsForFilter(bool isAr) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.filter_list_off_rounded,
            size: 54.r,
            color: Colors.white24,
          ),
          SizedBox(height: 16.h),
          Text(
            isAr ? 'لا توجد نتائج لهذا الفلتر' : 'No results for this filter',
            style: AppTextStyle.body(
              context,
              fontSize: 15,
              color: Colors.white60,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 12.h),
          TextButton(
            onPressed: () => setState(() => _activeFilter = _Filter.all),
            child: Text(
              isAr ? 'عرض الكل' : 'Show All',
              style: AppTextStyle.body(
                context,
                fontSize: 13,
                color: const Color(0xFF60A5FA),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isAr) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF3B82F6).withOpacity(0.15),
                    const Color(0xFF6366F1).withOpacity(0.08),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF6366F1).withOpacity(0.3),
                ),
              ),
              child: Icon(
                Icons.auto_awesome_outlined,
                size: 44.r,
                color: const Color(0xFF6366F1).withOpacity(0.6),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              isAr ? 'لا توجد توصيات حالياً' : 'No Recommendations Yet',
              style: AppTextStyle.heading(
                context,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              isAr
                  ? 'تبرع بحالات لتمكين الذكاء الاصطناعي من تقديم توصيات مخصصة.'
                  : 'Donate to cases so our AI can recommend personalized cases for you.',
              textAlign: TextAlign.center,
              style: AppTextStyle.body(
                context,
                fontSize: 13,
                color: Colors.white54,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 28.h),
            ElevatedButton.icon(
              icon: Icon(Icons.refresh_rounded, size: 18.r),
              label: Text(isAr ? 'تحديث' : 'Refresh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightPrimary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 13.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 0,
              ),
              onPressed: () => context.read<RecommendationsCubit>().refresh(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String message, bool isAr) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: Colors.redAccent.withOpacity(0.25)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.wifi_off_rounded,
                      color: Colors.redAccent,
                      size: 34.r,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    isAr ? 'تعذر تحميل التوصيات' : 'Failed to Load',
                    style: AppTextStyle.heading(
                      context,
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.caption(
                      context,
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton.icon(
                    icon: Icon(Icons.refresh_rounded, size: 16.r),
                    label: Text(isAr ? 'إعادة المحاولة' : 'Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () =>
                        context.read<RecommendationsCubit>().refresh(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}k';
    }
    return amount.toStringAsFixed(0);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helper Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyle.subHeading(
              context,
              fontSize: 15,
              color: color,
            ).copyWith(fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: AppTextStyle.caption(
              context,
              fontSize: 10,
              color: Colors.white38,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28.h,
      color: Colors.white.withOpacity(0.12),
    );
  }
}

class _ShimmerCard extends StatefulWidget {
  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final opacity = 0.04 + (_anim.value * 0.06);
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image placeholder
              Container(
                height: 160.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(opacity),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _shimmerBox(80.w, 26.h, opacity),
                        const Spacer(),
                        _shimmerBox(70.w, 26.h, opacity),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    _shimmerBox(double.infinity, 16.h, opacity),
                    SizedBox(height: 6.h),
                    _shimmerBox(200.w, 14.h, opacity),
                    SizedBox(height: 14.h),
                    _shimmerBox(120.w, 12.h, opacity),
                    SizedBox(height: 16.h),
                    _shimmerBox(double.infinity, 8.h, opacity, radius: 6.r),
                    SizedBox(height: 14.h),
                    _shimmerBox(double.infinity, 46.h, opacity, radius: 14.r),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _shimmerBox(double w, double h, double opacity, {double? radius}) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        borderRadius: BorderRadius.circular(radius ?? 8.r),
      ),
    );
  }
}
