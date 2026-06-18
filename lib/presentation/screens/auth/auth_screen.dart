import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_mode_tabs.dart';
import 'package:today/core/widgets/features/auth/auth_footer.dart';
import 'package:today/core/widgets/features/auth/auth_login_form.dart';
import 'package:today/core/widgets/features/auth/auth_signup_form.dart';
import 'package:today/core/widgets/features/auth/auth_social_section.dart';
import 'package:today/core/widgets/features/auth/auth_submit_section.dart';
import 'package:today/core/widgets/features/auth/auth_welcome_section.dart';
import 'package:today/presentation/controllers/auth/auth_controller.dart';

class AuthScreen extends GetView<AuthController> {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceColor,
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
                      Obx(
                        () => AppModeTabs(
                          tabs: const [
                            AppModeTab(label: AppTexts.login),
                            AppModeTab(label: AppTexts.signUp),
                          ],
                          selectedIndex: controller.isLoginMode.value ? 0 : 1,
                          onChanged: (index) =>
                              controller.switchMode(index == 0),
                        ),
                      ),
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
