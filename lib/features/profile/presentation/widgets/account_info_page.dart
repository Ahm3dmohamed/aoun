import 'package:aoun/core/di/injection_container.dart';
import 'package:aoun/core/storage/auth_local_data_source.dart';
import 'package:aoun/core/extensions/localization_extension.dart';
import 'package:aoun/core/widgets/custom_textfield.dart';
import 'package:aoun/core/widgets/primary_btton.dart';
import 'package:aoun/features/splash/splash_background.dart';
import 'package:aoun/features/widgets/custom_card_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountInfoPage extends StatefulWidget {
  const AccountInfoPage({super.key});

  @override
  State<AccountInfoPage> createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final localDataSource = sl<AuthLocalDataSource>();
    final userData = await localDataSource.getUserData();
    if (userData != null) {
      setState(() {
        _nameController.text = userData['name']?.toString() ?? '';
        _emailController.text = userData['email']?.toString() ?? '';
        _phoneController.text = userData['phone']?.toString() ?? '';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;

    return Scaffold(
      body: SplashBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  t.accountInformation,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30.h),
                CustomCardContainer(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              t.basicInformation,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                _isEditing ? Icons.close : Icons.edit,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_isEditing) {
                                    // Optionally reset changes here
                                  }
                                  _isEditing = !_isEditing;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        CustomTextField(
                          controller: _nameController,
                          label: t.fullName,
                          hint: t.enterFullName,
                          enabled: _isEditing,
                        ),
                        SizedBox(height: 16.h),
                        CustomTextField(
                          controller: _emailController,
                          label: t.email,
                          hint: t.enterEmail,
                          enabled: _isEditing,
                        ),
                        SizedBox(height: 16.h),
                        CustomTextField(
                          controller: _phoneController,
                          label: t.phone,
                          hint: t.enterPhone,
                          enabled: _isEditing,
                        ),
                        SizedBox(height: 30.h),
                        if (_isEditing)
                          PrimaryButton(
                            text: t.save,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final localDataSource = sl<AuthLocalDataSource>();
                                final currentData = await localDataSource.getUserData() ?? {};
                                currentData['name'] = _nameController.text.trim();
                                currentData['email'] = _emailController.text.trim();
                                currentData['phone'] = _phoneController.text.trim();
                                await localDataSource.saveUserData(currentData);
                                if (!context.mounted) return;
                                setState(() {
                                  _isEditing = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Profile updated successfully",
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
