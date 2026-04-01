import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:today/core/network/zen_quote_service.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_lotties/app_lotties.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/common/app_custom_app_bar.dart';
import 'package:today/core/widgets/features/home/home_calendar_year_grid.dart';
import 'package:today/core/widgets/features/home/home_daily_quote_view.dart';

class HomeCalendarScreen extends StatefulWidget {
  const HomeCalendarScreen({super.key});

  @override
  State<HomeCalendarScreen> createState() => _HomeCalendarScreenState();
}

class _HomeCalendarScreenState extends State<HomeCalendarScreen> {
  late final Future<({String quote, String author})> _quoteFuture;

  @override
  void initState() {
    super.initState();
    _quoteFuture = const ZenQuoteService().fetchTodayQuote();
  }

  int _dayOfYear(DateTime now) {
    return now.difference(DateTime(now.year, 1, 1)).inDays + 1;
  }

  int _daysInYear(int year) {
    final start = DateTime(year, 1, 1);
    final end = DateTime(year + 1, 1, 1);
    return end.difference(start).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayOfYear = _dayOfYear(now);
    final totalDays = _daysInYear(now.year);
    final daysLeft = totalDays - dayOfYear;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppResponsive.scaleSize(context, 52)),
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.symmetric(context, h: 0.02, v: 0),
            child: AppCustomAppBar.backOnly(onBack: Get.back),
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
                            activeCount: dayOfYear,
                            totalDays: totalDays,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '$daysLeft DAYS LEFT IN ${now.year}',
                                style: AppTextStyles.labelText(context)
                                    .copyWith(
                                      color: AppColors.lightGrey,
                                      fontSize: AppResponsive.scaleSize(
                                        context,
                                        6,
                                      ),
                                      letterSpacing: 0.6,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                          AppSpacing.vertical(context, 0.01),
                        ],
                      ),
                    ),
                    AppSpacing.vertical(context, 0.08),
                    FutureBuilder<({String quote, String author})>(
                      future: _quoteFuture,
                      builder: (context, snapshot) {
                        final data = snapshot.data;
                        if (data == null) {
                          return Center(
                            child: Lottie.asset(
                              AppLotties.loadingWhite,
                              width: AppResponsive.screenWidth(context) * 0.8,
                              height: AppResponsive.screenHeight(context) * 0.1,
                              fit: BoxFit.contain,
                            ),
                          );
                        }
                        return HomeDailyQuoteView(
                          quote: data.quote,
                          author: data.author,
                        );
                      },
                    ),
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
