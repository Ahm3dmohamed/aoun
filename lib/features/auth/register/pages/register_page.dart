import 'package:aoun/core/routing/app_routes.dart';
import 'package:aoun/core/utils/app_images.dart';
import 'package:aoun/core/widgets/custom_textfield.dart';
import 'package:aoun/core/widgets/primary_btton.dart';
import 'package:aoun/features/auth/log_in/widgets/agreement_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeTerms = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.asset(AppImages.splashLogo, height: 160.h)),
                SizedBox(height: 20.h),

                Text(
                  'Create Account 🕊️',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFF6F6F6),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Join Aoun and start making a difference today!',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[200]),
                ),
                SizedBox(height: 30.h),

                CustomTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  keyboardType: TextInputType.name,
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter your name';
                  //   }
                  //   return null;
                  // },
                ),
                SizedBox(height: 16.h),

                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email address',
                  keyboardType: TextInputType.emailAddress,
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter your email';
                  //   }
                  //   if (!value.contains('@')) {
                  //     return 'Enter a valid email address';
                  //   }
                  //   return null;
                  // },
                ),
                SizedBox(height: 16.h),

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
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter your password';
                  //   }
                  //   if (value.length < 6) {
                  //     return 'Password must be at least 6 characters long';
                  //   }
                  //   return null;
                  // },
                ),
                SizedBox(height: 16.h),

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
                    ),
                    onPressed: () => setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword,
                    ),
                  ),
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please confirm your password';
                  //   }
                  //   if (value != _passwordController.text) {
                  //     return 'Passwords do not match';
                  //   }
                  //   return null;
                  // },
                ),

                SizedBox(height: 15.h),

                Row(
                  children: [
                    Checkbox(
                      value: _agreeTerms,
                      onChanged: (val) {},
                      // setState(() => _agreeTerms = val ?? false),
                    ),
                    Expanded(
                      child: AgreementText(),
                      // Text.rich(
                      //   TextSpan(
                      //     text: 'I agree to the ',
                      //     style: Theme.of(context).textTheme.bodyMedium,
                      //     children: [
                      //       TextSpan(
                      //         text: 'Terms & Conditions',
                      //         style: TextStyle(
                      //           color: Theme.of(context).primaryColor,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ),
                  ],
                ),

                SizedBox(height: 25.h),

                PrimaryButton(
                  text: 'Create Account',
                  onPressed: () {
                    // if (_formKey.currentState!.validate()) {
                    //   if (!_agreeTerms) {
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       const SnackBar(
                    //         content: Text('You must agree to the terms first.'),
                    //       ),
                    //     );
                    //     return;
                    //   }

                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text('Account created successfully!'),
                    //     ),
                    //   );
                    //   _goToHome(context);
                    //   // Navigate to home or login
                    //   // Navigator.pushReplacementNamed(context, AppRouter.login);
                    // }
                    _goToHome(context);
                  },
                ),

                SizedBox(height: 25.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
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
