import 'package:aoun/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_build_service_grid.dart';
import 'build_hereo_widget.dart';
import 'custom_build_tip_card.dart';

class ChatPageBody extends StatelessWidget {
  const ChatPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.welcomeBack,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            Text(
              t.howCanWeHelp,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(
        //       Icons.account_circle_outlined,
        //       color: Colors.blue,
        //       size: 30,
        //     ),
        //     onPressed: () {},
        //   ),
        //   SizedBox(width: 8.h),
        // ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeroCard(context),
            SizedBox(height: 20.h),
            Text(
              t.healthServices,
              style: TextStyle(fontSize: 18.h, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            buildServiceGrid(t),
            SizedBox(height: 12.h),
            Text(
              t.dailyHealthTip,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            buildTipCard(t),
          ],
        ),
      ),
    );
  }
}
