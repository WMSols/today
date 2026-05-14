import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_validator/app_validator.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_icon_button.dart';
import 'package:today/core/widgets/form/app_text_field/app_text_field.dart';
import 'package:today/presentation/controllers/auth/auth_controller.dart';

/// Sign-up email / password / confirm fields for [AuthScreen].
class AuthSignupForm extends GetView<AuthController> {
  const AuthSignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? AppColors.white : AppColors.black;
    return Form(
      key: controller.signupFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: controller.signupEmailController,
            label: AppTexts.email,
            hint: AppTexts.emailHint,
            prefixIcon: Iconsax.sms,
            keyboardType: TextInputType.emailAddress,
            validator: AppValidator.validateEmail,
            textInputAction: TextInputAction.next,
          ),
          AppSpacing.vertical(context, 0.015),
          Obx(
            () => AppTextField(
              controller: controller.signupPasswordController,
              label: AppTexts.password,
              hint: AppTexts.passwordHint,
              prefixIcon: Iconsax.lock,
              suffixIcon: AppIconButton(
                icon: controller.isSignupPasswordVisible.value
                    ? Iconsax.eye
                    : Iconsax.eye_slash,
                onPressed: controller.toggleSignupPasswordVisibility,
                color: iconColor,
                backgroundColor: Colors.transparent,
              ),
              obscureText: !controller.isSignupPasswordVisible.value,
              validator: AppValidator.validatePassword,
              textInputAction: TextInputAction.next,
            ),
          ),
          AppSpacing.vertical(context, 0.015),
          Obx(
            () => AppTextField(
              controller: controller.signupConfirmPasswordController,
              label: AppTexts.confirmPassword,
              hint: AppTexts.confirmPasswordHint,
              prefixIcon: Iconsax.lock,
              suffixIcon: AppIconButton(
                icon: controller.isSignupConfirmPasswordVisible.value
                    ? Iconsax.eye
                    : Iconsax.eye_slash,
                onPressed: controller.toggleSignupConfirmPasswordVisibility,
                color: iconColor,
                backgroundColor: Colors.transparent,
              ),
              obscureText: !controller.isSignupConfirmPasswordVisible.value,
              validator: (value) => AppValidator.validateConfirmPassword(
                value,
                controller.signupPasswordController.text,
              ),
              textInputAction: TextInputAction.done,
            ),
          ),
        ],
      ),
    );
  }
}
