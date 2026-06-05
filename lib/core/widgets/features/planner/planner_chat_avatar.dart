import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/theme/app_accent_color.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';

enum PlannerChatAvatarKind { image, brandLogo }

class PlannerChatAvatar extends StatelessWidget {
  const PlannerChatAvatar({
    super.key,
    this.imagePath,
    this.kind = PlannerChatAvatarKind.image,
  }) : assert(
         kind == PlannerChatAvatarKind.brandLogo || imagePath != null,
         'imagePath is required for image avatars',
       );

  final String? imagePath;
  final PlannerChatAvatarKind kind;

  String _brandLogoAsset(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (context.accentColor == AppAccentColor.lavendar) {
      return AppImages.appLogoWhite;
    }
    return isDark ? AppImages.appLogoWhite : AppImages.appLogoBlack;
  }

  @override
  Widget build(BuildContext context) {
    final size = AppResponsive.scaleSize(context, 28);

    if (kind == PlannerChatAvatarKind.brandLogo) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.accentPalette.fabBackground,
        ),
        padding: EdgeInsets.all(AppResponsive.scaleSize(context, 4)),
        child: Image.asset(_brandLogoAsset(context), fit: BoxFit.contain),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.surfaceColor,
        image: DecorationImage(
          image: AssetImage(imagePath!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
