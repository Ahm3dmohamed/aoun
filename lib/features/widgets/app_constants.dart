import 'package:aoun/features/Donation_campain/donation_campain_page.dart';
import 'package:aoun/features/home/home_page.dart';
import 'package:aoun/features/profile/pages/profile_page.dart';
import 'package:flutter/material.dart';

import '../request_assistance/pages/request_assistance.dart';

class AppConstants {
  static List<Widget> pages = [
    const HomePage(),
    const DonationCampaignsPage(),
    const RequestAssistancePage(),
    ProfilePage(),
  ];
  static List<Map<String, dynamic>> campaigns = [
    {
      "image": "assets/img/room_bed.png",
      "title": "Providing medical equipment and supplies",
      "remaining": 250000,
      "donated": 200000,
    },
    {
      "image": "assets/img/atmida.png",
      "title": "Providing medical equipment and supplies",
      "remaining": 250000,
      "donated": 200000,
    },
    {
      "image": "assets/img/bed.png",
      "title": "Providing medical equipment and supplies",
      "remaining": 250000,
      "donated": 200000,
    },
    {
      "image": "assets/img/equipment.png",
      "title": "Providing medical equipment and supplies",
      "remaining": 250000,
      "donated": 200000,
    },
  ];

  static List<String> donationOptions = [
    'Clothes',
    'Food',
    'Money',
    'Books',
    'Medical Supplies',
  ];
  static List<String> foundationTypes = [
    'Charity',
    'Religious',
    'Health',
    'Educational',
    'Environmental',
  ];

  static List<String> locations = [
    'Cairo',
    'Alexandria',
    'Giza',
    'Luxor',
    'Aswan',
  ];
  static String? selectedDonation;
  static String? selectedLocation;
}
