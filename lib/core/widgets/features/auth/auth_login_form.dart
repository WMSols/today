import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_validator/app_validator.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/features/auth/auth_password_field.dart';
import 'package:today/core/widgets/form/app_checkbox/app_checkbox.dart';
import 'package:today/core/widgets/form/app_text_field/app_text_field.dart';
import 'package:today/presentation/controllers/auth/auth_controller.dart';
import 'package:iconsax/iconsax.dart';

/// Login email / password fields and remember-me row for [AuthScreen].
class AuthLoginForm extends GetView<AuthController> {
  const AuthLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
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
          AuthPasswordField(
            controller: controller.loginPasswordController,
            label: AppTexts.password,
            hint: AppTexts.passwordHint,
            isVisible: controller.isPasswordVisible,
            onToggleVisibility: controller.togglePasswordVisibility,
            validator: AppValidator.validatePassword,
            textInputAction: TextInputAction.done,
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
