import 'package:aoun/features/Donation_campain/donation_campain_page.dart';
import 'package:aoun/features/home/home_page.dart';
import 'package:aoun/features/profile/pages/profile_page.dart';
import 'package:aoun/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../request_assistance/pages/request_assistance.dart';

class AppConstants {
  /// Pages do NOT need localization
  static List<Widget> pages = [
    const HomePage(),
    const DonationCampaignsPage(),
    const RequestAssistancePage(),
    ProfilePage(),
  ];

  /// 🔵 Localized campaigns titles
  static List<Map<String, dynamic>> campaigns(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return [
      {
        "image": "assets/img/room_bed.png",
        "title": loc.campaignMedicalSupplies,
        "remaining": 250000,
        "donated": 200000,
      },
      {
        "image": "assets/img/atmida.png",
        "title": loc.campaignMedicalSupplies,
        "remaining": 250000,
        "donated": 200000,
      },
      {
        "image": "assets/img/bed.png",
        "title": loc.campaignMedicalSupplies,
        "remaining": 250000,
        "donated": 200000,
      },
      {
        "image": "assets/img/equipment.png",
        "title": loc.campaignMedicalSupplies,
        "remaining": 250000,
        "donated": 200000,
      },
    ];
  }

  /// 🔵 Localized Donation Options
  static List<String> donationOptions(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return [
      loc.donationClothes,
      loc.donationFood,
      loc.donationMoney,
      loc.donationBooks,
      loc.donationMedicalSupplies,
    ];
  }

  /// 🔵 Localized Foundation Types
  static List<String> foundationTypes(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return [
      loc.foundationCharity,
      loc.foundationReligious,
      loc.foundationHealth,
      loc.foundationEducational,
      loc.foundationEnvironmental,
    ];
  }

  /// 🔵 Localized Locations
  static List<String> locations(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return [
      loc.locationCairo,
      loc.locationAlexandria,
      loc.locationGiza,
      loc.locationLuxor,
      loc.locationAswan,
    ];
  }
}
