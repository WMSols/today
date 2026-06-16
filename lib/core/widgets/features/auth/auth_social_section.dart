import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_social_action_button.dart';
import 'package:today/presentation/controllers/auth/auth_controller.dart';

/// “Or continue with” label and Google / Apple actions for [AuthScreen].
class AuthSocialSection extends GetView<AuthController> {
  const AuthSocialSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = isDark ? AppColors.lightGrey : AppColors.grey;
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(child: Divider(color: dividerColor, thickness: 1)),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.horizontalValue(context, 0.02),
                ),
                child: Text(
                  AppTexts.authOrContinueWith,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyText(
                    context,
                  ).copyWith(color: dividerColor, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(child: Divider(color: dividerColor, thickness: 1)),
            ],
          ),
        ),
        AppSpacing.vertical(context, 0.008),
        SizedBox(
          width: AppResponsive.screenWidth(context) * 0.8,
          child: Row(
            children: [
              Expanded(
                child: SocialActionButton(
                  image: AppImages.google,
                  onTap: controller.signInWithGoogle,
                ),
              ),
              AppSpacing.horizontal(context, 0.03),
              Expanded(
                child: SocialActionButton(
                  image: AppImages.apple,
                  onTap: controller.signInWithApple,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
