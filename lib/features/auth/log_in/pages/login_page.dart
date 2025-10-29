import 'package:aoun/core/routing/app_routes.dart';
import 'package:aoun/core/themes/app_colors.dart';
import 'package:aoun/core/utils/app_images.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/core/widgets/custom_textfield.dart';
import 'package:aoun/core/widgets/primary_btton.dart';
import 'package:aoun/features/auth/log_in/widgets/agreement_text.dart';
import 'package:aoun/features/auth/forgot_password/widgets/forget_password_text.dart';
import 'package:aoun/features/auth/log_in/widgets/social_buttons.dart';
import 'package:aoun/features/splash/auth_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../widgets/custom_card_container.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _agreeTerms = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
                // Header
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      '       Sign in',
                      style: AppTextStyle.heading(
                        context,
                        fontSize: 26,
                        color: const Color(0xFFF6F6F6),
                      ),
                    ),
                    const Spacer(),
                    Image.asset(AppImages.splashLogo, height: 80.h),
                  ],
                ),

                Text('Welcome Back', style: AppTextStyle.heading(context)),
                Text(
                  'Continue your journey with Aoun.',
                  style: AppTextStyle.body(
                    context,
                    color: Colors.grey[200]!,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 9.h),

                // Email Field
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email address',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20.h),

                // Password Field
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

                SizedBox(height: 9.h),

                Row(
                  children: [
                    Checkbox(
                      value: _agreeTerms,
                      onChanged: (val) =>
                          setState(() => _agreeTerms = val ?? false),
                      checkColor: Colors.white,
                      activeColor: Colors.black,
                    ),
                    Expanded(child: AgreementText()),
                  ],
                ),

                SizedBox(height: 9.h),

                PrimaryButton(
                  text: 'Login',
                  onPressed: () {
                    _goToHome(context);
                  },
                ),
                ForgetPasswordText(),

                Row(
                  children: const [
                    Expanded(child: Divider(color: Colors.white54)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.white54)),
                  ],
                ),

                SizedBox(height: 15.h),

                SocialButtons(),

                SizedBox(height: 15.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: AppTextStyle.body(
                        context,
                        color: Colors.grey[200]!,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.register),
                      child: Text(
                        'Sign Up',
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

  void _goToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }
}
