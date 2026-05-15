import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/widgets/buttons/app_icon_button.dart';
import 'package:today/core/widgets/form/app_text_field/app_text_field.dart';

class AuthPasswordField extends StatelessWidget {
  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.isVisible,
    required this.onToggleVisibility,
    required this.validator,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final RxBool isVisible;
  final VoidCallback onToggleVisibility;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppTextField(
        controller: controller,
        label: label,
        hint: hint,
        prefixIcon: Iconsax.lock,
        suffixIcon: AppIconButton(
          icon: isVisible.value ? Iconsax.eye : Iconsax.eye_slash,
          onPressed: onToggleVisibility,
          color: context.onSurfaceColor,
          backgroundColor: Colors.transparent,
        ),
        obscureText: !isVisible.value,
        validator: validator,
        textInputAction: textInputAction ?? TextInputAction.done,
      ),
    );
  }
}
