import 'package:dio/dio.dart';

class PlannerRemoteDataSource {
  const PlannerRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<Map<String, dynamic>>> fetchTodayPlan() async {
    // Wire actual endpoint when backend contracts are finalized.
    final _ = _dio;
    return <Map<String, dynamic>>[];
  }
}
