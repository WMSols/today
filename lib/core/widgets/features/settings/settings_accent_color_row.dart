import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/theme/app_accent_color.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/presentation/controllers/settings/accent_color_controller.dart';

/// Accent swatch picker used as the trailing control on [SettingsControlTile].
class SettingsAccentColorRow extends StatelessWidget {
  const SettingsAccentColorRow({super.key});

  static const _selectable = [AppAccentColor.classic, AppAccentColor.lavendar];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccentColorController>(
      builder: (accentCtrl) {
        final selected = accentCtrl.accent;
        return Wrap(
          spacing: AppResponsive.scaleSize(context, 8),
          runSpacing: AppResponsive.scaleSize(context, 6),
          alignment: WrapAlignment.end,
          children: [
            for (final option in _selectable)
              _AccentSwatch(
                option: option,
                isSelected: selected == option,
                onTap: () => accentCtrl.setAccent(option),
              ),
          ],
        );
      },
    );
  }
}

class _AccentSwatch extends StatelessWidget {
  const _AccentSwatch({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final AppAccentColor option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = AppResponsive.scaleSize(context, 28);
    final ring = context.onSectionCardColor;

    return Semantics(
      button: true,
      selected: isSelected,
      label: _labelFor(option),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? ring : Colors.transparent,
              width: isSelected ? 2 : 0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: ring.withValues(alpha: 0.25),
                      blurRadius: 5,
                      spreadRadius: 5,
                    ),
                  ]
                : null,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: option.isClassic ? null : option.color,
              gradient: option.isClassic ? _classicGradient : null,
            ),
          ),
        ),
      ),
    );
  }

  static String _labelFor(AppAccentColor option) => switch (option) {
    AppAccentColor.classic => AppTexts.settingsAccentClassic,
    AppAccentColor.lavendar => AppTexts.settingsAccentLavendar,
  };

  static const _classicGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF000000), Color(0xFFFFFFFF)],
  );
}
