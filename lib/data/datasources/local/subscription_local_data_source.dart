class SubscriptionLocalDataSource {
  const SubscriptionLocalDataSource();

  Future<List<Map<String, dynamic>>> getPlans() async {
    return const [
      {
        'name': 'Free',
        'subtitle': '3 GOALS • BASIC AI',
        'price': '\$0',
        'perks': [
          'Up to 3 goals active at once',
          '1x gems on every task completed',
          'Basic AI planning assistance',
        ],
      },
      {
        'name': 'Pro',
        'subtitle': '\$34.99 / YEAR - SAVE 40%',
        'price': '\$4.99 / mo',
        'perks': [
          'Up to 8 goals active at once',
          '2x gems on every task completed',
          'Streak freeze and task regeneration',
          'Advanced AI that adapts to your performance',
          'Full progress history and detailed stats',
        ],
      },
      {
        'name': 'Lifetime',
        'subtitle': 'PAY ONCE. OWN FOREVER',
        'price': '\$59.99',
        'perks': [
          'Unlimited active goals',
          'Permanent Pro features with no renewal',
          'Highest AI priority and faster generations',
          'All future premium updates included',
        ],
      },
    ];
  }
}
