import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_fonts/app_fonts.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

/// Reusable form field label with optional required asterisk and spacing below.
/// When [label] is null, returns [SizedBox.shrink]. Use [spacingAfter] to adjust
/// the gap after the label (default 0.005; e.g. use 0.008 for image picker).
class AppFormFieldLabel extends StatelessWidget {
  const AppFormFieldLabel({super.key, this.label, this.required = false});

  final String? label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    if (label == null || label!.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label!,
              style: AppTextStyles.bodyText(context).copyWith(
                fontWeight: FontWeight.w500,
                fontFamily: AppFonts.mainFont,
                color: AppColors.black,
              ),
            ),
            if (required)
              Text(
                ' *',
                style: AppTextStyles.bodyText(context).copyWith(
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.mainFont,
                  color: AppColors.error,
                ),
              ),
          ],
        ),
        AppSpacing.vertical(context, 0.005),
      ],
    );
  }
}
