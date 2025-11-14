import 'package:aoun/core/extensions/localization_extension.dart';
import 'package:aoun/core/routing/app_routes.dart';
import 'package:aoun/core/themes/app_colors.dart';
import 'package:aoun/core/utils/app_images.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/core/widgets/custom_textfield.dart';
import 'package:aoun/core/widgets/primary_btton.dart';
import 'package:aoun/features/auth/log_in/widgets/agreement_text.dart';
import 'package:aoun/features/auth/forgot_password/widgets/forget_password_text.dart';
import 'package:aoun/features/auth/log_in/widgets/social_buttons.dart';
import 'package:aoun/features/auth/register/widgets/bottom_login_text.dart';
import 'package:aoun/features/splash/auth_background.dart';
import 'package:aoun/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      context.l10n.signIn,
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

                Text(
                  context.l10n.welcomeBack,
                  style: AppTextStyle.heading(context),
                ),
                Text(
                  context.l10n.continueJourney,
                  style: AppTextStyle.body(
                    context,
                    color: Colors.grey[200]!,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 18.h),

                // Email Field
                CustomTextField(
                  controller: _emailController,
                  label: context.l10n.email,
                  hint: context.l10n.enterEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20.h),

                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  label: context.l10n.password,
                  hint: context.l10n.enterPassword,
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
                  text: context.l10n.login,
                  onPressed: () {
                    _goToHome(context);
                  },
                ),
                ForgetPasswordText(),

                Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.white54)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        context.l10n.orContinueWith,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                    const Expanded(child: Divider(color: Colors.white54)),
                  ],
                ),

                SizedBox(height: 20.h),

                SocialButtons(),

                SizedBox(height: 15.h),

                BottomLoginText(
                  txt: context.l10n.dontHaveAccount,
                  txtBtn: context.l10n.signUp,
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.register),
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
