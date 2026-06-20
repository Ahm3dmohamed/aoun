import 'package:aoun/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:aoun/features/chat/presentation/pages/chat_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildHeroCard(BuildContext context) {
  final t = AppLocalizations.of(context)!;

  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(20.h),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue[700]!, Colors.blue[400]!],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.blue.withOpacity(0.3),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.auto_awesome, color: Colors.white, size: 30),
        SizedBox(height: 7.h),
        Text(
          t.aiSymptomChecker,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          t.describeFeel,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        SizedBox(height: 16.h),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatPage()),
            );
          },
          child: Text(
            t.startFreeConsultation,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
