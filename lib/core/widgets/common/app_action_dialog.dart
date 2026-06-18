import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_button.dart';
import 'package:today/core/widgets/form/app_text_field/app_text_field.dart';

enum _AppActionDialogConfirmKind { save, delete }

/// Themed confirm / input dialog used for calendar actions and similar flows.
class AppActionDialog {
  AppActionDialog._();

  static Future<bool> showConfirm(
    BuildContext context, {
    required String title,
    required String subtitle,
    String confirmLabel = AppTexts.delete,
    String cancelLabel = AppTexts.cancel,
    Future<bool> Function()? onConfirm,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => _AppActionConfirmDialog(
        title: title,
        subtitle: subtitle,
        cancelLabel: cancelLabel,
        confirmLabel: confirmLabel,
        onConfirm: onConfirm,
      ),
    );
    return result ?? false;
  }

  /// Returns `false` for this occurrence, `true` for entire series, `null` if cancelled.
  static Future<bool?> showRecurringScope(
    BuildContext context, {
    required String title,
    required String subtitle,
    String seriesLabel = AppTexts.updateSeriesLabel,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => _AppActionRecurringScopeDialog(
        title: title,
        subtitle: subtitle,
        seriesLabel: seriesLabel,
      ),
    );
  }

  static Future<String?> showTextInput(
    BuildContext context, {
    required String title,
    String? subtitle,
    required String initialValue,
    String? hint,
    String confirmLabel = AppTexts.save,
    String cancelLabel = AppTexts.cancel,
    Future<bool> Function(String value)? onSubmit,
  }) {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => _AppActionTextInputDialog(
        title: title,
        subtitle: subtitle ?? AppTexts.editEventSubtitle,
        initialValue: initialValue,
        hint: hint ?? AppTexts.editEventHint,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onSubmit: onSubmit,
      ),
    );
  }

  static AppButtonColors _confirmButtonColors(
    _AppActionDialogConfirmKind kind,
  ) {
    final background = kind == _AppActionDialogConfirmKind.delete
        ? AppColors.warning
        : AppColors.information;

    return AppButtonColors(
      filledBackground: background,
      filledForeground: AppColors.white,
      outlinedBackground: Colors.transparent,
      outlinedForeground: background,
      outlinedBorder: background,
    );
  }

  static List<Widget> _dialogActions(
    BuildContext context, {
    required bool isLoading,
    required String cancelLabel,
    required String confirmLabel,
    required _AppActionDialogConfirmKind confirmKind,
    required VoidCallback? onCancel,
    required VoidCallback? onConfirm,
  }) {
    return [
      AppButton(
        label: cancelLabel,
        primary: false,
        size: AppButtonSize.small,
        preserveStyleWhenDisabled: true,
        onPressed: isLoading ? null : onCancel,
      ),
      AppButton(
        label: confirmLabel,
        primary: true,
        size: AppButtonSize.small,
        isLoading: isLoading,
        useAccentPalette: false,
        colors: _confirmButtonColors(confirmKind),
        onPressed: isLoading ? null : onConfirm,
      ),
    ];
  }
}

class _AppActionDialogActions extends StatelessWidget {
  const _AppActionDialogActions({required this.actions});

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.horizontalValue(context, 0.02),
      runSpacing: AppSpacing.verticalValue(context, 0.012),
      children: actions,
    );
  }
}

class _AppActionDialogShell extends StatelessWidget {
  const _AppActionDialogShell({
    required this.title,
    required this.subtitle,
    required this.canDismiss,
    required this.actions,
    this.child,
  });

