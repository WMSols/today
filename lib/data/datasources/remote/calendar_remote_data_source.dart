import 'package:dio/dio.dart';

import 'package:today/core/constants/api_constants.dart';
import 'package:today/core/network/api_stubs.dart';
import 'package:today/core/utils/app_formatter/app_formatter.dart';
import 'package:today/domain/entities/create_calendar_event_params.dart';
import 'package:today/domain/entities/update_calendar_event_params.dart';

class CalendarRemoteDataSource {
  const CalendarRemoteDataSource(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> sendChatMessage({
    required String message,
  }) async {
    if (!ApiConstants.backendApiEnabled) {
      return ApiStubs.calendarChat(message: message);
    }
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.chatPath,
      data: <String, dynamic>{'message': message},
    );
    return response.data ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> getAgenda({
    required DateTime from,
    required DateTime to,
  }) async {
    if (!ApiConstants.backendApiEnabled) {
      return ApiStubs.calendarAgenda();
    }
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.calendarAgendaPath,
      queryParameters: <String, dynamic>{
        'from': AppFormatter.apiDate(from),
        'to': AppFormatter.apiDate(to),
      },
    );
    return response.data ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> createEvent(
    CreateCalendarEventParams params,
  ) async {
    if (!ApiConstants.backendApiEnabled) {
      return ApiStubs.createCalendarEvent(title: params.title);
    }
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.calendarEventsPath,
      data: _eventBody(params),
    );
    return response.data ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> updateEvent({
    required String eventId,
    required UpdateCalendarEventParams params,
  }) async {
    if (!ApiConstants.backendApiEnabled) {
      return ApiStubs.updateCalendarEvent(eventId: eventId);
    }
    final response = await _dio.patch<Map<String, dynamic>>(
      '${ApiConstants.calendarEventsPath}/$eventId',
      data: _updateBody(params),
    );
    return response.data ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> deleteEvent({
    required String eventId,
    bool deleteSeries = false,
  }) async {
    if (!ApiConstants.backendApiEnabled) {
      return ApiStubs.deleteCalendarEvent();
    }
    final response = await _dio.delete<Map<String, dynamic>>(
      '${ApiConstants.calendarEventsPath}/$eventId',
      queryParameters: <String, dynamic>{'delete_series': deleteSeries},
    );
    return response.data ?? <String, dynamic>{};
  }

  Map<String, dynamic> _eventBody(CreateCalendarEventParams params) {
    return <String, dynamic>{
      'title': params.title,
      'description': params.description ?? '',
      'start': AppFormatter.apiDateTime(params.start),
      'end': AppFormatter.apiDateTime(params.end),
      'all_day': params.allDay,
      'location': params.location ?? '',
      'recurrence': <String, dynamic>{
        'enabled': params.isRecurring,
        if (params.isRecurring) ...<String, dynamic>{
          'weekly_mode': 'same_day',
          'skip_days': <String>[],
          'repeat_weeks': params.repeatWeeks,
        },
      },
    };
  }

  Map<String, dynamic> _updateBody(UpdateCalendarEventParams params) {
    return <String, dynamic>{
      if (params.title != null) 'title': params.title,
      if (params.description != null) 'description': params.description,
      if (params.start != null)
        'start': AppFormatter.apiDateTime(params.start!),
      if (params.end != null) 'end': AppFormatter.apiDateTime(params.end!),
      if (params.allDay != null) 'all_day': params.allDay,
      if (params.location != null) 'location': params.location,
    };
  }
}
