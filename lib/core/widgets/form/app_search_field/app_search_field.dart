import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/form/app_form_field_label/app_form_field_label.dart';
import 'package:today/core/widgets/form/app_input_decoration/app_input_decoration.dart';

/// Search field with same styling and API as [AppTextField].
/// Defaults: search prefix icon, [TextInputAction.search].
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.prefixIcon = Iconsax.search_normal_1,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction = TextInputAction.search,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.inputFormatters,
    this.readOnly = false,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppFormFieldLabel(label: label),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          autovalidateMode: autovalidateMode,
          onChanged: onChanged,
          onFieldSubmitted: (v) {
            if (textInputAction == TextInputAction.next) {
              FocusScope.of(context).nextFocus();
            }
            onSubmitted?.call(v);
          },
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          decoration: AppInputDecoration.decoration(
            context,
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
          style: AppTextStyles.bodyText(context),
        ),
      ],
    );
  }
}
