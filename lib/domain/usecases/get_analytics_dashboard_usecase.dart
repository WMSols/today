import 'package:today/domain/entities/analytics_dashboard_entity.dart';
import 'package:today/domain/repositories/analytics_repository.dart';

class GetAnalyticsDashboardUseCase {
  const GetAnalyticsDashboardUseCase(this._repository);

  final AnalyticsRepository _repository;

  Future<AnalyticsDashboardEntity> call({DateTime? anchor}) {
    return _repository.getDashboard(anchor: anchor);
  }
}
