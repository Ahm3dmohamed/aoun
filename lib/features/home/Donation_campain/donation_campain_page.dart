import 'package:aoun/app_constants.dart';
import 'package:aoun/features/home/Donation_campain/widgets/donation_card.dart';
import 'package:aoun/features/splash/splash_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DonationCampaignsPage extends StatelessWidget {
  const DonationCampaignsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashBackground(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        child: ListView.builder(
          itemCount: AppConstants.campaigns.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final campaign = AppConstants.campaigns[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: DonationCard(
                image: campaign["image"],
                title: campaign["title"],
                remaining: campaign["remaining"],
                donated: campaign["donated"],
              ),
            );
          },
        ),
      ),
    );
  }
}
