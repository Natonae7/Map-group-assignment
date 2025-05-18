import 'package:dio/dio.dart';
import '../../models/event_model.dart';

class EventService {
  final Dio _dio;

  EventService(this._dio);

  Future<List<EventModel>> getEvents(String token) async {
    try {
      final response = await _dio.get(
        '/events',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => EventModel.fromJson(json)).toList();
      }
      throw Exception('Failed to load events');
    } catch (e) {
      throw Exception('Failed to load events: $e');
    }
  }

  Future<EventModel> createEvent(
    String token,
    String title,
    String description,
    String location,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await _dio.post(
        '/events',
        data: {
          'title': title,
          'description': description,
          'location': location,
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 201) {
        return EventModel.fromJson(response.data);
      }
      throw Exception('Failed to create event');
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  Future<EventModel> updateEvent(
    String token,
    String eventId,
    String title,
    String description,
    String location,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await _dio.put(
        '/events/$eventId',
        data: {
          'title': title,
          'description': description,
          'location': location,
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return EventModel.fromJson(response.data);
      }
      throw Exception('Failed to update event');
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  Future<void> deleteEvent(String token, String eventId) async {
    try {
      final response = await _dio.delete(
        '/events/$eventId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete event');
      }
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }

  Future<EventModel> registerTeamForEvent(
    String token,
    String eventId,
    String teamId,
  ) async {
    try {
      final response = await _dio.post(
        '/events/$eventId/register',
        data: {'teamId': teamId},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return EventModel.fromJson(response.data);
      }
      throw Exception('Failed to register team for event');
    } catch (e) {
      throw Exception('Failed to register team for event: $e');
    }
  }

  Future<EventModel> unregisterTeamFromEvent(
    String token,
    String eventId,
    String teamId,
  ) async {
    try {
      final response = await _dio.delete(
        '/events/$eventId/register/$teamId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return EventModel.fromJson(response.data);
      }
      throw Exception('Failed to unregister team from event');
    } catch (e) {
      throw Exception('Failed to unregister team from event: $e');
    }
  }
} 