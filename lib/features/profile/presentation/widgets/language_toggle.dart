import 'package:aoun/features/profile/cubit/localization_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      width: 140.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 70.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white24,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          // Clickable Labels
          Row(
            children: [
              _buildLanguageButton(
                context,
                "English",
                !isArabic,
                const Locale('en'),
              ),
              _buildLanguageButton(
                context,
                "العربية",
                isArabic,
                const Locale('ar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(
    BuildContext context,
    String label,
    bool isActive,
    Locale locale,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<LocalizationCubit>().changeLanguage(locale);
        },
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: TextStyle(
              color: isActive ? Colors.blue[900] : Colors.black87,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 15.sp,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
