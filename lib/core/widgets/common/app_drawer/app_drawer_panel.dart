import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';

class AppDrawerPanel extends StatelessWidget {
  const AppDrawerPanel({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.surfaceColor,
      child: SafeArea(
        left: false,
        child: Padding(
          padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
          child: child,
        ),
      ),
    );
  }
}
