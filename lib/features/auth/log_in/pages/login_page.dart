import 'package:aoun/core/extensions/localization_extension.dart';
import 'package:aoun/core/routing/app_routes.dart';
import 'package:aoun/core/widgets/custom_textfield.dart';
import 'package:aoun/core/widgets/primary_btton.dart';
import 'package:aoun/features/auth/forgot_password/widgets/forget_password_text.dart';
import 'package:aoun/features/auth/log_in/domain/entities/login_entity.dart';
import 'package:aoun/features/auth/log_in/presentation/cubit/login_cubit.dart';
import 'package:aoun/features/auth/log_in/presentation/cubit/login_state.dart';
import 'package:aoun/features/auth/log_in/widgets/agreement_text.dart';
import 'package:aoun/features/auth/log_in/widgets/social_buttons.dart';
import 'package:aoun/features/auth/register/widgets/bottom_login_text.dart';
import 'package:aoun/features/profile/presentation/widgets/language_toggle.dart';
import 'package:aoun/features/splash/auth_background.dart';
import 'package:aoun/features/widgets/custom_card_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  final String? email;
  final String? password;

  const LoginPage({super.key, this.email, this.password});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _agreeTerms = false;

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email ?? '');
    _passwordController = TextEditingController(text: widget.password ?? '');
    if (widget.email != null && widget.password != null) {
      _agreeTerms = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final loginEntity = LoginEntity(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
          context.read<LoginCubit>().loginUser(loginEntity);
        }
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.l10n; // ✅ ضمن build

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.authResponse.message ?? 'Login Successful'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(
            context,
            rootNavigator: true,
          ).pushReplacementNamed(AppRoutes.mainhome);
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginLoading;

        return AuthBackground(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: AlignmentGeometry.topRight,
                    heightFactor: 2.7,
                    child: LanguageToggle(),
                  ),
                  CustomCardContainer(
                    child: Column(
                      children: [
                        Text(t.signIn, style: TextStyle(fontSize: 26.sp)),
                        SizedBox(height: 20.h),
                        CustomTextField(
                          controller: _emailController,
                          label: t.email,
                          hint: t.enterEmail,
                        ),
                        SizedBox(height: 16.h),
                        CustomTextField(
                          controller: _passwordController,
                          label: t.password,
                          hint: t.enterPassword,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _agreeTerms,
                              onChanged: (val) =>
                                  setState(() => _agreeTerms = val!),
                            ),
                            const Expanded(child: AgreementText()),
                          ],
                        ),
                        PrimaryButton(
                          text: t.login,
                          isLoading: isLoading,
                          onPressed: () => _onLogin(context),
                        ),
                        ForgetPasswordText(),
                        SocialButtons(),
                        BottomLoginText(
                          txt: t.dontHaveAccount,
                          txtBtn: t.signUp,
                          onPressed: () => Navigator.pushNamed(
                            context,
                            AppRoutes.register,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onLogin(BuildContext context) {
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms & conditions'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final loginEntity = LoginEntity(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      context.read<LoginCubit>().loginUser(loginEntity);
    }
  }
}
