import 'package:today/core/utils/app_texts/app_texts.dart';

class SubscriptionLocalDataSource {
  const SubscriptionLocalDataSource();

  Future<List<Map<String, dynamic>>> getPlans() async {
    return [
      {
        'name': AppTexts.subscriptionPlanFreeName,
        'subtitle': AppTexts.subscriptionPlanFreeSubtitle,
        'price': AppTexts.subscriptionPriceFree,
        'perks': List<String>.from(AppTexts.subscriptionFreePerks),
      },
      {
        'name': AppTexts.subscriptionPlanProName,
        'subtitle': AppTexts.subscriptionPlanProSubtitle,
        'price': AppTexts.subscriptionPriceProMonthly,
        'perks': List<String>.from(AppTexts.subscriptionProPerks),
      },
      {
        'name': AppTexts.subscriptionPlanLifetimeName,
        'subtitle': AppTexts.subscriptionPlanLifetimeSubtitle,
        'price': AppTexts.subscriptionPriceLifetime,
        'perks': List<String>.from(AppTexts.subscriptionLifetimePerks),
      },
    ];
  }
}
