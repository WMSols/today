import 'package:flutter/material.dart';

import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/widgets/features/home/home_active_goals_section.dart';
import 'package:today/core/widgets/features/home/home_goal_entry_card.dart';
import 'package:today/core/widgets/features/home/home_top_header.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key, required this.onDateTap, required this.onGoalTap});

  final VoidCallback onDateTap;
  final VoidCallback onGoalTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeTopHeader(onDateTap: onDateTap),
          AppSpacing.vertical(context, 0.02),
          const HomeGoalEntryCard(),
          AppSpacing.vertical(context, 0.018),
          HomeActiveGoalsSection(onGoalTap: onGoalTap),
          AppSpacing.vertical(context, 0.1),
        ],
      ),
    );
  }
}
