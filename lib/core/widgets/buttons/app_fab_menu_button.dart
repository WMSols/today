import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/presentation/controllers/settings/haptics_controller.dart';

/// Expandable FAB on the home tab: full-screen blur when open, logo rotates 45°.
class AppFABMenuButton extends StatefulWidget {
  const AppFABMenuButton({
    super.key,
    required this.onAddGoal,
    this.onRestructureGoal,
  });

  final VoidCallback onAddGoal;

  /// When null, [AppTexts.fabRestructureGoal] is shown disabled.
  final VoidCallback? onRestructureGoal;

  @override
  State<AppFABMenuButton> createState() => _AppFABMenuButtonState();
}

class _AppFABMenuButtonState extends State<AppFABMenuButton>
    with SingleTickerProviderStateMixin {
  static const _animationDuration = Duration(milliseconds: 220);
  static const _openRotationTurns = 0.125;

  bool _isOpen = false;
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _menuSlideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _menuSlideAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    _impact();
    setState(() => _isOpen = !_isOpen);
    if (_isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _close() {
    if (!_isOpen) return;
    setState(() => _isOpen = false);
    _controller.reverse();
  }

  void _impact() {
    if (Get.isRegistered<HapticsController>()) {
      Get.find<HapticsController>().impact();
    }
  }

  void _onAddGoal() {
    _impact();
    _close();
    widget.onAddGoal();
  }

  void _onRestructureGoal() {
    _impact();
    _close();
    widget.onRestructureGoal?.call();
  }

  double _fabBottomInset(BuildContext context) {
    final navBottom = AppResponsive.scaleSize(context, 20);
    final navHeight = AppResponsive.screenHeight(context) * 0.07;
    return navBottom + navHeight + AppResponsive.scaleSize(context, 16);
  }

  @override
  Widget build(BuildContext context) {
    final fabSize = AppResponsive.scaleSize(context, 56);
    final fabBottom = _fabBottomInset(context);
    final fabRight = AppResponsive.scaleSize(context, 20);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scrim = isDark
        ? AppColors.black.withValues(alpha: 0.4)
        : AppColors.white.withValues(alpha: 0.25);

    return Stack(
      fit: StackFit.expand,
      children: [
        IgnorePointer(
          ignoring: !_isOpen,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: GestureDetector(
              onTap: _close,
              behavior: HitTestBehavior.opaque,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: Container(color: scrim),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: fabRight,
          bottom: fabBottom,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.15),
                    end: Offset.zero,
                  ).animate(_menuSlideAnimation),
                  child: IgnorePointer(
                    ignoring: !_isOpen,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _AppFABMenuActionTile(
                          label: AppTexts.fabAddGoal,
                          icon: Iconsax.add_circle,
                          onTap: _onAddGoal,
                        ),
                        AppSpacing.vertical(context, 0.012),
                        _AppFABMenuActionTile(
                          label: AppTexts.fabRestructureGoal,
                          icon: Iconsax.refresh_circle,
                          onTap: widget.onRestructureGoal == null
                              ? null
                              : _onRestructureGoal,
                          enabled: widget.onRestructureGoal != null,
                        ),
                        AppSpacing.vertical(context, 0.016),
                      ],
                    ),
                  ),
                ),
              ),
              _AppFABTrigger(size: fabSize, isOpen: _isOpen, onTap: _toggle),
            ],
          ),
        ),
      ],
    );
  }
}

class _AppFABTrigger extends StatelessWidget {
  const _AppFABTrigger({
    required this.size,
    required this.isOpen,
    required this.onTap,
  });

  final double size;
  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.accentPalette;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logo = isDark ? AppImages.appLogoWhite : AppImages.appLogoBlack;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: palette.fabBackground,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark
                      ? 0.35
                      : 0.12,
                ),
                blurRadius: AppResponsive.scaleSize(context, 12),
                offset: Offset(0, AppResponsive.scaleSize(context, 4)),
              ),
            ],
          ),
          child: Padding(
            padding: AppSpacing.all(context, factor: 1.5),
            child: AnimatedRotation(
              turns: isOpen ? _AppFABMenuButtonState._openRotationTurns : 0,
              duration: _AppFABMenuButtonState._animationDuration,
              curve: Curves.easeOutCubic,
              child: Image.asset(logo, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppFABMenuActionTile extends StatelessWidget {
  const _AppFABMenuActionTile({
    required this.label,
    required this.icon,
    this.onTap,
    this.enabled = true,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final palette = context.accentPalette;
    final onSurface = palette.fabMenuForeground;
    final muted = AppColors.grey;
    final radius = AppResponsive.radius(context, factor: 5);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(radius),
        child: Opacity(
          opacity: enabled ? 1 : 0.45,
          child: Container(
            padding: AppSpacing.symmetric(context, h: 0.035, v: 0.012),
            decoration: BoxDecoration(
              color: palette.fabMenuSurface,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: palette.fabMenuBorder, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.08),
                  blurRadius: AppResponsive.scaleSize(context, 8),
                  offset: Offset(0, AppResponsive.scaleSize(context, 2)),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTextStyles.buttonText(context).copyWith(
                    color: enabled ? onSurface : muted,
                    fontSize: AppResponsive.scaleSize(context, 14),
                  ),
                ),
                AppSpacing.horizontal(context, 0.02),
                Icon(
                  icon,
                  size: AppResponsive.iconSize(context),
                  color: enabled ? onSurface : muted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
