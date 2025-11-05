import 'dart:io';
import 'package:aoun/features/profile/widgets/pick_image_option_sheet.dart';
import 'package:aoun/features/splash/splash_background.dart';
import 'package:aoun/features/profile/widgets/profile_option_tile.dart';
import 'package:flutter/material.dart';
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
    return SplashBackground(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30.h),

              GestureDetector(
                onTap: _showPickOptionsDialog,
                child: CircleAvatar(
                  radius: 60.h,
                  backgroundColor: Colors.white24,
                  backgroundImage: selectedFile != null
                      ? FileImage(selectedFile!)
                      : null,
                  child: selectedFile == null
                      ? const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 40,
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 16),
              Text(
                uploadedFileName ?? "Tap above to upload your photo",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),

              const SizedBox(height: 40),

              ProfileOptionTile(
                icon: Icons.star,
                title: 'Recommended Donations',
                onTap: () {
                  // TODO: Navigate to Recommended Donations page
                },
              ),
              ProfileOptionTile(
                icon: Icons.person,
                title: 'Account Information',
                onTap: () {
                  // TODO: Navigate to Account Info
                },
              ),
              ProfileOptionTile(
                icon: Icons.favorite,
                title: 'Your Donations',
                onTap: () {
                  // TODO: Navigate to Donations page
                },
              ),
              ProfileOptionTile(
                icon: Icons.lock,
                title: 'Change Password',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
