import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

class AppDropDownButton extends StatelessWidget {
  const AppDropDownButton({
    super.key,
    required this.label,
    required this.items,
    this.value,
    required this.onChanged,
  });

  final String label;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: AppResponsive.scaleSize(context, 10)),
      padding: AppSpacing.symmetric(context, h: 0.02, v: 0.002),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 5),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            label,
            style: AppTextStyles.labelText(context).copyWith(
              color: AppColors.grey,
              fontWeight: FontWeight.w800,
              fontSize: AppResponsive.scaleSize(context, 10),
            ),
          ),
          dropdownColor: AppColors.darkGrey,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.grey,
            size: AppResponsive.iconSize(context),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: AppTextStyles.labelText(context).copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
