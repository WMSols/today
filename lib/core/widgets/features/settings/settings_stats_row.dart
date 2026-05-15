import 'package:flutter/material.dart';

import 'package:today/core/widgets/common/app_labeled_value_row.dart';

class SettingsStatsRow extends StatelessWidget {
  const SettingsStatsRow({
    super.key,
    required this.iconPath,
    required this.label,
    required this.value,
  });

  final String iconPath;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppLabeledValueRow(iconPath: iconPath, label: label, value: value);
  }
}
