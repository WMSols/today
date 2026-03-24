import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/form/app_form_field_label/app_form_field_label.dart';
import 'package:today/core/widgets/form/app_input_decoration/app_input_decoration.dart';

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    this.label,
    this.hint,
    this.required = false,
    this.prefixIcon,
    this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.getLabel,
  });

  final String? label;
  final String? hint;
  final bool required;
  final IconData? prefixIcon;
  final T? value;
  final List<T> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final AutovalidateMode autovalidateMode;
  final String Function(T)? getLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppFormFieldLabel(label: label, required: required),
        DropdownButtonFormField<T>(
          isExpanded: true,
          autovalidateMode: autovalidateMode,
          // ignore: deprecated_member_use
          value: value,
          hint: hint != null
              ? Text(hint!, style: AppTextStyles.hintText(context))
              : null,
          items: items
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(
                    getLabel != null ? getLabel!(e) : e.toString(),
                    style: AppTextStyles.bodyText(context),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          validator: validator,
          decoration: AppInputDecoration.decoration(
            context,
            prefixIcon: prefixIcon,
          ),
          icon: Icon(
            Iconsax.arrow_down_1,
            size: AppResponsive.iconSize(context),
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
