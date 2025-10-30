import 'package:aoun/core/themes/app_colors.dart';
import 'package:aoun/features/widgets/app_constants.dart';
import 'package:flutter/material.dart';

class MainHomeNavigation extends StatefulWidget {
  const MainHomeNavigation({super.key});

  @override
  State<MainHomeNavigation> createState() => _MainHomeNavigationState();
}

class _MainHomeNavigationState extends State<MainHomeNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: AppConstants.pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4), // semi-transparent overlay
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 8,
          currentIndex: _currentIndex,
          selectedItemColor: AppColors.lightBackground,
          unselectedItemColor: Colors.grey,
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.volunteer_activism_rounded),
              label: "Donation Campaigns",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.health_and_safety_sharp),
              label: "Request Assistance",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_rounded),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
