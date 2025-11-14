import 'package:aoun/core/extensions/localization_extension.dart';
import 'package:aoun/core/routing/app_routes.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class ForgetPasswordText extends StatelessWidget {
  const ForgetPasswordText({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.forgotPassword);
        },
        child: Text(
          context.l10n.forgotPassword,
          style: AppTextStyle.custom(
            context,
            color: const Color(0xFFF6F6F6),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
