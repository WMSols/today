import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/features/settings/settings_control_tile.dart';
import 'package:today/core/widgets/features/settings/settings_toggle_row.dart';
import 'package:today/core/widgets/form/app_date_display_field/app_date_display_field.dart';
import 'package:today/core/widgets/form/app_text_field/app_text_field.dart';
import 'package:today/presentation/controllers/planner/create_task_controller.dart';

/// Form fields for [CreateTaskScreen].
class CreateTaskForm extends GetView<CreateTaskController> {
  const CreateTaskForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(
            () => AppDateDisplayField(
              label: AppTexts.createTaskScheduleLabel,
              value: controller.scheduleDisplay,
              placeholder: AppTexts.createTaskSchedulePlaceholder,
              onTap: controller.openSchedulePicker,
              icon: Iconsax.calendar_1,
              required: true,
            ),
          ),
          AppSpacing.vertical(context, 0.02),
          AppTextField(
            controller: controller.titleController,
            label: AppTexts.createTaskTitleLabel,
            hint: AppTexts.createTaskTitleHint,
            required: true,
            validator: controller.validateTitle,
            textInputAction: TextInputAction.next,
          ),
          AppSpacing.vertical(context, 0.02),
          AppTextField(
            controller: controller.notesController,
            label: AppTexts.createTaskNotesLabel,
            hint: AppTexts.createTaskNotesHint,
            maxLines: 4,
            textInputAction: TextInputAction.done,
          ),
          AppSpacing.vertical(context, 0.02),
          Obx(
            () => AppDateDisplayField(
              label: AppTexts.createTaskStartTimeLabel,
              value: controller.startTimeDisplay,
              placeholder: AppTexts.createTaskTimePlaceholder,
              onTap: controller.openStartTimePicker,
              icon: Iconsax.clock,
              required: true,
            ),
          ),
          AppSpacing.vertical(context, 0.02),
          Obx(
            () => AppDateDisplayField(
              label: AppTexts.createTaskEndTimeLabel,
              value: controller.endTimeDisplay,
              placeholder: AppTexts.createTaskTimePlaceholder,
              onTap: controller.openEndTimePicker,
              icon: Iconsax.clock,
              required: true,
            ),
          ),
          AppSpacing.vertical(context, 0.02),
          Obx(
            () => SettingsControlTile(
              title: AppTexts.createTaskRecurringLabel,
              subtitle: AppTexts.createTaskRecurringSubtitle,
              trailing: SettingsToggleRow(
                value: controller.isRecurring.value,
                onChanged: controller.toggleRecurring,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
