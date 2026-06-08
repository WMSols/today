import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_lotties/app_lotties.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';

/// Scrollable hero: Lottie, title, and intro copy for [ProfileSetupScreen].
class ProfileSetupHeader extends StatelessWidget {
  const ProfileSetupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final lottieSize = AppResponsive.scaleSize(context, 200);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Lottie.asset(
          AppLotties.profileSetup,
          width: lottieSize,
          height: lottieSize,
          fit: BoxFit.contain,
        ),
        AppSpacing.vertical(context, 0.01),
        Text(
          AppTexts.profileSetupTitle,
          style: AppTextStyles.heading(context).copyWith(
            color: context.onSurfaceColor,
            fontWeight: FontWeight.w600,
            fontSize: AppResponsive.scaleSize(context, 22),
          ),
        ),
        RichText(
          text: TextSpan(
            style: AppTextStyles.bodyText(context).copyWith(
              color: context.onSurfaceColor,
              fontWeight: FontWeight.w500,
              fontSize: AppResponsive.scaleSize(context, 14),
            ),
            children: const [
              TextSpan(text: AppTexts.profileSetupSubtitleLead),
              TextSpan(
                text: AppTexts.profileSetupSubtitleBrand,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              TextSpan(text: AppTexts.profileSetupSubtitleTail),
            ],
          ),
        ),
      ],
    );
  }
}
