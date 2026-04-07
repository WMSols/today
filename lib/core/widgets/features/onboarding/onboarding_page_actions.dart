import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/buttons/app_button.dart';
import 'package:today/core/widgets/buttons/app_social_action_button.dart';

/// Bottom action area for onboarding pages.
class OnboardingPageActions extends StatelessWidget {
  const OnboardingPageActions({
    super.key,
    required this.primaryLabel,
    required this.onPrimaryTap,
    required this.onSocialTap,
    this.showSocialButtons = false,
    this.legalText,
  });

  final String primaryLabel;
  final VoidCallback onPrimaryTap;
  final VoidCallback onSocialTap;
  final bool showSocialButtons;
  final String? legalText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: AppResponsive.screenWidth(context) * 0.8,
          child: AppButton(
            label: primaryLabel,
            primary: false,
            onPressed: onPrimaryTap,
          ),
        ),
        if (showSocialButtons) ...[
          AppSpacing.vertical(context, 0.02),
          SizedBox(
            width: AppResponsive.screenWidth(context) * 0.8,
            child: Row(
              children: [
                Expanded(
                  child: SocialActionButton(
                    image: AppImages.google,
                    onTap: onSocialTap,
                  ),
                ),
                AppSpacing.horizontal(context, 0.03),
                Expanded(
                  child: SocialActionButton(
                    image: AppImages.apple,
                    onTap: onSocialTap,
                  ),
                ),
              ],
            ),
          ),
        ],
        if (!showSocialButtons && legalText != null) ...[
          AppSpacing.vertical(context, 0.02),
          Text(
            legalText!,
            textAlign: TextAlign.center,
            style: AppTextStyles.hintText(context).copyWith(
              color: AppColors.white.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
              fontSize: AppResponsive.screenWidth(context) * 0.028,
            ),
          ),
          AppSpacing.vertical(context, 0.01),
        ],
      ],
    );
  }
}
