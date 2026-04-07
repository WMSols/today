import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

/// Main onboarding content block with hero animation and tagline.
class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({
    super.key,
    required this.lottiePath,
    required this.taglineBold,
    required this.taglineRegular,
  });

  final String lottiePath;
  final String taglineBold;
  final String taglineRegular;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: Lottie.asset(
                  lottiePath,
                  fit: BoxFit.contain,
                  repeat: true,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                ),
              );
            },
          ),
        ),
        AppSpacing.vertical(context, 0.04),
        SizedBox(
          width: AppResponsive.screenWidth(context) * 0.8,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: taglineBold,
                  style: AppTextStyles.bodyText(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                    fontSize: AppResponsive.screenWidth(context) * 0.045,
                  ),
                ),
                TextSpan(
                  text: taglineRegular,
                  style: AppTextStyles.bodyText(context).copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.white.withValues(alpha: 0.7),
                    fontSize: AppResponsive.screenWidth(context) * 0.045,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: AppResponsive.screenHeight(context) * 0.02),
      ],
    );
  }
}
