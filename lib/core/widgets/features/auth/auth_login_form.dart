import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_validator/app_validator.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_icon_button.dart';
import 'package:today/core/widgets/form/app_checkbox/app_checkbox.dart';
import 'package:today/core/widgets/form/app_text_field/app_text_field.dart';
import 'package:today/presentation/controllers/auth/auth_controller.dart';

/// Login email / password fields and remember-me row for [AuthScreen].
class AuthLoginForm extends GetView<AuthController> {
  const AuthLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? AppColors.white : AppColors.black;
    return Form(
      key: controller.loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: controller.loginEmailController,
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
              controller: controller.loginPasswordController,
              label: AppTexts.password,
              hint: AppTexts.passwordHint,
              prefixIcon: Iconsax.lock,
              suffixIcon: AppIconButton(
                icon: controller.isPasswordVisible.value
                    ? Iconsax.eye
                    : Iconsax.eye_slash,
                onPressed: controller.togglePasswordVisibility,
                color: iconColor,
                backgroundColor: Colors.transparent,
              ),
              obscureText: !controller.isPasswordVisible.value,
              validator: AppValidator.validatePassword,
              textInputAction: TextInputAction.done,
            ),
          ),
          AppSpacing.vertical(context, 0.006),
          Obx(
            () => AppCheckbox(
              value: controller.rememberMe.value,
              label: AppTexts.rememberMe,
              onChanged: controller.toggleRememberMe,
            ),
          ),
        ],
      ),
    );
  }
}
