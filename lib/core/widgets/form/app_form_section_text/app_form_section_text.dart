import 'package:flutter/material.dart';

import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

/// Form Section text with standard small font size used below form fields.
class AppFormSectionText extends StatelessWidget {
  const AppFormSectionText(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.hintText(context).copyWith(
        fontSize: AppResponsive.screenWidth(context) * 0.03,
        color: color,
      ),
    );
  }
}
