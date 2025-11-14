import 'package:aoun/core/extensions/localization_extension.dart';
import 'package:aoun/core/utils/app_images.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/core/widgets/custom_textfield.dart';
import 'package:aoun/core/widgets/primary_btton.dart';
import 'package:aoun/features/splash/auth_background.dart';
import 'package:aoun/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routing/app_routes.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppImages.splashLogo, height: 80.h),
                  SizedBox(height: 20.h),

                  Text(
                    AppLocalizations.of(context)!.resetYourPassword,
                    style: AppTextStyle.heading(context, fontSize: 22),
                  ),
                  SizedBox(height: 20.h),

                  CustomTextField(
                    controller: _emailController,
                    label: context.l10n.enterYourEmail,
                    hint: context.l10n.emailHint,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.pleaseEnterEmail;
                      }
                      if (!value.contains('@')) {
                        return context.l10n.enterValidEmail;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),

                  PrimaryButton(
                    text: context.l10n.send,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.l10n.resetLinkSent),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        Navigator.pushNamed(context, AppRoutes.resetPassword);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
