import 'package:aoun/features/home/home_page.dart';
import 'package:aoun/features/recommendations/presentation/recommended_donations_page.dart';
import 'package:aoun/features/profile/presentation/pages/profile_page.dart';
import 'package:aoun/l10n/app_localizations.dart';
import 'package:aoun/features/maps/presentation/pages/nearby_map_page.dart';
import 'package:aoun/features/maps/presentation/cubit/maps_cubit.dart';
import 'package:aoun/core/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../request_assistance/pages/request_assistance.dart';

class AppConstants {
  /// Pages do NOT need localization
  static List<Widget> pages = [
    const HomePage(),
    const RecommendedDonationsPage(),
    BlocProvider<MapsCubit>(
      create: (context) => sl<MapsCubit>(),
      child: const NearbyMapPage(),
    ),
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

  /// 🔵 Localized Donation Options — key is API value, value is display label
  static Map<String, String> donationOptionsMap(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return {
      'Blood': loc.donationBlood,
      'Clothes': loc.donationClothes,
      'Food': loc.donationFood,
      'Money': loc.donationMoney,
      'Books': loc.donationBooks,
      'Medical Supplies': loc.donationMedicalSupplies,
    };
  }

  /// 🔵 Localized Donation Options (display list only, for backward compatibility)
  static List<String> donationOptions(BuildContext context) =>
      donationOptionsMap(context).keys.toList();

  /// 🔵 Localized Foundation Types — key is API value, value is display label
  static Map<String, String> foundationTypesMap(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return {
      'charity': loc.foundationCharity,
      'religious': loc.foundationReligious,
      'medical': loc.foundationHealth,
      'educational': loc.foundationEducational,
    };
  }

  /// 🔵 Localized Foundation Types (display list only, for backward compatibility)
  static List<String> foundationTypes(BuildContext context) =>
      foundationTypesMap(context).keys.toList();

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
