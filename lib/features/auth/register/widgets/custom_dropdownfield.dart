import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdownField extends StatelessWidget {
  final String? value;
  final String? hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdownField({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.4),
        borderRadius: BorderRadius.circular(34.r),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelStyle: TextStyle(color: Colors.grey[700]),
        ),
        dropdownColor: Colors.transparent,
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
        hint: hint != null
            ? Text(hint!, style: const TextStyle(color: Colors.grey))
            : null,
        items: items
            .map(
              (option) => DropdownMenuItem<String>(
                value: option,
                child: Text(
                  option,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
