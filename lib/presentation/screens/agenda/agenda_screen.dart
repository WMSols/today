import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/widgets/common/app_custom_app_bar.dart';
import 'package:today/core/widgets/common/app_page_scaffold.dart';
import 'package:today/core/widgets/common/app_pull_to_refresh.dart';
import 'package:today/core/widgets/features/agenda/agenda_filter_bar.dart';
import 'package:today/core/widgets/features/agenda/agenda_grouped_list.dart';
import 'package:today/core/widgets/features/agenda/agenda_stats_section.dart';
import 'package:today/core/widgets/feedback/app_loading_indicator.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/presentation/controllers/agenda/agenda_controller.dart';

class AgendaScreen extends GetView<AgendaController> {
  const AgendaScreen({super.key});

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
              Expanded(
                child: AppPullToRefresh(
                  onRefresh: controller.refreshAgenda,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppCustomAppBar.titleWithActions(
                          title: AppTexts.agendaHeading,
                          onBack: Get.back<void>,
                        ),
                        AppSpacing.vertical(context, 0.02),
                        const AgendaStatsSection(),
                        AppSpacing.vertical(context, 0.02),
                        const AgendaFilterBar(),
                        AppSpacing.vertical(context, 0.02),
                        Obx(
                          () => controller.isLoading.value
                              ? Center(
                                  child: AppLoadingIndicator(
                                    width:
                                        AppResponsive.screenWidth(context) *
                                        0.2,
                                    height: AppResponsive.scaleSize(
                                      context,
                                      48,
                                    ),
                                  ),
                                )
                              : const AgendaGroupedList(),
                        ),
                        AppSpacing.vertical(context, 0.02),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
