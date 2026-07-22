import 'package:aoun/core/extensions/localization_extension.dart';
import 'package:aoun/core/routing/app_routes.dart';
import 'package:aoun/core/utils/app_images.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/core/widgets/custom_textfield.dart';
import 'package:aoun/core/widgets/primary_btton.dart';
import 'package:aoun/features/auth/forgot_password/presentation/cubit/forgot_password_cubit.dart';
import 'package:aoun/features/auth/forgot_password/presentation/cubit/forgot_password_state.dart';
import 'package:aoun/features/splash/auth_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _tokenController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure1 = true;
  bool _obscure2 = true;

  // The email is passed as a route argument from ForgotPasswordPage.
  String _email = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.isNotEmpty) {
      _email = args;
    }
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<ForgotPasswordCubit>().resetPassword(
        token: _tokenController.text.trim(),
        email: _email,
        password: _newPasswordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;

    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loc.passwordResetSuccess),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green.shade700,
            ),
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
            arguments: {
              'email': _email,
              'password': _newPasswordController.text,
            },
          );
        } else if (state is ResetPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      },
      child: AuthBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
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
                    SizedBox(height: 8.h),

                    // Hint text to guide the user
                    Text(
                      loc.enterTokenFromEmail,
                      style: AppTextStyle.heading(context, fontSize: 13)
                          .copyWith(
                            fontWeight: FontWeight.normal,
                            color: Colors.white70,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),

                    // Reset token field
                    CustomTextField(
                      controller: _tokenController,
                      label: loc.resetToken,
                      hint: loc.resetToken,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return loc.pleaseEnterToken;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    // New password
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
                    SizedBox(height: 16.h),

                    // Confirm password
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

                    BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                      builder: (context, state) {
                        final isLoading = state is ResetPasswordLoading;
                        return PrimaryButton(
                          text: loc.save,
                          isLoading: isLoading,
                          onPressed: () => _onSubmit(context),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
