import 'package:aoun/core/routing/app_routes.dart';
import 'package:aoun/core/themes/app_colors.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/core/widgets/primary_btton.dart';
import 'package:aoun/features/auth/register/widgets/basic_information_section.dart';
import 'package:aoun/features/auth/register/widgets/preferrence_section.dart';
import 'package:aoun/features/auth/register/widgets/toggle_user_type.dart';
import 'package:aoun/features/auth/register/widgets/bottom_login_text.dart';
import 'package:aoun/features/splash/auth_background.dart';
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
  bool _isDonor = false;

  // form controllers
  final _foundationNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // dropdown selections
  String? _selectedFoundationType;
  String? _selectedDonationType;
  String? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          final padding = EdgeInsets.symmetric(
            horizontal: isWide ? constraints.maxWidth * 0.2 : 1.w,
            vertical: 24.h,
          );

          return SingleChildScrollView(
            padding: padding,
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
                        fontSize: 24.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Join Us\nCreate your account now',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.body(
                        context,
                        color: Colors.grey[200]!,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    ToggleUserType(
                      isDonor: _isDonor,
                      onChanged: (val) => setState(() => _isDonor = val),
                    ),

                    SizedBox(height: 18.h),

                    BasicInformationSection(
                      isDonor: _isDonor,
                      foundationNameController: _foundationNameController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      selectedFoundationType: _selectedFoundationType,
                      onFoundationTypeChanged: (val) =>
                          setState(() => _selectedFoundationType = val),
                    ),

                    SizedBox(height: 18.h),

                    PreferencesSection(
                      selectedDonationType: _selectedDonationType,
                      selectedLocation: _selectedLocation,
                      onDonationChanged: (val) =>
                          setState(() => _selectedDonationType = val),
                      onLocationChanged: (val) =>
                          setState(() => _selectedLocation = val),
                    ),

                    SizedBox(height: 18.h),

                    PrimaryButton(
                      text: 'Create Account',
                      onPressed: _onRegister,
                    ),
                    SizedBox(height: 13.h),

                    const BottomLoginText(
                      txt: "Already have an account?",
                      txtBtn: 'Sign In',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
