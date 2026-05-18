import 'package:dio/dio.dart';

import 'package:today/core/constants/api_constants.dart';

class PlannerRemoteDataSource {
  const PlannerRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<Map<String, dynamic>>> fetchTodayPlan() async {
    if (!ApiConstants.backendApiEnabled) {
      return <Map<String, dynamic>>[];
    }
    // Wire actual endpoint when backend contracts are finalized.
    // final response = await _dio.get<Map<String, dynamic>>(...);
    final _ = _dio;
    return <Map<String, dynamic>>[];
  }
}
