import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.labelColor,
    this.borderColor,
    this.checkColor,
    this.backgroundColor,
  });

  final bool value;
  final String? label;
  final ValueChanged<bool?>? onChanged;
  final Color? labelColor;
  final Color? borderColor;
  final Color? checkColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderAndLabel =
        borderColor ?? (isDark ? AppColors.white : AppColors.black);
    final fillColor = backgroundColor ?? borderAndLabel;
    final checkbox = Checkbox(
      value: value,
      onChanged: onChanged,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 5),
        ),
      ),
      side: BorderSide(color: borderAndLabel),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return fillColor;
        }
        return Colors.transparent;
      }),
      checkColor: checkColor ?? (isDark ? AppColors.black : AppColors.white),
    );

    if (label == null) {
      return checkbox;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        checkbox,
        Text(
          label!,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.labelText(
            context,
          ).copyWith(color: labelColor ?? borderAndLabel),
        ),
      ],
    );
  }
}
