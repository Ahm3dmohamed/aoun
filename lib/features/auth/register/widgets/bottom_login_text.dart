import 'package:aoun/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class BottomLoginText extends StatelessWidget {
  BottomLoginText({
    required this.onPressed,
    required this.txt,
    required this.txtBtn,
    super.key,
  });
  final void Function()? onPressed;
  final String txt;
  final String txtBtn;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          txt,
          style: AppTextStyle.body(
            context,
            color: Colors.grey[200]!,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            txtBtn,
            style: AppTextStyle.custom(
              context,
              color: const Color(0xFFF6F6F6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
