import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/core/widgets/custom_textfield.dart';
import 'package:aoun/features/auth/register/widgets/custom_dropdownfield.dart';
import 'package:aoun/features/widgets/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BasicInformationSection extends StatefulWidget {
  final bool isDonor;
  final TextEditingController foundationNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final String? selectedFoundationType;
  final ValueChanged<String?> onFoundationTypeChanged;

  const BasicInformationSection({
    super.key,
    required this.isDonor,
    required this.foundationNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.selectedFoundationType,
    required this.onFoundationTypeChanged,
  });

  @override
  State<BasicInformationSection> createState() =>
      _BasicInformationSectionState();
}

class _BasicInformationSectionState extends State<BasicInformationSection> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information:',
          style: AppTextStyle.body(
            context,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15.sp,
          ),
        ),
        SizedBox(height: 10.h),

        if (!widget.isDonor) ...[
          CustomTextField(
            controller: widget.foundationNameController,
            label: 'Foundation Name',
            hint: 'Enter foundation name',
          ),
          SizedBox(height: 10.h),
          CustomDropdownField(
            label: "Type of Foundation",
            value: widget.selectedFoundationType,
            items: AppConstants.foundationTypes,
            hint: 'Select type',
            onChanged: widget.onFoundationTypeChanged,
          ),
          SizedBox(height: 10.h),
        ] else ...[
          CustomTextField(
            controller: widget.foundationNameController,
            label: 'Full Name',
            hint: 'Enter your full name',
          ),
          SizedBox(height: 10.h),
        ],

        CustomTextField(
          controller: widget.emailController,
          label: 'Email',
          hint: 'Enter your email address',
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 10.h),

        CustomTextField(
          controller: widget.phoneController,
          label: 'Phone',
          hint: 'Enter your phone number',
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 10.h),

        CustomTextField(
          controller: widget.passwordController,
          label: 'Password',
          hint: 'Enter your password',
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              color: Colors.grey[300],
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        SizedBox(height: 10.h),

        CustomTextField(
          controller: widget.confirmPasswordController,
          label: 'Confirm Password',
          hint: 'Re-enter your password',
          obscureText: _obscureConfirm,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirm
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              color: Colors.grey[300],
            ),
            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
        ),
      ],
    );
  }
}
