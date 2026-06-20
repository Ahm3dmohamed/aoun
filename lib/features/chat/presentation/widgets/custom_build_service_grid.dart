import 'package:aoun/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildServiceGrid(AppLocalizations t) {
  final services = [
    {"name": t.doctor, "icon": Icons.person_search, "color": Colors.orange},
    {"name": t.medicine, "icon": Icons.medication, "color": Colors.green},
    {"name": t.reports, "icon": Icons.assignment, "color": Colors.purple},
    {"name": t.emergency, "icon": Icons.emergency, "color": Colors.red},
  ];

  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
    ),
    itemCount: services.length,
    itemBuilder: (context, index) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              services[index]['icon'] as IconData,
              color: services[index]['color'] as Color,
              size: 32,
            ),
            SizedBox(height: 8.h),
            Text(
              services[index]['name'] as String,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    },
  );
}
