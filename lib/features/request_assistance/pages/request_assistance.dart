import 'dart:io';

import 'package:aoun/core/di/injection_container.dart';
import 'package:aoun/core/storage/auth_local_data_source.dart';
import 'package:aoun/core/extensions/localization_extension.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/features/request_assistance/domain/entities/request_assistance_entity.dart';
import 'package:aoun/features/request_assistance/presentation/cubit/request_assistance_cubit.dart';
import 'package:aoun/features/request_assistance/presentation/cubit/request_assistance_state.dart';
import 'package:aoun/features/splash/splash_background.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestAssistancePage extends StatelessWidget {
  const RequestAssistancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RequestAssistanceCubit>(),
      child: const _RequestAssistanceView(),
    );
  }
}

class _RequestAssistanceView extends StatefulWidget {
  const _RequestAssistanceView();

  @override
  State<_RequestAssistanceView> createState() => _RequestAssistanceViewState();
}

class _RequestAssistanceViewState extends State<_RequestAssistanceView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _foundationController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final List<File> _selectedFiles = [];
  String _selectedCategory = 'medical';
  String _selectedUrgency = 'Medium';

  @override
  void initState() {
    super.initState();
    _loadFoundationName();
  }

  Future<void> _loadFoundationName() async {
    final userData = await sl<AuthLocalDataSource>().getUserData();
    if (userData != null && userData['role'] == 'foundation_admin') {
      final name = userData['name']?.toString() ?? '';
      if (name.isNotEmpty) {
        setState(() {
          _foundationController.text = name;
        });
      }
    }
  }

  // Valid API urgency values (keys = what gets sent to API)
  static const Map<String, String> _urgencyLevels = {
    'Low': 'Low',
    'Medium': 'Medium',
    'High': 'High',
  };

  static const Map<String, Color> _urgencyColors = {
    'Low': Colors.green,
    'Medium': Colors.orange,
    'High': Colors.deepOrange,
  };

  String _getUrgencyLabel(String key, bool isAr) {
    if (isAr) {
      switch (key) {
        case 'Low':
          return 'منخفض';
        case 'Medium':
          return 'متوسط';
        case 'High':
          return 'مرتفع';

        default:
          return key;
      }
    }
    return key;
  }

  @override
  void dispose() {
    _foundationController.dispose();
    _locationController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // Future<void> _pickFile({
  //   bool fromCamera = false,
  //   bool isDocument = false,
  // }) async {
  //   if (fromCamera) {
  //     final ImagePicker picker = ImagePicker();
  //     final XFile? pickedFile = await picker.pickImage(
  //       source: ImageSource.camera,
  //     );
  //     if (pickedFile != null) {
  //       setState(() {
  //         _selectedFiles.add(File(pickedFile.path));
  //       });
  //     }
  //   } else if (isDocument) {
  //     try {
  //       final FilePickerResult? result = await FilePicker.platform.pickFiles(
  //         type: FileType.custom,
  //         allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
  //       );
  //       if (result != null && result.files.single.path != null) {
  //         setState(() {
  //           _selectedFiles.add(File(result.files.single.path!));
  //         });
  //       }
  //     } catch (e) {
  //       debugPrint('Error picking document: $e');
  //     }
  //   } else {
  //     try {
  //       final FilePickerResult? result = await FilePicker.platform.pickFiles(
  //         allowMultiple: true,
  //         type: FileType.image,
  //       );
  //       if (result != null) {
  //         setState(() {
  //           _selectedFiles.addAll(
  //             result.paths.where((p) => p != null).map((p) => File(p!)),
  //           );
  //         });
  //       }
  //     } catch (e) {
  //       debugPrint('Error picking images: $e');
  //     }
  //   }
  // }

  void _showPickOptionsDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final isAr = Localizations.localeOf(context).languageCode == 'ar';
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(isAr ? 'الكاميرا' : 'Camera'),
                onTap: () {
                  Navigator.pop(context);
                  // _pickFile(fromCamera: true);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(isAr ? 'معرض الصور' : 'Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  // _pickFile(fromCamera: false);
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: Text(isAr ? 'ملف مستند (PDF)' : 'Document (PDF)'),
                onTap: () {
                  Navigator.pop(context);
                  // _pickFile(fromCamera: false, isDocument: true);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final entity = RequestAssistanceEntity(
        foundationName: _foundationController.text.trim(),
        location: _locationController.text.trim(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        requiredAmount: double.tryParse(_amountController.text.trim()) ?? 0.0,
        files: _selectedFiles,
        category: _selectedCategory,
        urgency: _selectedUrgency,
      );

      context.read<RequestAssistanceCubit>().submitRequest(entity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final categoriesMap = {
      'medical': context.l10n.donationMedicalSupplies,
      'food': context.l10n.donationFood,
      'clothes': context.l10n.donationClothes,
      'education': context.l10n.donationBooks,
      'financial': context.l10n.donationMoney,
    };

    // Ensure fallback if the selected category is somehow not in the options map
    if (!categoriesMap.containsKey(_selectedCategory) &&
        categoriesMap.isNotEmpty) {
      _selectedCategory = categoriesMap.keys.first;
    }

    return BlocConsumer<RequestAssistanceCubit, RequestAssistanceState>(
      listener: (context, state) {
        if (state is RequestAssistanceSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isAr
                    ? 'تم إرسال طلب المساعدة بنجاح'
                    : 'Assistance request submitted successfully!',
              ),
              backgroundColor: Colors.green,
            ),
          );
          _foundationController.clear();
          _locationController.clear();
          _titleController.clear();
          _descriptionController.clear();
          _amountController.clear();
          setState(() {
            _selectedFiles.clear();
            _selectedCategory = 'medical';
            _selectedUrgency = 'Medium';
          });
        } else if (state is RequestAssistanceFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is RequestAssistanceLoading;

        return SplashBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                context.l10n.requestAssistance,
                style: AppTextStyle.heading(
                  context,
                  fontSize: 18.sp,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              leading: const BackButton(color: Colors.white),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Foundation Name ──
                    _sectionLabel(isAr ? 'اسم المؤسسة' : 'Foundation Name'),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      _foundationController,
                      isAr ? 'أدخل اسم المؤسسة' : 'Enter foundation name',
                    ),
                    SizedBox(height: 16.h),

                    // ── Location ──
                    _sectionLabel(isAr ? 'الموقع' : 'Location'),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      _locationController,
                      isAr ? 'أدخل الموقع' : 'Enter location',
                    ),
                    SizedBox(height: 16.h),

                    // ── Title ──
                    _sectionLabel(isAr ? 'العنوان' : 'Title'),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      _titleController,
                      isAr ? 'أدخل عنوان الطلب' : 'Enter request title',
                    ),
                    SizedBox(height: 16.h),

                    // ── Details / Description ──
                    _sectionLabel(isAr ? 'التفاصيل' : 'Details'),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      _descriptionController,
                      isAr
                          ? 'اشرح حالتك بالتفصيل...'
                          : 'Describe your situation in detail...',
                      maxLines: 4,
                    ),
                    SizedBox(height: 16.h),

                    // ── Category ──
                    _sectionLabel(isAr ? 'الفئة' : 'Category'),
                    SizedBox(height: 8.h),
                    _buildDropdown<String>(
                      value: _selectedCategory,
                      items: categoriesMap.entries.map((e) {
                        return DropdownMenuItem<String>(
                          value: e.key,
                          child: Text(e.value),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedCategory = val);
                        }
                      },
                    ),
                    SizedBox(height: 16.h),

                    // ── Urgency ──
                    _sectionLabel(isAr ? 'مستوى الإلحاح' : 'Urgency Level'),
                    SizedBox(height: 8.h),
                    _buildUrgencySelector(isAr),
                    SizedBox(height: 16.h),

                    // ── Target Amount ──
                    _sectionLabel(
                      isAr ? 'المبلغ المستهدف (\$)' : 'Target Amount (\$)',
                    ),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      _amountController,
                      isAr ? '0.00' : '0.00',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16.h),

                    // ── File Upload ──
                    _sectionLabel(
                      isAr
                          ? 'الملفات المرفقة (اختياري)'
                          : 'Attached Files (Optional)',
                    ),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: isLoading ? null : _showPickOptionsDialog,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 20.h,
                          horizontal: 16.w,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: _selectedFiles.isNotEmpty
                                ? Colors.teal
                                : Colors.white.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _selectedFiles.isNotEmpty
                                  ? Icons.check_circle_outline_rounded
                                  : Icons.cloud_upload_outlined,
                              color: _selectedFiles.isNotEmpty
                                  ? Colors.teal
                                  : Colors.white70,
                              size: 24.r,
                            ),
                            SizedBox(width: 10.w),
                            Flexible(
                              child: Text(
                                isAr
                                    ? 'اضغط لإضافة ملفات (صور أو مستندات)'
                                    : 'Tap to add files (Images or Documents)',
                                style: TextStyle(
                                  color: _selectedFiles.isNotEmpty
                                      ? Colors.teal
                                      : Colors.white70,
                                  fontSize: 13.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_selectedFiles.isNotEmpty) ...[
                      SizedBox(height: 12.h),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _selectedFiles.length,
                        itemBuilder: (context, index) {
                          final file = _selectedFiles[index];
                          final fileName = file.path
                              .split(Platform.pathSeparator)
                              .last;
                          final isPdf = fileName.toLowerCase().endsWith('.pdf');
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 4.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isPdf
                                      ? Icons.picture_as_pdf
                                      : Icons.insert_drive_file,
                                  color: isPdf
                                      ? Colors.redAccent
                                      : Colors.tealAccent,
                                  size: 20.r,
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    fileName,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white60,
                                    size: 18,
                                  ),
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          setState(() {
                                            _selectedFiles.removeAt(index);
                                          });
                                        },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                    SizedBox(height: 30.h),

                    // ── Submit Button ──
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade400,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 4,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                isAr ? 'إرسال الطلب' : 'Submit Request',
                                style: AppTextStyle.heading(
                                  context,
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.9),
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      validator: (value) =>
          (value == null || value.trim().isEmpty) ? 'Required field' : null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
        contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Colors.teal),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF1A2332),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.white.withValues(alpha: 0.7),
          ),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildUrgencySelector(bool isAr) {
    return Row(
      children: _urgencyLevels.entries.map((e) {
        final isSelected = _selectedUrgency == e.key;
        final color = _urgencyColors[e.key] ?? Colors.grey;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedUrgency = e.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.25)
                    : Colors.white.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: isSelected
                      ? color
                      : Colors.white.withValues(alpha: 0.15),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    isSelected
                        ? Icons.warning_amber_rounded
                        : Icons.circle_outlined,
                    color: isSelected ? color : Colors.white38,
                    size: 16.r,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _getUrgencyLabel(e.key, isAr),
                    style: TextStyle(
                      color: isSelected ? color : Colors.white54,
                      fontSize: 10.sp,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
