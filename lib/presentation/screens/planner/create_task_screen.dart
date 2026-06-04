import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_button.dart';
import 'package:today/core/widgets/common/app_brand_logo.dart';
import 'package:today/core/widgets/common/app_custom_app_bar.dart';
import 'package:today/core/widgets/common/app_page_scaffold.dart';
import 'package:today/core/widgets/features/planner/create_task_form.dart';
import 'package:today/presentation/controllers/planner/create_task_controller.dart';

class CreateTaskScreen extends GetView<CreateTaskController> {
  const CreateTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceColor,
      body: SafeArea(
        child: Padding(
          padding: AppPageScaffold.defaultBodyPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCustomAppBar.titleWithActions(
                title: AppTexts.createTaskHeading,
                onBack: Get.back<void>,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const AppBrandLogo(heightFactor: 0.1),
                      AppSpacing.vertical(context, 0.02),
                      const CreateTaskForm(),
                    ],
                  ),
                ),
              ),
              AppSpacing.vertical(context, 0.015),
              Obx(
                () => AppButton(
                  label: AppTexts.createTaskButton,
                  isLoading: controller.isSubmitting.value,
                  onPressed: controller.isSubmitting.value
                      ? null
                      : controller.onCreateTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
