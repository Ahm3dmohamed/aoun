import 'package:aoun/core/di/injection_container.dart';
import 'package:aoun/core/storage/auth_local_data_source.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/features/foundations/domain/entities/donation_entity.dart';
import 'package:aoun/features/foundations/domain/entities/foundation_entity.dart';
import 'package:aoun/features/foundations/presentation/cubit/foundation_cubit.dart';
import 'package:aoun/features/foundations/presentation/cubit/foundation_state.dart';
import 'package:aoun/features/splash/splash_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

class DonationPage extends StatefulWidget {
  final FoundationEntity foundation;
  final bool viewOnly;

  const DonationPage({
    super.key,
    required this.foundation,
    this.viewOnly = false,
  });

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final _amountController = TextEditingController();
  final _detailsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _donorName = 'Anonymous Donor';
  String _selectedPurpose = 'Money';

  final List<String> _purposes = [
    'Money',
    'Food',
    'Books',
    'Clothes',
    'Medical Equipment'
  ];

  @override
  void initState() {
    super.initState();
    _loadDonorName();
  }

  Future<void> _loadDonorName() async {
    final userData = await sl<AuthLocalDataSource>().getUserData();
    if (userData != null && userData['name'] != null && mounted) {
      setState(() {
        _donorName = userData['name'].toString();
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _onDonatePressed(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) return;

    final donation = DonationEntity(
      id: const Uuid().v4(),
      foundationId: widget.foundation.id,
      foundationName: widget.foundation.name,
      donorName: _donorName,
      amount: amount,
      createdAt: DateTime.now().toIso8601String(),
      purpose: _selectedPurpose,
      details: _selectedPurpose == 'Money' ? null : _detailsController.text.trim(),
    );

    context.read<FoundationCubit>().submitDonation(donation);
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final progress = (widget.foundation.totalDonations / widget.foundation.targetAmount).clamp(0.0, 1.0);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isAr ? 'تفاصيل التبرع' : 'Donation Details',
          style: AppTextStyle.heading(context, fontSize: 18.sp, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SplashBackground(
        child: BlocConsumer<FoundationCubit, FoundationState>(
          listener: (context, state) {
            if (state.donationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isAr
                        ? 'شكراً لك! تم التبرع بنجاح.'
                        : 'Thank you! Your donation was successful.',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: kToolbarHeight.h + 20.h),

                    // Card visual header
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.12),
                            Colors.white.withOpacity(0.04),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: Colors.white.withOpacity(0.15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 50.r,
                                height: 50.r,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.teal.shade300, Colors.blue.shade500],
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: const Icon(Icons.volunteer_activism_rounded, color: Colors.white),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.foundation.name,
                                      style: AppTextStyle.heading(context, fontSize: 18.sp, color: Colors.white),
                                    ),
                                    SizedBox(height: 4.h),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on_outlined, size: 14.r, color: Colors.white70),
                                        SizedBox(width: 4.w),
                                        Text(
                                          widget.foundation.location,
                                          style: AppTextStyle.caption(context, fontSize: 12.sp, color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            isAr ? 'عن المؤسسة' : 'About Foundation',
                            style: AppTextStyle.subHeading(context, fontSize: 14.sp, color: Colors.white),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            widget.foundation.description ??
                                (isAr
                                    ? 'هذه المؤسسة ملتزمة بتقديم المساعدات والخدمات للمجتمع.'
                                    : 'This foundation is dedicated to providing assistance and community services.'),
                            style: AppTextStyle.body(
                              context,
                              fontSize: 13.sp,
                              color: Colors.white.withOpacity(0.85),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Donation Stats & Progress Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isAr ? 'المبلغ المجموع' : 'Total Raised',
                                style: AppTextStyle.caption(context, fontSize: 12.sp, color: Colors.white70),
                              ),
                              Text(
                                isAr ? 'المبلغ المستهدف' : 'Target Goal',
                                style: AppTextStyle.caption(context, fontSize: 12.sp, color: Colors.white70),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${widget.foundation.totalDonations.toStringAsFixed(0)}',
                                style: AppTextStyle.heading(context, fontSize: 18.sp, color: Colors.teal.shade300),
                              ),
                              Text(
                                '\$${widget.foundation.targetAmount.toStringAsFixed(0)}',
                                style: AppTextStyle.heading(context, fontSize: 18.sp, color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4.r),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 8.h,
                              backgroundColor: Colors.white.withOpacity(0.1),
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade400),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${(progress * 100).toStringAsFixed(0)}% Completed',
                              style: AppTextStyle.caption(context, fontSize: 11.sp, color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    if (!widget.viewOnly) ...[
                      Text(
                        isAr ? 'الغرض من التبرع' : 'Purpose of Donation',
                        style: AppTextStyle.subHeading(context, fontSize: 14.sp, color: Colors.white),
                      ),
                      SizedBox(height: 10.h),
                      DropdownButtonFormField<String>(
                        value: _selectedPurpose,
                        dropdownColor: Colors.grey.shade900,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: const BorderSide(color: Colors.teal),
                          ),
                        ),
                        items: _purposes.map((purpose) {
                          return DropdownMenuItem(
                            value: purpose,
                            child: Text(purpose),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedPurpose = val;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 24.h),

                      if (_selectedPurpose == 'Money') ...[
                        Text(
                          isAr ? 'أدخل مبلغ التبرع (\$)' : 'Enter Donation Amount (\$)',
                          style: AppTextStyle.subHeading(context, fontSize: 14.sp, color: Colors.white),
                        ),
                        SizedBox(height: 10.h),
                        TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: isAr ? 'أدخل المبلغ هنا' : 'Enter amount here',
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                            filled: true,
                            fillColor: Colors.black.withOpacity(0.15),
                            prefixIcon: const Icon(Icons.attach_money_rounded, color: Colors.teal),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: const BorderSide(color: Colors.teal),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return isAr ? 'يرجى إدخال المبلغ' : 'Please enter an amount';
                            }
                            final val = double.tryParse(value.trim());
                            if (val == null || val <= 0) {
                              return isAr ? 'يرجى إدخال مبلغ صحيح' : 'Please enter a valid positive amount';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [10, 50, 100, 500].map((amt) {
                            return Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white.withOpacity(0.12),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                      side: BorderSide(color: Colors.white.withOpacity(0.15)),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 8.h),
                                  ),
                                  onPressed: () {
                                    _amountController.text = amt.toString();
                                  },
                                  child: Text('\$$amt'),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ] else ...[
                        Text(
                          isAr ? 'الكمية التقديرية' : 'Estimated Quantity',
                          style: AppTextStyle.subHeading(context, fontSize: 14.sp, color: Colors.white),
                        ),
                        SizedBox(height: 10.h),
                        TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: isAr ? 'أدخل الكمية' : 'Enter quantity',
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                            filled: true,
                            fillColor: Colors.black.withOpacity(0.15),
                            prefixIcon: const Icon(Icons.numbers_rounded, color: Colors.teal),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: const BorderSide(color: Colors.teal),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return isAr ? 'يرجى إدخال الكمية' : 'Please enter a quantity';
                            }
                            final val = double.tryParse(value.trim());
                            if (val == null || val <= 0) {
                              return isAr ? 'يرجى إدخال كمية صحيحة' : 'Please enter a valid positive quantity';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          isAr ? 'تفاصيل إضافية (النوع، الحالة، الخ)' : 'Additional Details (Type, Condition, etc.)',
                          style: AppTextStyle.subHeading(context, fontSize: 14.sp, color: Colors.white),
                        ),
                        SizedBox(height: 10.h),
                        TextFormField(
                          controller: _detailsController,
                          maxLines: 3,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: isAr ? 'أدخل التفاصيل هنا...' : 'Enter details here...',
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                            filled: true,
                            fillColor: Colors.black.withOpacity(0.15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: const BorderSide(color: Colors.teal),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return isAr ? 'يرجى إدخال التفاصيل' : 'Please enter details';
                            }
                            return null;
                          },
                        ),
                      ],
                      SizedBox(height: 30.h),

                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade400,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 4,
                          ),
                          onPressed: state.isLoading ? null : () => _onDonatePressed(context),
                          child: state.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  isAr ? 'تأكيد التبرع' : 'Confirm Donation',
                                  style: AppTextStyle.heading(context, fontSize: 16.sp, color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