  final String title;
  final String subtitle;
  final bool canDismiss;
  final Widget? child;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: canDismiss,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: AppSpacing.symmetric(context, h: 0.06, v: 0.08),
        child: Container(
          width: double.infinity,
          padding: AppSpacing.symmetric(context, h: 0.04, v: 0.03),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, factor: 3),
            ),
            border: Border.all(
              color: context.onSurfaceColor.withValues(
                alpha: isDark ? 0.14 : 0.1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.42 : 0.14),
                blurRadius: AppResponsive.scaleSize(context, 24),
                offset: Offset(0, AppResponsive.scaleSize(context, 10)),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _AppActionDialogHeader(
                title: title,
                subtitle: subtitle,
                logoAsset: isDark
                    ? AppImages.appLogoWhite
                    : AppImages.appLogoBlack,
              ),
              if (child != null) ...[
                AppSpacing.vertical(context, 0.02),
                child!,
              ],
              AppSpacing.vertical(context, 0.024),
              _AppActionDialogActions(actions: actions),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppActionDialogHeader extends StatelessWidget {
  const _AppActionDialogHeader({
    required this.title,
    required this.subtitle,
    required this.logoAsset,
  });

  final String title;
  final String subtitle;
  final String logoAsset;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Image.asset(
            logoAsset,
            height: AppResponsive.scaleSize(context, 44),
          ),
        ),
        AppSpacing.vertical(context, 0.016),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyText(context).copyWith(
            color: context.onSurfaceColor,
            fontWeight: FontWeight.w600,
            fontSize: AppResponsive.scaleSize(context, 16),
          ),
        ),
        AppSpacing.vertical(context, 0.005),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyText(context).copyWith(
            color: context.onSurfaceColor,
            fontSize: AppResponsive.scaleSize(context, 14),
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _AppActionConfirmDialog extends StatefulWidget {
  const _AppActionConfirmDialog({
    required this.title,
    required this.subtitle,
    required this.cancelLabel,
    required this.confirmLabel,
    this.onConfirm,
  });

  final String title;
  final String subtitle;
  final String cancelLabel;
  final String confirmLabel;
  final Future<bool> Function()? onConfirm;

  @override
  State<_AppActionConfirmDialog> createState() => _AppActionConfirmDialogState();
}

class _AppActionConfirmDialogState extends State<_AppActionConfirmDialog> {
  bool _isLoading = false;

  Future<void> _handleConfirm() async {
    if (_isLoading) return;

    final handler = widget.onConfirm;
    if (handler == null) {
      Navigator.of(context).pop(true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final success = await handler();
      if (!mounted) return;
      if (success) {
        Navigator.of(context).pop(true);
        return;
      }
      setState(() => _isLoading = false);
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AppActionDialogShell(
      title: widget.title,
      subtitle: widget.subtitle,
      canDismiss: !_isLoading,
      actions: AppActionDialog._dialogActions(
        context,
        isLoading: _isLoading,
        cancelLabel: widget.cancelLabel,
        confirmLabel: widget.confirmLabel,
        confirmKind: _AppActionDialogConfirmKind.delete,
        onCancel: _isLoading ? null : () => Navigator.of(context).pop(false),
        onConfirm: _handleConfirm,
      ),
    );
  }
}

class _AppActionTextInputDialog extends StatefulWidget {
  const _AppActionTextInputDialog({
    required this.title,
    required this.subtitle,
    required this.initialValue,
    required this.hint,
    required this.confirmLabel,
    required this.cancelLabel,
    this.onSubmit,
  });

  final String title;
  final String subtitle;
  final String initialValue;
  final String hint;
  final String confirmLabel;
  final String cancelLabel;
  final Future<bool> Function(String value)? onSubmit;

  @override
  State<_AppActionTextInputDialog> createState() =>
      _AppActionTextInputDialogState();
}

class _AppActionTextInputDialogState extends State<_AppActionTextInputDialog> {
  late final TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isLoading) return;

    final value = _controller.text.trim();
    if (value.isEmpty) return;

    final handler = widget.onSubmit;
    if (handler == null) {
      Navigator.of(context).pop(value);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final success = await handler(value);
      if (!mounted) return;
      if (success) {
        Navigator.of(context).pop(value);
        return;
      }
      setState(() => _isLoading = false);
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AppActionDialogShell(
      title: widget.title,
      subtitle: widget.subtitle,
      canDismiss: !_isLoading,
      actions: AppActionDialog._dialogActions(
        context,
        isLoading: _isLoading,
        cancelLabel: widget.cancelLabel,
        confirmLabel: widget.confirmLabel,
        confirmKind: _AppActionDialogConfirmKind.save,
        onCancel: _isLoading ? null : () => Navigator.of(context).pop(),
        onConfirm: _submit,
      ),
      child: AppTextField(
        controller: _controller,
        hint: widget.hint,
        readOnly: _isLoading,
        textInputAction: TextInputAction.done,
        onSubmitted: _isLoading ? null : (_) => _submit(),
      ),
    );
  }
}

class _AppActionRecurringScopeDialog extends StatelessWidget {
  const _AppActionRecurringScopeDialog({
    required this.title,
    required this.subtitle,
    required this.seriesLabel,
  });

  final String title;
  final String subtitle;
  final String seriesLabel;

  @override
  Widget build(BuildContext context) {
    return _AppActionDialogShell(
      title: title,
      subtitle: subtitle,
      canDismiss: true,
      actions: [
        AppButton(
          label: AppTexts.cancel,
          primary: false,
          size: AppButtonSize.small,
          onPressed: () => Navigator.of(context).pop(),
        ),
        AppButton(
          label: AppTexts.thisEventOnlyLabel,
          primary: true,
          size: AppButtonSize.small,
          useAccentPalette: false,
          colors: AppActionDialog._confirmButtonColors(
            _AppActionDialogConfirmKind.save,
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        AppButton(
          label: seriesLabel,
          primary: true,
          size: AppButtonSize.small,
          useAccentPalette: false,
          colors: AppActionDialog._confirmButtonColors(
            _AppActionDialogConfirmKind.delete,
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
