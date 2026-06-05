import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/widgets/features/onboarding/initial_plan_goal_snippet_chip.dart';
import 'package:today/presentation/controllers/onboarding/create_initial_plan_controller.dart';

class InitialPlanGoalSnippets extends GetView<CreateInitialPlanController> {
  const InitialPlanGoalSnippets({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final expanded = controller.snippetsExpanded.value;
      final spacing = controller.snippetSpacing(context);
      final enabled = !controller.isSubmitting.value;

      return LayoutBuilder(
        builder: (context, constraints) {
          final labels = controller.snippetLabelsFor(
            context,
            constraints.maxWidth,
          );
          final wrap = Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: labels
                .map(
                  (label) => InitialPlanGoalSnippetChip(
                    label: label,
                    enabled: enabled,
                    onTap: () => controller.onSnippetChipTap(label),
                  ),
                )
                .toList(),
          );

          if (!expanded) return wrap;

          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: AppSpacing.verticalValue(context, 0.22),
            ),
            child: SingleChildScrollView(child: wrap),
          );
        },
      );
    });
  }
}
