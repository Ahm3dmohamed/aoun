import 'package:aoun/core/extensions/localization_extension.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/core/widgets/custom_textfield.dart';
import 'package:aoun/features/auth/register/widgets/custom_dropdownfield.dart';
import 'package:aoun/features/widgets/app_constants.dart';
import 'package:aoun/l10n/app_localizations.dart';
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
          context.l10n.basicInformation,
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
            label: context.l10n.foundationName,
            hint: context.l10n.foundationName,
          ),
          SizedBox(height: 10.h),
          CustomDropdownField(
            label: context.l10n.typeOfFoundation,
            value: widget.selectedFoundationType,
            items: AppConstants.foundationTypes(context),
            hint: context.l10n.selectType,
            onChanged: widget.onFoundationTypeChanged,
          ),
          SizedBox(height: 10.h),
        ] else ...[
          CustomTextField(
            controller: widget.foundationNameController,
            label: context.l10n.fullName,
            hint: context.l10n.enterFullName,
          ),
          SizedBox(height: 10.h),
        ],

        CustomTextField(
          controller: widget.emailController,
          label: context.l10n.email,
          hint: context.l10n.email,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 10.h),

        CustomTextField(
          controller: widget.phoneController,
          label: context.l10n.phone,
          hint: context.l10n.phone,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 10.h),

        CustomTextField(
          controller: widget.passwordController,
          label: context.l10n.password,
          hint: context.l10n.password,
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
          label: context.l10n.confirmPassword,
          hint: context.l10n.confirmPassword,
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
