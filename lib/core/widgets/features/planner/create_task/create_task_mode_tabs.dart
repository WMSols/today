import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_button.dart';
import 'package:today/presentation/controllers/planner/create_task_controller.dart';

/// Manual / Chat segmented controls for [CreateTaskScreen].
class CreateTaskModeTabs extends GetView<CreateTaskController> {
  const CreateTaskModeTabs({super.key, required this.colors});

  final AppButtonColors colors;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: AppButton(
              label: AppTexts.createTaskModeManual,
              primary: controller.isManualMode.value,
              colors: colors,
              onPressed: () => controller.switchMode(true),
              size: AppButtonSize.medium,
            ),
          ),
          AppSpacing.horizontal(context, 0.02),
          Expanded(
            child: AppButton(
              label: AppTexts.createTaskModeChat,
              primary: !controller.isManualMode.value,
              colors: colors,
              onPressed: () => controller.switchMode(false),
              size: AppButtonSize.medium,
            ),
          ),
        ],
      ),
    );
  }
}
