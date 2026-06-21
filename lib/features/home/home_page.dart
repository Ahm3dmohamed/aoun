import 'package:aoun/core/di/injection_container.dart';
import 'package:aoun/core/extensions/localization_extension.dart';
import 'package:aoun/core/storage/auth_local_data_source.dart';
import 'package:aoun/core/themes/app_colors.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/features/foundations/presentation/pages/donation_page.dart';
import 'package:aoun/features/home/presentation/cubit/home_cubit.dart';
import 'package:aoun/features/home/presentation/cubit/home_state.dart';
import 'package:aoun/features/home/presentation/widgets/case_card.dart';
import 'package:aoun/features/home/presentation/widgets/donor_cases_section.dart';
import 'package:aoun/features/home/presentation/widgets/foundation_dashboard_section.dart';
import 'package:aoun/features/splash/splash_background.dart';
import 'package:aoun/features/foundations/presentation/cubit/foundation_cubit.dart';
import 'package:aoun/features/foundations/presentation/cubit/foundation_state.dart';
import 'package:aoun/features/foundations/presentation/widgets/donor_home_section.dart';
import 'package:aoun/features/foundations/presentation/widgets/foundation_home_section.dart';
import 'package:aoun/features/recommendations/presentation/cubit/recommendations_cubit.dart';
import 'package:aoun/features/recommendations/presentation/widgets/recommended_donations_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  String? _userName;
  String _userRole = 'donor';
  String _userEmail = '';
  bool _isUserLoading = true;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHomeData();
    _loadUserInfo();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadUserInfo() async {
    final userData = await sl<AuthLocalDataSource>().getUserData();
    if (!mounted) return;
    final role = userData?['role']?.toString() ?? 'donor';
    final email = userData?['email']?.toString() ?? '';
    setState(() {
      _userName = userData?['name']?.toString();
      _userRole = role;
      _userEmail = email;
      _isUserLoading = false;
    });

    if (role == 'donor') {
      context.read<FoundationCubit>().fetchFoundations();
      // Load AI recommendations once on init (cached in memory)
      context.read<RecommendationsCubit>().loadRecommendations();
    }
  }

  void _refreshHomeData() {
    context.read<HomeCubit>().loadHomeData();
    if (_userRole == 'donor') {
      context.read<FoundationCubit>().fetchFoundations();
      context.read<RecommendationsCubit>().refresh();
    }
  }

  void _scrollToCases() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        340.h,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return SplashBackground(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),

              // Custom Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userName != null
                              ? '${isAr ? 'مرحباً،' : 'Hello,'} $_userName'
                              : (isAr ? 'مرحباً بك في عون' : 'Welcome to Aoun'),
                          style: AppTextStyle.subHeading(
                            context,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          isAr
                              ? 'دعنا نصنع فرقاً اليوم!'
                              : 'Let\'s make a difference today!',
                          style: AppTextStyle.caption(
                            context,
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 22.r,
                    backgroundColor: Colors.white.withOpacity(0.12),
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: Colors.white,
                      size: 24.r,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // Welcome Intro Banner Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.12),
                      Colors.white.withOpacity(0.04),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Image.asset('assets/img/splash_logo.png', height: 70.h),
                    SizedBox(height: 12.h),
                    Text(
                      loc.homeIntroTitle,
                      style: AppTextStyle.heading(
                        context,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      loc.homeIntroSubtitle,
                      style: AppTextStyle.body(
                        context,
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    // ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.white.withOpacity(0.15),
                    //     foregroundColor: Colors.white,
                    //     padding: EdgeInsets.symmetric(
                    //       horizontal: 24.w,
                    //       vertical: 10.h,
                    //     ),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8.r),
                    //       side: BorderSide(
                    //         color: Colors.white.withOpacity(0.3),
                    //       ),
                    //     ),
                    //   ),
                    //   onPressed: _scrollToCases,
                    //   child: Text(
                    //     loc.donateNow,
                    //     style: AppTextStyle.custom(
                    //       context,
                    //       fontSize: 14,
                    //       fontWeight: FontWeight.w600,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Foundations / Donation Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _userRole == 'foundation_admin'
                        ? (isAr ? 'إدارة المؤسسة' : 'Manage Foundation')
                        : (isAr ? 'الحالات النشطة' : 'Active Cases'),
                    style: AppTextStyle.heading(
                      context,
                      fontSize: 18.sp,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                    ),
                    onPressed: _refreshHomeData,
                    tooltip: isAr ? 'تحديث' : 'Refresh',
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (_isUserLoading ||
                      state is HomeLoading ||
                      state is HomeInitial) {
                    return _buildLoadingShimmer();
                  } else if (state is HomeError) {
                    return _buildErrorState(state.message);
                  } else if (state is FoundationHomeLoaded) {
                    return FoundationDashboardSection(
                      foundation: state.foundation,
                      receivedDonations: state.receivedDonations,
                      parentScrollController: _scrollController,
                    );
                  } else if (state is DonorHomeLoaded) {
                    return Column(
                      children: [
                        DonorCasesSection(cases: state.cases),
                        SizedBox(height: 24.h),
                        BlocBuilder<FoundationCubit, FoundationState>(
                          buildWhen: (prev, curr) =>
                              prev.isLoading != curr.isLoading ||
                              prev.foundations != curr.foundations,
                          builder: (context, foundationState) {
                            if (foundationState.isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            }
                            return DonorHomeSection(
                              foundations: foundationState.foundations,
                            );
                          },
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Bottom padding to avoid navigation bar overlap
              SizedBox(height: 80.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          height: 180.h,
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 15, 15, 15).withOpacity(0.5),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Container(
                  width: 90.w,
                  height: 90.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 14.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        height: 10.h,
                        width: 160.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      Container(
                        height: 10.h,
                        width: 160.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      Container(
                        height: 6.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Colors.redAccent,
            size: 44.r,
          ),
          SizedBox(height: 12.h),
          Text(
            isAr ? 'فشل تحميل الحالات' : 'Failed to load cases',
            style: AppTextStyle.subHeading(
              context,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            message,
            style: AppTextStyle.caption(
              context,
              fontSize: 12,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: () => context.read<HomeCubit>().fetchCases(),
            icon: const Icon(Icons.refresh_rounded),
            label: Text(isAr ? 'إعادة المحاولة' : 'Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.volunteer_activism_outlined,
            color: Colors.white54,
            size: 44.r,
          ),
          SizedBox(height: 12.h),
          Text(
            isAr ? 'لا توجد حالات نشطة حالياً' : 'No active cases found',
            style: AppTextStyle.subHeading(
              context,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
