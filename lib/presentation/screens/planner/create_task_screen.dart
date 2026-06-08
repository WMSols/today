import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:today/core/extensions/theme_context_extension.dart';

import 'package:today/core/utils/app_spacing/app_spacing.dart';

import 'package:today/core/utils/app_texts/app_texts.dart';

import 'package:today/core/widgets/buttons/app_button.dart';

import 'package:today/core/widgets/common/app_custom_app_bar.dart';

import 'package:today/core/widgets/common/app_page_scaffold.dart';

import 'package:today/core/widgets/features/planner/create_task/create_task_chat_footer.dart';

import 'package:today/core/widgets/features/planner/create_task/create_task_chat_panel.dart';

import 'package:today/core/widgets/features/planner/create_task/create_task_hero_section.dart';

import 'package:today/core/widgets/features/planner/create_task/create_task_mode_tabs.dart';

import 'package:today/core/widgets/features/planner/create_task_form.dart';

import 'package:today/presentation/controllers/planner/create_task_controller.dart';

class CreateTaskScreen extends GetView<CreateTaskController> {
  const CreateTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.updateKeyboardInset(MediaQuery.viewInsetsOf(context).bottom);

    return Scaffold(
      backgroundColor: context.surfaceColor,

      resizeToAvoidBottomInset: false,

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

              const CreateTaskHeroSection(),

              AppSpacing.vertical(context, 0.02),

              CreateTaskModeTabs(
                colors: controller.modeTabColors(
                  Theme.of(context).brightness == Brightness.dark,
                ),
              ),

              AppSpacing.vertical(context, 0.02),

              Expanded(
                child: Obx(
                  () => controller.isManualMode.value
                      ? SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),

                          child: const CreateTaskForm(),
                        )
                      : const CreateTaskChatPanel(),
                ),
              ),

              AppSpacing.vertical(context, 0.02),

              Obx(
                () => controller.isManualMode.value
                    ? AppButton(
                        label: AppTexts.createTaskButton,

                        isLoading: controller.isSubmitting.value,

                        onPressed: controller.isSubmitting.value
                            ? null
                            : controller.onCreateTap,
                      )
                    : const CreateTaskChatFooter(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
