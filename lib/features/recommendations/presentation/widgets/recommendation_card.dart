import 'dart:ui';
import 'package:aoun/core/themes/app_colors.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/features/foundations/domain/entities/foundation_entity.dart';
import 'package:aoun/features/foundations/presentation/pages/donation_page.dart';
import 'package:aoun/features/recommendations/domain/entities/recommendation_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecommendationCard extends StatelessWidget {
  final RecommendationEntity recommendation;
  final double? width;

  const RecommendationCard({
    super.key,
    required this.recommendation,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final progress = recommendation.progressPercent;
    final score = recommendation.recommendationScore;
    final imageUrl = _resolveImageUrl(recommendation);

    final _ScoreMeta scoreMeta = _getScoreMeta(score, isAr);
    final _UrgencyMeta urgencyMeta = _getUrgencyMeta(
      recommendation.urgency,
      isAr,
    );

    return GestureDetector(
      onTap: () => _navigateToDonate(context, imageUrl),
      child: Container(
        width: width ?? 280.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.13),
                    Colors.white.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.0,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Hero Image ──────────────────────────────────
                  _buildHeroImage(
                    context,
                    imageUrl,
                    scoreMeta,
                    urgencyMeta,
                    score,
                    isAr,
                  ),

                  // ── Content ─────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Category chip + score chip row
                        Row(
                          children: [
                            _CategoryChip(
                              label: _localizeCategory(
                                recommendation.category,
                                isAr,
                              ),
                              icon: _categoryIcon(recommendation.category),
                            ),
                            const Spacer(),
                            _ScoreChip(meta: scoreMeta),
                          ],
                        ),
                        SizedBox(height: 10.h),

                        // Title
                        Text(
                          recommendation.title,
                          style: AppTextStyle.subHeading(
                            context,
                            fontSize: 15,
                            color: Colors.white,
                          ).copyWith(height: 1.35, fontWeight: FontWeight.w700),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6.h),

                        // Description
                        Text(
                          recommendation.description,
                          style: AppTextStyle.caption(
                            context,
                            fontSize: 12,
                            color: Colors.white60,
                          ).copyWith(height: 1.4),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 12.h),

                        // Location row
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 13.r,
                              color: const Color(0xFF60A5FA),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                recommendation.location,
                                style: AppTextStyle.caption(
                                  context,
                                  fontSize: 11,
                                  color: const Color(0xFF60A5FA),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),

                        // Progress section
                        _buildProgressSection(context, progress, isAr),
                        SizedBox(height: 14.h),

                        // Amount row
                        _buildAmountRow(context, isAr),
                        SizedBox(height: 14.h),

                        // CTA Button
                        _buildDonateButton(context, progress, imageUrl, isAr),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroImage(
    BuildContext context,
    String imageUrl,
    _ScoreMeta scoreMeta,
    _UrgencyMeta urgencyMeta,
    double score,
    bool isAr,
  ) {
    return Stack(
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          child: SizedBox(
            height: 160.h,
            width: double.infinity,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) =>
                  progress == null ? child : _imagePlaceholder(),
              errorBuilder: (_, __, ___) => _imagePlaceholder(),
            ),
          ),
        ),
        // Dark gradient overlay
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.55)],
              ),
            ),
          ),
        ),
        // Urgency badge — top right/left
        Positioned(
          top: 10.h,
          left: isAr ? 10.w : null,
          right: isAr ? null : 10.w,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: urgencyMeta.color.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(urgencyMeta.icon, size: 11.r, color: Colors.white),
                    SizedBox(width: 4.w),
                    Text(
                      urgencyMeta.label,
                      style: AppTextStyle.caption(
                        context,
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // AI score badge — top left/right
        Positioned(
          top: 10.h,
          left: isAr ? null : 10.w,
          right: isAr ? 10.w : null,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: scoreMeta.color.withOpacity(0.6),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 11.r,
                      color: scoreMeta.color,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${score.toStringAsFixed(0)}%',
                      style: AppTextStyle.caption(
                        context,
                        fontSize: 10,
                        color: Colors.white,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(
    BuildContext context,
    double progress,
    bool isAr,
  ) {
    final Color progressColor = progress >= 1.0
        ? const Color(0xFF22C55E)
        : AppColors.lightPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isAr ? 'تم جمعه' : 'Funded',
              style: AppTextStyle.caption(
                context,
                fontSize: 11,
                color: Colors.white54,
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: AppTextStyle.caption(
                context,
                fontSize: 11,
                color: progressColor,
              ).copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7.h,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountRow(BuildContext context, bool isAr) {
    return Row(
      children: [
        Expanded(
          child: _AmountTile(
            label: isAr ? 'الهدف' : 'Goal',
            amount: recommendation.targetAmount,
            color: Colors.white70,
          ),
        ),
        Container(
          width: 1,
          height: 32.h,
          color: Colors.white.withOpacity(0.12),
        ),
        Expanded(
          child: _AmountTile(
            label: isAr ? 'المتبقي' : 'Remaining',
            amount: recommendation.remainingAmount,
            color: const Color(0xFFFBBF24),
          ),
        ),
        Container(
          width: 1,
          height: 32.h,
          color: Colors.white.withOpacity(0.12),
        ),
        Expanded(
          child: _AmountTile(
            label: isAr ? 'تم' : 'Raised',
            amount: recommendation.donatedAmount,
            color: const Color(0xFF34D399),
          ),
        ),
      ],
    );
  }

  Widget _buildDonateButton(
    BuildContext context,
    double progress,
    String imageUrl,
    bool isAr,
  ) {
    final bool completed = progress >= 1.0;

    return SizedBox(
      width: double.infinity,
      height: 46.h,
      child: completed
          ? Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: Colors.white24),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 16.r,
                    color: const Color(0xFF22C55E),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    isAr ? 'اكتمل التمويل' : 'Fully Funded',
                    style: AppTextStyle.caption(
                      context,
                      fontSize: 13,
                      color: const Color(0xFF22C55E),
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )
          : ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightPrimary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    padding: EdgeInsets.zero,
                  ).copyWith(
                    overlayColor: WidgetStateProperty.all(
                      Colors.white.withOpacity(0.1),
                    ),
                  ),
              onPressed: () => _navigateToDonate(context, imageUrl),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.volunteer_activism_rounded,
                    size: 16.r,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    isAr ? 'تبرع الآن' : 'Donate Now',
                    style: AppTextStyle.custom(
                      context,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _navigateToDonate(BuildContext context, String imageUrl) {
    final dummyFoundation = FoundationEntity(
      id: 'rec_${recommendation.id}',
      name: recommendation.title,
      email: 'recommendation@aoun.com',
      phone: '',
      foundationType: 'case',
      donationType: recommendation.category,
      location: recommendation.location,
      createdAt: DateTime.now().toIso8601String(),
      totalDonations: recommendation.donatedAmount,
      targetAmount: recommendation.targetAmount,
      description: recommendation.description,
      imageUrl: imageUrl,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DonationPage(foundation: dummyFoundation, viewOnly: false),
      ),
    );
  }

  _ScoreMeta _getScoreMeta(double score, bool isAr) {
    if (score >= 90) {
      return _ScoreMeta(
        color: const Color(0xFF22C55E),
        label: isAr ? 'موصى به بشدة' : 'Top Pick',
        icon: Icons.star_rounded,
      );
    } else if (score >= 70) {
      return _ScoreMeta(
        color: const Color(0xFFF59E0B),
        label: isAr ? 'موصى به' : 'Recommended',
        icon: Icons.thumb_up_rounded,
      );
    } else {
      return _ScoreMeta(
        color: const Color(0xFF60A5FA),
        label: isAr ? 'مقترح' : 'Suggested',
        icon: Icons.lightbulb_rounded,
      );
    }
  }

  _UrgencyMeta _getUrgencyMeta(String urgency, bool isAr) {
    final u = urgency.toLowerCase();
    if (u == 'critical') {
      return _UrgencyMeta(
        color: const Color(0xFFDC2626),
        label: isAr ? 'حرج' : 'Critical',
        icon: Icons.warning_rounded,
      );
    } else if (u == 'high') {
      return _UrgencyMeta(
        color: const Color(0xFFEA580C),
        label: isAr ? 'عاجل' : 'Urgent',
        icon: Icons.bolt_rounded,
      );
    } else {
      return _UrgencyMeta(
        color: const Color(0xFF0891B2),
        label: isAr ? 'عادي' : 'Normal',
        icon: Icons.info_rounded,
      );
    }
  }

  String _resolveImageUrl(RecommendationEntity rec) {
    if (rec.imagePath != null && rec.imagePath!.isNotEmpty) {
      final path = rec.imagePath!;

      if (path.startsWith('http')) {
        return path;
      }

      return 'https://untakable-tien-unwadable.ngrok-free.dev/storage/$path';
    }

    switch (rec.category.toLowerCase()) {
      case 'medical':
        return 'https://images.unsplash.com/photo-1631815588090-d4bfec5b1ccb?w=800';
      case 'food':
        return 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=800';
      case 'clothes':
        return 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=800';
      case 'blood':
        return 'https://images.unsplash.com/photo-1615461066841-6116e61058f4?w=800';
      case 'education':
        return 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=800';
      default:
        return 'https://images.unsplash.com/photo-1516627145497-ae6968895b74?w=800';
    }
  }

  String _localizeCategory(String category, bool isAr) {
    if (!isAr) return category[0].toUpperCase() + category.substring(1);
    switch (category.toLowerCase()) {
      case 'medical':
        return 'طبي';
      case 'food':
        return 'غذاء';
      case 'clothes':
        return 'ملابس';
      case 'blood':
        return 'دم';
      case 'education':
        return 'تعليم';
      case 'financial':
        return 'مالي';
      default:
        return category;
    }
  }

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'medical':
        return Icons.local_hospital_rounded;
      case 'food':
        return Icons.fastfood_rounded;
      case 'clothes':
        return Icons.checkroom_rounded;
      case 'blood':
        return Icons.bloodtype_rounded;
      case 'education':
        return Icons.school_rounded;
      case 'financial':
        return Icons.attach_money_rounded;
      default:
        return Icons.volunteer_activism_rounded;
    }
  }

  Widget _imagePlaceholder() {
    return Container(
      color: Colors.white.withOpacity(0.04),
      child: Center(
        child: Icon(
          Icons.volunteer_activism_outlined,
          size: 40.r,
          color: Colors.white24,
        ),
      ),
    );
  }
}

// ── Internal helper classes ─────────────────────────────────────────────────

class _ScoreMeta {
  final Color color;
  final String label;
  final IconData icon;
  const _ScoreMeta({
    required this.color,
    required this.label,
    required this.icon,
  });
}

class _UrgencyMeta {
  final Color color;
  final String label;
  final IconData icon;
  const _UrgencyMeta({
    required this.color,
    required this.label,
    required this.icon,
  });
}

// ── Reusable sub-widgets ────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _CategoryChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.r, color: Colors.white70),
          SizedBox(width: 5.w),
          Text(
            label,
            style: AppTextStyle.caption(
              context,
              fontSize: 11,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreChip extends StatelessWidget {
  final _ScoreMeta meta;

  const _ScoreChip({required this.meta});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: meta.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: meta.color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(meta.icon, size: 11.r, color: meta.color),
          SizedBox(width: 4.w),
          Text(
            meta.label,
            style: AppTextStyle.caption(
              context,
              fontSize: 10,
              color: meta.color,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _AmountTile extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _AmountTile({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyle.caption(
            context,
            fontSize: 10,
            color: Colors.white38,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 3.h),
        Text(
          '\$${_formatAmount(amount)}',
          style: AppTextStyle.caption(
            context,
            fontSize: 12,
            color: color,
          ).copyWith(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}k';
    }
    return amount.toStringAsFixed(0);
  }
}
