import 'package:aoun/core/extensions/localization_extension.dart';
import 'package:aoun/core/themes/app_colors.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:aoun/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToggleUserType extends StatelessWidget {
  final bool isDonor;
  final ValueChanged<bool> onChanged;

  const ToggleUserType({
    super.key,
    required this.isDonor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
      ),
      child: Row(
        children: [
          _buildButton(context, context.l10n.donor, isDonor, true),
          _buildButton(context, context.l10n.foundation, !isDonor, false),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    bool active,
    bool value,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: active ? AppColors.lightPrimary : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: AppTextStyle.body(
              context,
              color: active ? Colors.white : AppColors.lightPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
