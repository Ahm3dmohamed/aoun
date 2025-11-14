import 'package:aoun/core/extensions/localization_extension.dart';
import 'package:aoun/core/utils/app_images.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/core/widgets/custom_textfield.dart';
import 'package:aoun/core/widgets/primary_btton.dart';
import 'package:aoun/features/splash/auth_background.dart';
import 'package:aoun/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;

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
                    loc.resetYourPassword,
                    style: AppTextStyle.heading(context, fontSize: 22),
                  ),
                  SizedBox(height: 20.h),

                  CustomTextField(
                    controller: _newPasswordController,
                    label: loc.reEnterPassword,
                    hint: loc.reEnterPassword,
                    obscureText: _obscure1,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure1
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                      ),
                      onPressed: () => setState(() => _obscure1 = !_obscure1),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return loc.reEnterPassword;
                      }
                      if (value.length < 6) {
                        return loc.passwordsDoNotMatch;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),

                  CustomTextField(
                    controller: _confirmPasswordController,
                    label: loc.confirmPassword,
                    hint: loc.reEnterPassword,
                    obscureText: _obscure2,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure2
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                      ),
                      onPressed: () => setState(() => _obscure2 = !_obscure2),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return loc.pleaseConfirmPassword;
                      }
                      if (value != _newPasswordController.text) {
                        return loc.passwordsDoNotMatch;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),

                  PrimaryButton(
                    text: loc.save,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(loc.passwordResetSuccess)),
                        );
                        Navigator.pop(context);
                        Navigator.pop(context);
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
