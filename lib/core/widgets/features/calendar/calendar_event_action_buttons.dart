import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/widgets/buttons/app_icon_button.dart';

class CalendarEventActionButtons extends StatelessWidget {
  const CalendarEventActionButtons({
    super.key,
    required this.onEdit,
    required this.onDelete,
    required this.onComplete,
    required this.onSkip,
  });

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback onComplete;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final iconSize = AppResponsive.scaleSize(context, 18);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIconButton(
          icon: Icons.check,
          onPressed: onComplete,
          size: iconSize,
          backgroundColor: AppColors.success,
          color: AppColors.white,
          useAccentPalette: false,
        ),
        AppSpacing.horizontal(context, 0.02),
        AppIconButton(
          icon: Iconsax.next,
          onPressed: onSkip,
          size: iconSize,
          backgroundColor: AppColors.warning,
          color: AppColors.white,
          useAccentPalette: false,
        ),
        AppSpacing.horizontal(context, 0.02),
        AppIconButton(
          icon: Iconsax.edit_2,
          onPressed: onEdit,
          size: iconSize,
          backgroundColor: AppColors.information,
          color: AppColors.white,
          useAccentPalette: false,
        ),
        AppSpacing.horizontal(context, 0.02),
        AppIconButton(
          icon: Iconsax.trash,
          onPressed: onDelete,
          size: iconSize,
          backgroundColor: AppColors.error,
          color: AppColors.white,
          useAccentPalette: false,
        ),
      ],
    );
  }
}
