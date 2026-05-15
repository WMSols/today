import 'package:flutter/material.dart';

import 'package:today/core/widgets/common/app_page_scaffold.dart';
import 'package:today/core/widgets/features/goals/goals_body.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPageScaffold(child: GoalsBody());
  }
}
