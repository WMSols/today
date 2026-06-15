import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';

/// Circular user avatar from Firebase [photoUrl] or [FirebaseAuth] with icon fallback.
class AppUserProfileImage extends StatelessWidget {
  const AppUserProfileImage({
    super.key,
    required this.size,
    this.photoUrl,
    this.onTap,
  });

  final double size;
  final String? photoUrl;
  final VoidCallback? onTap;

  String? get _resolvedPhotoUrl {
    final explicit = photoUrl?.trim();
    if (explicit != null && explicit.isNotEmpty) return explicit;
    final fromAuth = FirebaseAuth.instance.currentUser?.photoURL?.trim();
    if (fromAuth != null && fromAuth.isNotEmpty) return fromAuth;
    return null;
  }

  Widget _fallback(BuildContext context) {
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
        size: size * 0.5,
        color: context.accentPalette.accent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = _resolvedPhotoUrl;
    final Widget avatar;
    if (url != null) {
      avatar = ClipOval(
        child: Image.network(
          url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _fallback(context),
        ),
      );
    } else {
      avatar = _fallback(context);
    }

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
