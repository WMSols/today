import 'package:flutter/material.dart';

import 'package:today/core/widgets/common/app_page_scaffold.dart';
import 'package:today/core/widgets/features/settings/settings_body.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPageScaffold(child: SettingsBody());
  }
}
