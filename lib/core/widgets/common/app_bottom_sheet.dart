import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';

/// Reusable modal bottom sheet shell with theme surface and keyboard inset.
class AppBottomSheet {
  AppBottomSheet._();

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final mediaQuery = MediaQuery.of(ctx);
        final bottomInset = mediaQuery.viewInsets.bottom;
        final maxHeight = mediaQuery.size.height * 0.55;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: _AppBottomSheetContainer(
              backgroundColor: backgroundColor,
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class _AppBottomSheetContainer extends StatelessWidget {
  const _AppBottomSheetContainer({required this.child, this.backgroundColor});

  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.bottomSheetColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppResponsive.scaleSize(context, 20)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: child,
          ),
        ),
      ),
    );
  }
}
