import 'package:aoun/core/routing/app_routes.dart';
import 'package:aoun/core/themes/app_colors.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/core/widgets/custom_textfield.dart';
import 'package:aoun/core/widgets/primary_btton.dart';
import 'package:aoun/features/auth/register/widgets/custom_dropdownfield.dart';
import 'package:aoun/features/splash/auth_background.dart';
import 'package:aoun/features/widgets/app_constants.dart';
import 'package:aoun/features/widgets/custom_card_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _donationController = TextEditingController();
  final _locationController = TextEditingController();

  bool _isDonor = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: CustomCardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Sign Up',
                  style: AppTextStyle.heading(
                    context,
                    fontSize: 24,
                    color: const Color(0xFFF6F6F6),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Join Us\nCreate your account now',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.body(
                    context,
                    color: Colors.grey[200]!,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 15.h),

                Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isDonor = true),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _isDonor
                                  ? AppColors.lightPrimary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Donor',
                              style: AppTextStyle.body(
                                context,
                                color: _isDonor
                                    ? Colors.white
                                    : AppColors.lightPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isDonor = false),
                          child: Container(
                            decoration: BoxDecoration(
                              color: !_isDonor
                                  ? AppColors.lightPrimary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Foundation',
                              style: AppTextStyle.body(
                                context,
                                color: !_isDonor
                                    ? Colors.white
                                    : AppColors.lightPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 15.h),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Basic Information:',
                    style: AppTextStyle.body(
                      context,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 8.h),

                CustomTextField(
                  controller: _fullNameController,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                ),
                SizedBox(height: 10.h),

                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email address',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 10.h),

                CustomTextField(
                  controller: _phoneController,
                  label: 'Phone',
                  hint: 'Enter your phone number',
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 10.h),

                CustomTextField(
                  controller: _passwordController,
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
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                SizedBox(height: 10.h),

                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  hint: 'Re-enter your password',
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: Colors.grey[300],
                    ),
                    onPressed: () {
                      setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      );
                    },
                  ),
                ),

                SizedBox(height: 15.h),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Preferences:',
                    style: AppTextStyle.body(
                      context,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),

                CustomDropdownField(
                  value: AppConstants.selectedDonation,
                  items: AppConstants.donationOptions,
                  hint: 'Preferred Donation',
                  onChanged: (value) =>
                      setState(() => AppConstants.selectedDonation = value!),
                ),
                SizedBox(height: 10.h),

                CustomDropdownField(
                  value: AppConstants.selectedLocation,
                  items: AppConstants.locations,
                  hint: 'Location',
                  onChanged: (value) =>
                      setState(() => AppConstants.selectedLocation = value!),
                ),

                SizedBox(height: 9.h),

                SizedBox(height: 15.h),

                PrimaryButton(text: 'Register', onPressed: _onRegister),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: AppTextStyle.body(
                        context,
                        color: Colors.grey[200]!,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.login),
                      child: Text(
                        'Log in',
                        style: AppTextStyle.custom(
                          context,
                          color: const Color(0xFFF6F6F6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onRegister() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${_isDonor ? "Donor" : "Foundation"} account registered successfully!',
          ),
        ),
      );
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    }
  }
}
