import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

class AppCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppCustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.bottom,
    this.backgroundColor,
    this.automaticallyImplyLeading = true,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final bool automaticallyImplyLeading;

  @override
  Size get preferredSize {
    if (bottom == null) return const Size.fromHeight(kToolbarHeight);
    return Size.fromHeight(kToolbarHeight + bottom!.preferredSize.height);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTextStyles.heading(context).copyWith(color: AppColors.white),
      ),
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: AppColors.white,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      actions: actions,
      bottom: bottom,
      iconTheme: const IconThemeData(color: AppColors.white),
    );
  }
}
