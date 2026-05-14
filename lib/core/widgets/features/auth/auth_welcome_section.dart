import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';

/// Logo, welcome title, and subtitle for [AuthScreen].
class AuthWelcomeSection extends StatelessWidget {
  const AuthWelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          isDark ? AppImages.appLogoWhite : AppImages.appLogoBlack,
          height: AppResponsive.screenHeight(context) * 0.15,
        ),
        Text(
          AppTexts.authWelcomeTitle,
          style: AppTextStyles.headline(context).copyWith(
            color: isDark ? AppColors.white : AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          AppTexts.authWelcomeSubtitle,
          style: AppTextStyles.bodyText(
            context,
          ).copyWith(color: isDark ? AppColors.lightGrey : AppColors.grey),
        ),
      ],
    );
  }
}
