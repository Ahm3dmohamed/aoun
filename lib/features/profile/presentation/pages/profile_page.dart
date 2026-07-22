import 'dart:io';
import 'package:aoun/core/di/injection_container.dart';
import 'package:aoun/core/extensions/localization_extension.dart';
import 'package:aoun/core/routing/app_routes.dart';
import 'package:aoun/features/auth/log_in/presentation/cubit/logout_cubit.dart';
import 'package:aoun/features/auth/log_in/presentation/cubit/logout_state.dart';
import 'package:aoun/features/profile/presentation/widgets/account_info_page.dart';
import 'package:aoun/features/profile/presentation/widgets/build_section_title.dart';
import 'package:aoun/features/profile/presentation/widgets/language_toggle.dart';
import 'package:aoun/features/change_password/presentation/pages/change_password_page.dart';
import 'package:aoun/features/about_us/presentation/pages/about_us_page.dart';
import 'package:aoun/features/contact_us/presentation/pages/contact_us_page.dart';
import 'package:aoun/features/profile/presentation/widgets/pick_image_option_sheet.dart';
import 'package:aoun/features/splash/splash_background.dart';
import 'package:aoun/features/profile/presentation/widgets/profile_option_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? selectedFile;
  String? uploadedFileName;

  Future<void> _pickFile({bool fromCamera = false}) async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile;

    pickedFile = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality:
          50, // Resizes and compresses image to avoid heavy UI thread load
      maxWidth: 800,
      maxHeight: 800,
    );

    if (pickedFile != null) {
      setState(() {
        uploadedFileName = pickedFile!.name;
        selectedFile = File(pickedFile.path);
      });
    }
  }

  void _showPickOptionsDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return PickImageOptionsSheet(
          onCameraTap: () => _pickFile(fromCamera: true),
          onGalleryTap: () => _pickFile(fromCamera: false),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LogoutCubit>(
      create: (_) => sl<LogoutCubit>(),
      child: BlocListener<LogoutCubit, LogoutState>(
        listener: (context, state) {
          if (state is LogoutLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    ),
                    SizedBox(width: 15),
                    Text('Logging out...'),
                  ],
                ),
                duration: Duration(seconds: 10),
              ),
            );
          } else if (state is LogoutSuccess) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Logged out successfully'),
                backgroundColor: Colors.green,
              ),
            );
            _returnToLogin(context);
          } else if (state is LogoutFailure) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
            // Even if logout fails, clean state requires redirection since token is deleted
            _returnToLogin(context);
          }
        },
        child: Builder(
          builder: (profilePageContext) {
            return SplashBackground(
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildProfileHeader(profilePageContext),
                      SizedBox(height: 30.h),

                      BuildSectionTitle("General Settings"),
                      ProfileOptionTile(
                        icon: Icons.language,
                        title: "Language",
                        trailing: const LanguageToggle(),
                        onTap: () {},
                      ),
                      ProfileOptionTile(
                        icon: Icons.person_outline,
                        title: profilePageContext.l10n.accountInformation,
                        onTap: () {
                          Navigator.push(
                            profilePageContext,
                            MaterialPageRoute(builder: (_) => const AccountInfoPage()),
                          );
                        },
                      ),
                      ProfileOptionTile(
                        icon: Icons.lock_outline,
                        title: profilePageContext.l10n.changePassword,
                        onTap: () {
                          Navigator.push(
                            profilePageContext,
                            MaterialPageRoute(
                              builder: (_) => const ChangePasswordPage(),
                            ),
                          );
                        },
                      ),

                      ProfileOptionTile(
                        icon: Icons.chat_bubble_outline,
                        title: "ChatBot",
                        onTap: () {
                          Navigator.pushNamed(
                            profilePageContext,
                            AppRoutes.chatbot,
                          );
                        },
                      ),
                      ProfileOptionTile(
                        icon: Icons.headset_mic_outlined,
                        title: profilePageContext.l10n.contactUs,
                        onTap: () {
                          Navigator.push(
                            profilePageContext,
                            MaterialPageRoute(builder: (_) => const ContactUsPage()),
                          );
                        },
                      ),
                      ProfileOptionTile(
                        icon: Icons.info_outline,
                        title: profilePageContext.l10n.aboutUs,
                        onTap: () {
                          Navigator.push(
                            profilePageContext,
                            MaterialPageRoute(builder: (_) => const AboutUsPage()),
                          );
                        },
                      ),
                      SizedBox(height: 20.h),
                      ProfileOptionTile(
                        icon: Icons.logout,
                        title: profilePageContext.l10n.logout,
                        isDestructive: true,
                        onTap: () {
                          showGeneralDialog(
                            context: profilePageContext,
                            barrierDismissible: true,
                            barrierLabel: "Logout",
                            barrierColor: Colors.black54,
                            transitionDuration: const Duration(milliseconds: 300),
                            pageBuilder: (dialogContext, animation, secondaryAnimation) {
                              return const SizedBox();
                            },
                            transitionBuilder:
                                (dialogContext, animation, secondaryAnimation, child) {
                              return Transform.scale(
                                scale: animation.value,
                                child: Opacity(
                                  opacity: animation.value,
                                  child: AlertDialog(
                                    backgroundColor: Colors.cyan.withValues(alpha: 0.2),
                                    title: const Text(
                                      "Logout",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    content: const Text(
                                      "Are you sure you want to logout ?",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(dialogContext);
                                        },
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(dialogContext);
                                          profilePageContext.read<LogoutCubit>().logout();
                                        },
                                        child: const Text(
                                          "Logout",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _showPickOptionsDialog,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 3),
                ),
                child: CircleAvatar(
                  radius: 50.r,
                  backgroundColor: Colors.black26,
                  backgroundImage: selectedFile != null
                      ? FileImage(selectedFile!)
                      : null,
                  child: selectedFile == null
                      ? Icon(Icons.person, color: Colors.white70, size: 50.r)
                      : null,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF00838F),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          uploadedFileName ?? context.l10n.tapToUploadPhoto,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _returnToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }
}
