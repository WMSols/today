import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/form/app_form_field_label/app_form_field_label.dart';
import 'package:today/core/widgets/form/app_input_decoration/app_input_decoration.dart';

/// Reusable tap-to-pick date/time display field. Shows [label], [value] or
/// [placeholder] when empty, and triggers [onTap] (e.g. open date picker).
/// Uses same decoration as AppTextField and AppDropdownField.
class AppDateDisplayField extends StatelessWidget {
  const AppDateDisplayField({
    super.key,
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
    this.icon,
    this.required = false,
  });

  final String label;
  final String value;
  final String placeholder;
  final VoidCallback onTap;
  final IconData? icon;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final display = value.isEmpty ? placeholder : value;
    final isEmpty = value.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppFormFieldLabel(label: label, required: required),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
          child: InputDecorator(
            decoration: AppInputDecoration.decoration(
              context,
              prefixIcon: icon ?? Iconsax.calendar_1,
            ),
            child: Text(
              display,
              style: isEmpty
                  ? AppTextStyles.hintText(context)
                  : AppTextStyles.bodyText(context),
            ),
          ),
        ),
      ],
    );
  }
}
