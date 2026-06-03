import 'package:today/domain/entities/analytics_dashboard_entity.dart';

abstract class AnalyticsRepository {
  Future<AnalyticsDashboardEntity> getDashboard({DateTime? anchor});
}
