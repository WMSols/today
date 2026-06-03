import 'package:today/data/datasources/remote/analytics_remote_data_source.dart';
import 'package:today/data/models/analytics_dashboard_model.dart';
import 'package:today/domain/entities/analytics_dashboard_entity.dart';
import 'package:today/domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  const AnalyticsRepositoryImpl(this._remote);

  final AnalyticsRemoteDataSource _remote;

  @override
  Future<AnalyticsDashboardEntity> getDashboard({DateTime? anchor}) async {
    final raw = await _remote.fetchDashboard(anchor: anchor);
    return AnalyticsDashboardModel.fromJson(raw);
  }
}
