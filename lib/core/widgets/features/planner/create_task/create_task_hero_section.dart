import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';

/// Title and subtitle below [AppBrandLogo] on [CreateTaskScreen].
class CreateTaskHeroSection extends StatelessWidget {
  const CreateTaskHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppTexts.createTaskHeroTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.heading(context).copyWith(
            color: context.onSurfaceColor,
            fontWeight: FontWeight.w600,
            fontSize: AppResponsive.scaleSize(context, 16),
          ),
        ),
        Text(
          AppTexts.createTaskHeroSubtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyText(context).copyWith(
            color: context.mutedOnSurfaceColor,
            fontWeight: FontWeight.w500,
            fontSize: AppResponsive.scaleSize(context, 12),
          ),
        ),
      ],
    );
  }
}
