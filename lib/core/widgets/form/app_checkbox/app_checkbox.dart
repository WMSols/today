import 'package:flutter/material.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
  });

  final bool value;
  final String label;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.white,
          checkColor: AppColors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, factor: 5),
            ),
          ),
          side: const BorderSide(color: AppColors.white),
        ),
        Text(
          label,
          style: AppTextStyles.labelText(context).copyWith(color: AppColors.white),
        ),
      ],
    );
  }
}
