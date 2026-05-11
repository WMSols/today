import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_button.dart';
import 'package:today/core/widgets/buttons/app_icon_button.dart';
import 'package:today/core/widgets/features/auth/auth_footer.dart';
import 'package:today/core/widgets/form/app_checkbox/app_checkbox.dart';
import 'package:today/core/widgets/form/app_text_field/app_text_field.dart';
import 'package:today/presentation/controllers/auth/auth_controller.dart';

class AuthScreen extends GetView<AuthController> {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                      Image.asset(
                        AppImages.appLogo,
                        height: AppResponsive.screenHeight(context) * 0.15,
                      ),
                      Text(
                        AppTexts.authWelcomeTitle,
                        style: AppTextStyles.headline(context).copyWith(
                          color:
                              isDark ? AppColors.white : AppColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        AppTexts.authWelcomeSubtitle,
                        style: AppTextStyles.bodyText(context).copyWith(
                          color:
                              isDark ? AppColors.lightGrey : AppColors.grey,
                        ),
                      ),
                      AppSpacing.vertical(context, 0.04),
                      Obx(
                        () => Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                label: AppTexts.login,
                                primary: controller.isLoginMode.value
                                    ? false
                                    : true,
                                onPressed: () => controller.switchMode(true),
                              ),
                            ),
                            AppSpacing.horizontal(context, 0.02),
                            Expanded(
                              child: AppButton(
                                label: AppTexts.signUp,
                                primary: controller.isLoginMode.value
                                    ? true
                                    : false,
                                onPressed: () => controller.switchMode(false),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.vertical(context, 0.025),
                      Obx(
                        () => controller.isLoginMode.value
                            ? Form(
                                key: controller.loginFormKey,
                                child: Column(
                                  children: [
                                    AppTextField(
                                      controller:
                                          controller.loginUsernameController,
                                      label: AppTexts.username,
                                      hint: AppTexts.usernameHint,
                                      prefixIcon: Iconsax.user,
                                      validator: controller.validateUsername,
                                      textInputAction: TextInputAction.next,
                                    ),
                                    AppSpacing.vertical(context, 0.015),
                                    AppTextField(
                                      controller:
                                          controller.loginPasswordController,
                                      label: AppTexts.password,
                                      hint: AppTexts.passwordHint,
                                      prefixIcon: Iconsax.lock,
                                      suffixIcon: AppIconButton(
                                        icon: controller.isPasswordVisible.value
                                            ? Iconsax.eye
                                            : Iconsax.eye_slash,
                                        onPressed:
                                            controller.togglePasswordVisibility,
                                        color:
                                            isDark ? AppColors.white : AppColors.black,
                                        backgroundColor: Colors.transparent,
                                      ),
                                      obscureText:
                                          !controller.isPasswordVisible.value,
                                      validator: controller.validatePassword,
                                      textInputAction: TextInputAction.done,
                                    ),
                                    AppSpacing.vertical(context, 0.006),
                                    Row(
                                      children: [
                                        AppCheckbox(
                                          value: controller.rememberMe.value,
                                          label: AppTexts.rememberMe,
                                          onChanged:
                                              controller.toggleRememberMe,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Form(
                                key: controller.signupFormKey,
                                child: Column(
                                  children: [
                                    AppTextField(
                                      controller:
                                          controller.signupUsernameController,
                                      label: AppTexts.username,
                                      hint: AppTexts.usernameHint,
                                      prefixIcon: Iconsax.user,
                                      validator: controller.validateUsername,
                                      textInputAction: TextInputAction.next,
                                    ),
                                    AppSpacing.vertical(context, 0.015),
                                    AppTextField(
                                      controller:
                                          controller.signupPasswordController,
                                      label: AppTexts.password,
                                      hint: AppTexts.passwordHint,
                                      prefixIcon: Iconsax.lock,
                                      suffixIcon: AppIconButton(
                                        icon:
                                            controller
                                                .isSignupPasswordVisible
                                                .value
                                            ? Iconsax.eye
                                            : Iconsax.eye_slash,
                                        onPressed: controller
                                            .toggleSignupPasswordVisibility,
                                        color:
                                            isDark ? AppColors.white : AppColors.black,
                                        backgroundColor: Colors.transparent,
                                      ),
                                      obscureText: !controller
                                          .isSignupPasswordVisible
                                          .value,
                                      validator: controller.validatePassword,
                                      textInputAction: TextInputAction.next,
                                    ),
                                    AppSpacing.vertical(context, 0.015),
                                    AppTextField(
                                      controller: controller
                                          .signupConfirmPasswordController,
                                      label: AppTexts.confirmPassword,
                                      hint: AppTexts.confirmPasswordHint,
                                      prefixIcon: Iconsax.lock,
                                      suffixIcon: AppIconButton(
                                        icon:
                                            controller
                                                .isSignupConfirmPasswordVisible
                                                .value
                                            ? Iconsax.eye
                                            : Iconsax.eye_slash,
                                        onPressed: controller
                                            .toggleSignupConfirmPasswordVisibility,
                                        color:
                                            isDark ? AppColors.white : AppColors.black,
                                        backgroundColor: Colors.transparent,
                                      ),
                                      obscureText: !controller
                                          .isSignupConfirmPasswordVisible
                                          .value,
                                      validator:
                                          controller.validateConfirmPassword,
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      AppSpacing.vertical(context, 0.03),
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          child: AppButton(
                            label: controller.isLoginMode.value
                                ? AppTexts.login
                                : AppTexts.createAccount,
                            isLoading: controller.isLoading.value,
                            onPressed: controller.submit,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.vertical(context, 0.012),
              const AuthFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
