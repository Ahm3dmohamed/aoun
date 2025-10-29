import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/features/auth/register/widgets/custom_dropdownfield.dart';
import 'package:aoun/features/widgets/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreferencesSection extends StatelessWidget {
  final String? selectedDonationType;
  final String? selectedLocation;
  final ValueChanged<String?> onDonationChanged;
  final ValueChanged<String?> onLocationChanged;

  const PreferencesSection({
    super.key,
    required this.selectedDonationType,
    required this.selectedLocation,
    required this.onDonationChanged,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferences:',
          style: AppTextStyle.body(
            context,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15.sp,
          ),
        ),
        SizedBox(height: 10.h),
        CustomDropdownField(
          label: "Required Donation",
          value: selectedDonationType,
          items: AppConstants.donationOptions,
          hint: 'Select required donation',
          onChanged: onDonationChanged,
        ),
        SizedBox(height: 10.h),
        CustomDropdownField(
          label: "Location",
          value: selectedLocation,
          items: AppConstants.locations,
          hint: 'Select your location',
          onChanged: onLocationChanged,
        ),
      ],
    );
  }
}
