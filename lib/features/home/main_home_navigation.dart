import 'package:aoun/core/themes/app_colors.dart';
import 'package:aoun/features/home/Donation_campain/donation_campain_page.dart';
import 'package:aoun/features/home/home_page.dart';
import 'package:flutter/material.dart';

class MainHomeNavigation extends StatefulWidget {
  const MainHomeNavigation({super.key});

  @override
  State<MainHomeNavigation> createState() => _MainHomeNavigationState();
}

class _MainHomeNavigationState extends State<MainHomeNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [HomePage(), DonationCampaignsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 5,
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.lightBackground,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism_rounded),
            label: "Donation Campaigns",
          ),
        ],
      ),
    );
  }
}
