import 'package:aoun/core/di/injection_container.dart';
import 'package:aoun/core/extensions/localization_extension.dart';
import 'package:aoun/core/routing/app_routes.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/core/widgets/primary_btton.dart';
import 'package:aoun/features/auth/register/domain/entities/register_entity.dart';
import 'package:aoun/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:aoun/features/auth/register/presentation/cubit/register_state.dart';
import 'package:aoun/features/auth/register/widgets/basic_information_section.dart';
import 'package:aoun/features/auth/register/widgets/preferrence_section.dart';
import 'package:aoun/features/auth/register/widgets/toggle_user_type.dart';
import 'package:aoun/features/auth/register/widgets/bottom_login_text.dart';
import 'package:aoun/features/splash/auth_background.dart';
import 'package:aoun/features/widgets/custom_card_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocProvider<RegisterCubit>(
      create: (_) => sl<RegisterCubit>(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isDonor
                      ? context.l10n.donorAccountSuccess
                      : context.l10n.foundationAccountSuccess,
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(
              context,
              rootNavigator: true,
            ).pushReplacementNamed(AppRoutes.mainhome);
          } else if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is RegisterLoading;

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
                            context.l10n.signUp,
                            style: AppTextStyle.heading(
                              context,
                              fontSize: 24.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            context.l10n.joinUs,
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
                            confirmPasswordController:
                                _confirmPasswordController,
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
                            text: context.l10n.createAccount,
                            isLoading: isLoading,
                            onPressed: () => _onRegister(context),
                          ),
                          SizedBox(height: 13.h),

                          BottomLoginText(
                            txt: context.l10n.alreadyHaveAccount,
                            txtBtn: context.l10n.signIn,
                            onPressed: () =>
                                Navigator.pushNamed(context, AppRoutes.login),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _onRegister(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final registerEntity = RegisterEntity(
        name: _foundationNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        role: _isDonor ? 'donor' : 'foundation_admin',
        phone: _phoneController.text.trim(),
        foundationType: _isDonor ? null : _selectedFoundationType,
        donationType: _selectedDonationType,
        location: _selectedLocation,
      );

      context.read<RegisterCubit>().registerUser(registerEntity);
    }
  }
}
