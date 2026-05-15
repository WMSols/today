import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';

/// Standard full-screen scaffold: themed background, [SafeArea], optional padding.
class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.child,
    this.padding,
    this.appBar,
    this.scrollable = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final PreferredSizeWidget? appBar;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    Widget body = child;
    if (padding != null) {
      body = Padding(padding: padding!, child: body);
    }
    if (scrollable) {
      body = SingleChildScrollView(child: body);
    }

    return Scaffold(
      backgroundColor: context.surfaceColor,
      appBar: appBar,
      body: SafeArea(child: body),
    );
  }

  /// Default horizontal screen padding used by tab bodies and standalone routes.
  static EdgeInsets defaultBodyPadding(BuildContext context) {
    return AppSpacing.symmetric(context, h: 0.04, v: 0.02);
  }
}
