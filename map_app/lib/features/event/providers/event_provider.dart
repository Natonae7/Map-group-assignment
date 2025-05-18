import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/event_model.dart';
import '../../../services/api/event_service.dart';

final eventServiceProvider = Provider<EventService>((ref) {
  throw UnimplementedError('EventService not implemented');
});

final eventsProvider = StateNotifierProvider<EventsNotifier, AsyncValue<List<EventModel>>>(
  (ref) => EventsNotifier(ref.watch(eventServiceProvider)),
);

class EventsNotifier extends StateNotifier<AsyncValue<List<EventModel>>> {
  final EventService _eventService;

  EventsNotifier(this._eventService) : super(const AsyncValue.loading()) {
    loadEvents();
  }

  Future<void> loadEvents() async {
    state = const AsyncValue.loading();
    try {
      final events = await _eventService.getEvents('token');
      state = AsyncValue.data(events);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createEvent(
    String title,
    String description,
    String location,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final newEvent = await _eventService.createEvent(
        'token',
        title,
        description,
        location,
        startDate,
        endDate,
      );
      state.whenData((events) {
        state = AsyncValue.data([...events, newEvent]);
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateEvent(
    String eventId,
    String title,
    String description,
    String location,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final updatedEvent = await _eventService.updateEvent(
        'token',
        eventId,
        title,
        description,
        location,
        startDate,
        endDate,
      );
      state.whenData((events) {
        state = AsyncValue.data(
          events.map((event) => event.id == eventId ? updatedEvent : event).toList(),
        );
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _eventService.deleteEvent('token', eventId);
      state.whenData((events) {
        state = AsyncValue.data(
          events.where((event) => event.id != eventId).toList(),
        );
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> registerTeamForEvent(String eventId, String teamId) async {
    try {
      final updatedEvent = await _eventService.registerTeamForEvent(
        'token',
        eventId,
        teamId,
      );
      state.whenData((events) {
        state = AsyncValue.data(
          events.map((event) => event.id == eventId ? updatedEvent : event).toList(),
        );
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> unregisterTeamFromEvent(String eventId, String teamId) async {
    try {
      final updatedEvent = await _eventService.unregisterTeamFromEvent(
        'token',
        eventId,
        teamId,
      );
      state.whenData((events) {
        state = AsyncValue.data(
          events.map((event) => event.id == eventId ? updatedEvent : event).toList(),
        );
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
} 