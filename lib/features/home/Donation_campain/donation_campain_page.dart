import 'package:flutter/material.dart';

class DonationCampaignsPage extends StatelessWidget {
  const DonationCampaignsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Donation Campaigns Coming Soon",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
