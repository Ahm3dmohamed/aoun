import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String hint;

  /// Use [itemsMap] to provide apiValue → displayLabel mapping.
  /// The [value] should then be the API value (key), not the display label.
  final Map<String, String>? itemsMap;

  /// Legacy: simple list of strings (value == display label).
  final List<String>? items;

  final String? value;
  final ValueChanged<String?> onChanged;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.onChanged,
    this.value,
    this.items,
    this.itemsMap,
  }) : assert(items != null || itemsMap != null,
            'Provide either items or itemsMap');

  @override
  Widget build(BuildContext context) {
    // Build dropdown items from map or list
    final List<DropdownMenuItem<String>> dropdownItems;
    if (itemsMap != null) {
      dropdownItems = itemsMap!.entries
          .map(
            (e) => DropdownMenuItem<String>(
              value: e.key, // API value
              child: Text(e.value, style: const TextStyle(color: Colors.white)),
            ),
          )
          .toList();
    } else {
      dropdownItems = (items ?? [])
          .map(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e, style: const TextStyle(color: Colors.white)),
            ),
          )
          .toList();
    }

    // Validate that current value exists in items
    final validValue = (itemsMap != null)
        ? (itemsMap!.containsKey(value) ? value : null)
        : ((items?.contains(value) ?? false) ? value : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: validValue,
            dropdownColor: const Color(0xFF1A1A2E),
            hint: Text(
              hint,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            ),
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            style: const TextStyle(color: Colors.white, fontSize: 16),
            items: dropdownItems,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
