import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_button.dart';
import 'package:today/core/widgets/features/planner/planner_chat_intro.dart';
import 'package:get/get.dart';
import 'package:today/presentation/controllers/planner/planner_controller.dart';

class PlannerScreen extends GetView<PlannerController> {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
          child: Column(
            children: [
              const Expanded(child: PlannerChatIntro()),
              SizedBox(
                width: AppResponsive.screenWidth(context) * 0.8,
                child: AppButton(
                  label: AppTexts.confirm,
                  primary: false,
                  onPressed: controller.onConfirmTap,
                ),
              ),
              AppSpacing.vertical(context, 0.01),
            ],
          ),
        ),
      ),
    );
  }
}
