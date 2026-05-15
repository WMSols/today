import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_custom_app_bar.dart';
import 'package:today/core/widgets/feedback/app_loading_indicator.dart';
import 'package:today/core/widgets/features/home/home_calendar_year_grid.dart';
import 'package:today/core/widgets/features/home/home_daily_quote_view.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';

class HomeCalendarScreen extends GetView<HomeController> {
  const HomeCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.ensureCalendarQuoteLoaded();
    final calendar = controller.calendarDisplay;

    return Scaffold(
      backgroundColor: context.surfaceColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppResponsive.scaleSize(context, 52)),
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.symmetric(context, h: 0.02, v: 0),
            child: AppCustomAppBar.backOnly(onBack: Get.back<void>),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          HomeCalendarYearGrid(
                            activeCount: calendar.dayOfYear,
                            totalDays: calendar.totalDays,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                AppTexts.calendarDaysLeftInYear(
                                  calendar.daysLeft,
                                  calendar.year,
                                ),
                                style: AppTextStyles.labelText(context)
                                    .copyWith(
                                      color: context.onSurfaceColor,
                                      fontSize: AppResponsive.scaleSize(
                                        context,
                                        6,
                                      ),
                                      letterSpacing: 0.6,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                          AppSpacing.vertical(context, 0.01),
                        ],
                      ),
                    ),
                    AppSpacing.vertical(context, 0.08),
                    Obx(() {
                      final quote = controller.calendarQuote.value;
                      if (controller.isCalendarQuoteLoading.value ||
                          quote == null) {
                        return Center(
                          child: AppLoadingIndicator(
                            width: AppResponsive.screenWidth(context) * 0.8,
                            height: AppResponsive.screenHeight(context) * 0.1,
                          ),
                        );
                      }
                      return HomeDailyQuoteView(
                        quote: quote.quote,
                        author: quote.author,
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
