import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_button.dart';
import 'package:today/presentation/controllers/auth/auth_controller.dart';

/// Primary submit button (login or create account) for [AuthScreen].
class AuthSubmitSection extends GetView<AuthController> {
  const AuthSubmitSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
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
    );
  }
}
