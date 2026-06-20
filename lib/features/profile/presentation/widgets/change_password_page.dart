// import 'package:aoun/core/extensions/localization_extension.dart';
// import 'package:aoun/core/widgets/custom_textfield.dart';
// import 'package:aoun/core/widgets/primary_btton.dart';
// import 'package:aoun/features/splash/splash_background.dart';
// import 'package:aoun/features/widgets/custom_card_container.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class ChangePasswordPage extends StatefulWidget {
//   const ChangePasswordPage({super.key});

//   @override
//   State<ChangePasswordPage> createState() => _ChangePasswordPageState();
// }

// class _ChangePasswordPageState extends State<ChangePasswordPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _currentPasswordController = TextEditingController();
//   final _newPasswordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   bool _obscureCurrent = true;
//   bool _obscureNew = true;
//   bool _obscureConfirm = true;

//   @override
//   void dispose() {
//     _currentPasswordController.dispose();
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final t = context.l10n;

//     return Scaffold(
//       body: SplashBackground(
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Align(
//                   alignment: AlignmentDirectional.centerStart,
//                   child: IconButton(
//                     icon: const Icon(
//                       Icons.arrow_back_ios_new,
//                       color: Colors.white,
//                     ),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//                 Text(
//                   t.changePassword,
//                   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 30.h),
//                 CustomCardContainer(
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         CustomTextField(
//                           controller: _currentPasswordController,
//                           label: "Current Password", // Ideally localized
//                           hint: t.enterPassword,
//                           obscureText: _obscureCurrent,
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _obscureCurrent
//                                   ? Icons.visibility_off
//                                   : Icons.visibility,
//                             ),
//                             onPressed: () => setState(
//                               () => _obscureCurrent = !_obscureCurrent,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 16.h),
//                         CustomTextField(
//                           controller: _newPasswordController,
//                           label: "New Password", // Ideally localized
//                           hint: t.enterPassword,
//                           obscureText: _obscureNew,
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _obscureNew
//                                   ? Icons.visibility_off
//                                   : Icons.visibility,
//                             ),
//                             onPressed: () =>
//                                 setState(() => _obscureNew = !_obscureNew),
//                           ),
//                         ),
//                         SizedBox(height: 16.h),
//                         CustomTextField(
//                           controller: _confirmPasswordController,
//                           label: t.confirmPassword,
//                           hint: t.reenterPassword,
//                           obscureText: _obscureConfirm,
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _obscureConfirm
//                                   ? Icons.visibility_off
//                                   : Icons.visibility,
//                             ),
//                             onPressed: () => setState(
//                               () => _obscureConfirm = !_obscureConfirm,
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value != _newPasswordController.text) {
//                               return t.passwordsDoNotMatch;
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: 30.h),
//                         PrimaryButton(
//                           text: t.save,
//                           onPressed: () {
//                             if (_formKey.currentState!.validate()) {
//                               // Change password logic here
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(
//                                     "Password changed successfully",
//                                   ),
//                                   backgroundColor: Colors.green,
//                                 ),
//                               );
//                               Navigator.pop(context);
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
