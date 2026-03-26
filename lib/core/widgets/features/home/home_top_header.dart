import 'package:flutter/material.dart';

import 'package:today/core/widgets/common/app_custom_app_bar.dart';

class HomeTopHeader extends StatelessWidget {
  const HomeTopHeader({
    super.key,
    required this.onDateTap,
  });

  final VoidCallback onDateTap;

  @override
  Widget build(BuildContext context) {
    return AppCustomAppBar.homeStatus(
      now: DateTime.now(),
      onTapDate: onDateTap,
    );
  }
}
