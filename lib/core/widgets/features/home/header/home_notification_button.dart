import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/widgets/buttons/app_icon_button.dart';

/// Home header notification control with optional unread indicator.
class HomeNotificationButton extends StatelessWidget {
  const HomeNotificationButton({
    super.key,
    this.onPressed,
    this.hasUnread = false,
    this.size,
  });

  final VoidCallback? onPressed;
  final bool hasUnread;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? AppResponsive.scaleSize(context, 44);
    final badgeSize = AppResponsive.scaleSize(context, 8);
    final palette = context.accentPalette;
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          AppIconButton(
            icon: Iconsax.notification,
            color: AppColors.white,
            onPressed: onPressed,
            backgroundColor: palette.navBar,
            size: AppResponsive.scaleSize(context, 22),
            paddingFactor: 1.5,
          ),
          if (hasUnread)
            Positioned(
              top: buttonSize * 0.18,
              right: buttonSize * 0.18,
              child: Container(
                width: badgeSize,
                height: badgeSize,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
