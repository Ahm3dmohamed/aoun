import 'package:aoun/core/extensions/localization_extension.dart';
import 'package:aoun/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class AgreementText extends StatelessWidget {
  const AgreementText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: context.l10n.iAgreeTo,
        style: AppTextStyle.body(
          context,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(
            text: ' ${context.l10n.termsConditions} ',
            style: AppTextStyle.custom(
              fontSize: 15,
              context,
              color: const Color.fromARGB(255, 7, 7, 7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
