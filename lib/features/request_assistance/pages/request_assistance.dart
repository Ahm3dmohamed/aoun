import 'dart:io';

import 'package:aoun/core/extensions/localization_extension.dart';
import 'package:aoun/features/profile/widgets/pick_image_option_sheet.dart';
import 'package:aoun/features/splash/splash_background.dart';
import 'package:aoun/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class RequestAssistancePage extends StatefulWidget {
  const RequestAssistancePage({super.key});

  @override
  State<RequestAssistancePage> createState() => _RequestAssistancePageState();
}

class _RequestAssistancePageState extends State<RequestAssistancePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _foundationController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String? uploadedFileName;
  File? selectedFile;

  Future<void> _pickFile({bool fromCamera = false}) async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile;

    if (fromCamera) {
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }

    if (pickedFile != null) {
      setState(() {
        uploadedFileName = pickedFile!.name;
        selectedFile = File(
          pickedFile.path,
        ); // if you want to use the actual file
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Assistance Request Submitted")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SplashBackground(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 30.h),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 100.h,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.l10n.requestAssistance,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 15.h),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        _foundationController,
                        context.l10n.foundationName,
                      ),
                      SizedBox(height: 14.h),
                      _buildTextField(
                        _locationController,
                        context.l10n.location,
                      ),
                      SizedBox(height: 14.h),
                      _buildTextField(_titleController, context.l10n.title),
                      SizedBox(height: 14.h),
                      _buildTextField(
                        _descriptionController,
                        context.l10n.description,
                        maxLines: 3,
                      ),
                      SizedBox(height: 18.h),

                      InkWell(
                        onTap: _showPickOptionsDialog,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blueAccent),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.cloud_upload,
                                size: 25,
                                color: Colors.blueAccent,
                              ),
                              SizedBox(height: 9.h),
                              Text(
                                uploadedFileName ?? context.l10n.uploadFile,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 13.h),
                      _buildTextField(
                        _amountController,
                        context.l10n.requiredAmount,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 18.h),

                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            context.l10n.send,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) => (value == null || value.isEmpty)
          ? context.l10n.validationMessage(label)
          : null,

      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        contentPadding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 16.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
