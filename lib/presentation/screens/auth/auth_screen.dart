import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/widgets/buttons/app_button.dart';
import 'package:today/core/widgets/features/auth/auth_footer.dart';
import 'package:today/core/widgets/features/auth/auth_login_form.dart';
import 'package:today/core/widgets/features/auth/auth_mode_tabs.dart';
import 'package:today/core/widgets/features/auth/auth_signup_form.dart';
import 'package:today/core/widgets/features/auth/auth_social_section.dart';
import 'package:today/core/widgets/features/auth/auth_submit_section.dart';
import 'package:today/core/widgets/features/auth/auth_welcome_section.dart';
import 'package:today/presentation/controllers/auth/auth_controller.dart';

class AuthScreen extends GetView<AuthController> {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authTabColors = AppButtonColors(
      filledBackground: isDark ? AppColors.secondary : AppColors.primary,
      filledForeground: isDark ? AppColors.primary : AppColors.secondary,
      outlinedBackground: Colors.transparent,
      outlinedForeground: isDark ? AppColors.secondary : AppColors.primary,
      outlinedBorder: isDark ? AppColors.secondary : AppColors.primary,
    );
    return Scaffold(
      backgroundColor: isDark ? AppColors.black : AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AuthWelcomeSection(),
                      AppSpacing.vertical(context, 0.04),
                      AuthModeTabs(colors: authTabColors),
                      AppSpacing.vertical(context, 0.025),
                      Obx(
                        () => controller.isLoginMode.value
                            ? const AuthLoginForm()
                            : const AuthSignupForm(),
                      ),
                      AppSpacing.vertical(context, 0.03),
                      const AuthSubmitSection(),
                    ],
                  ),
                ),
              ),
              AppSpacing.vertical(context, 0.02),
              const AuthSocialSection(),
              AppSpacing.vertical(context, 0.012),
              const AuthFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
