import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/widgets/buttons/app_button.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/presentation/controllers/auth/auth_controller.dart';

/// Login / Sign up segmented controls for [AuthScreen].
class AuthModeTabs extends GetView<AuthController> {
  const AuthModeTabs({super.key, required this.colors});

  final AppButtonColors colors;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: AppButton(
              label: AppTexts.login,
              primary: controller.isLoginMode.value,
              colors: colors,
              onPressed: () => controller.switchMode(true),
            ),
          ),
          AppSpacing.horizontal(context, 0.02),
          Expanded(
            child: AppButton(
              label: AppTexts.signUp,
              primary: !controller.isLoginMode.value,
              colors: colors,
              onPressed: () => controller.switchMode(false),
            ),
          ),
        ],
      ),
    );
  }
}
