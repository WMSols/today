import 'package:flutter/material.dart';

import 'package:today/core/utils/app_spacing/app_spacing.dart';

class OnboardingPageShell extends StatelessWidget {
  const OnboardingPageShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.symmetric(context, h: 0.06, v: 0.04),
      child: child,
    );
  }
}
