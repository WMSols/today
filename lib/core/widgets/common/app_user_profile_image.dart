import 'package:flutter/material.dart';

import 'package:today/core/utils/app_images/app_images.dart';

/// Circular user avatar: network [photoUrl] with [imagePath] fallback.
class AppUserProfileImage extends StatelessWidget {
  const AppUserProfileImage({
    super.key,
    required this.size,
    this.imagePath = AppImages.userProfile,
    this.photoUrl,
    this.onTap,
  });

  final double size;
  final String imagePath;
  final String? photoUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final url = photoUrl?.trim();
    final Widget image;
    if (url != null && url.isNotEmpty) {
      image = Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Image.asset(
          imagePath,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    } else {
      image = Image.asset(
        imagePath,
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }

    final avatar = ClipOval(child: image);

    if (onTap == null) return avatar;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: avatar,
      ),
    );
  }
}
