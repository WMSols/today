import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/theme/app_accent_color.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';

enum PlannerChatAvatarKind { brandLogo, userPhoto }

class PlannerChatAvatar extends StatelessWidget {
  const PlannerChatAvatar({
    super.key,
    this.kind = PlannerChatAvatarKind.userPhoto,
    this.photoUrl,
  });

  final PlannerChatAvatarKind kind;
  final String? photoUrl;

  String? get _resolvedPhotoUrl {
    final explicit = photoUrl?.trim();
    if (explicit != null && explicit.isNotEmpty) return explicit;
    final fromAuth = FirebaseAuth.instance.currentUser?.photoURL?.trim();
    if (fromAuth != null && fromAuth.isNotEmpty) return fromAuth;
    return null;
  }

  String _brandLogoAsset(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (context.accentColor == AppAccentColor.lavendar) {
      return AppImages.appLogoWhite;
    }
    return isDark ? AppImages.appLogoWhite : AppImages.appLogoBlack;
  }

  Widget _userPhotoFallback(BuildContext context, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.accentPalette.fabBackground,
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.person_rounded,
        size: size * 0.55,
        color: context.accentPalette.accent,
      ),
    );
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

    final url = _resolvedPhotoUrl;
    if (url == null) {
      return _userPhotoFallback(context, size);
    }

    return ClipOval(
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _userPhotoFallback(context, size),
      ),
    );
  }
}
