import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/theme_config.dart';
import '../../../models/event_model.dart';
import '../providers/event_provider.dart';

class EventDetailsScreen extends ConsumerWidget {
  final String eventId;

  const EventDetailsScreen({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);

    return eventsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
      data: (events) {
        final event = events.firstWhere(
          (e) => e.id == eventId,
          orElse: () => throw Exception('Event not found'),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(event.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.group_add),
                onPressed: () => _showRegisterTeamDialog(context, ref, event),
              ),
            ],
          ),
          body: Column(
            children: [
              Card(
                margin: const EdgeInsets.all(AppTheme.spacingM),
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Event Information',
                        style: AppTheme.heading2,
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      _buildInfoRow('Description', event.description),
                      _buildInfoRow('Location', event.location),
                      _buildInfoRow('Start Date', event.startDate.toString()),
                      _buildInfoRow('End Date', event.endDate.toString()),
                      _buildInfoRow('Created By', event.createdBy),
                      _buildInfoRow(
                        'Registered Teams',
                        '${event.registeredTeamIds.length} teams',
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: event.registeredTeamIds.isEmpty
                    ? const Center(
                        child: Text('No teams registered for this event'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppTheme.spacingM),
                        itemCount: event.registeredTeamIds.length,
                        itemBuilder: (context, index) {
                          final teamId = event.registeredTeamIds[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                            child: ListTile(
                              title: Text('Team ${index + 1}'),
                              subtitle: Text('ID: $teamId'),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => _showUnregisterTeamConfirmation(
                                  context,
                                  ref,
                                  event,
                                  teamId,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTheme.body2.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.body1,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showRegisterTeamDialog(
    BuildContext context,
    WidgetRef ref,
    EventModel event,
  ) async {
    final teamIdController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Register Team'),
        content: TextField(
          controller: teamIdController,
          decoration: const InputDecoration(
            labelText: 'Team ID',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (teamIdController.text.isNotEmpty) {
                await ref.read(eventsProvider.notifier).registerTeamForEvent(
                      event.id,
                      teamIdController.text,
                    );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }

  Future<void> _showUnregisterTeamConfirmation(
    BuildContext context,
    WidgetRef ref,
    EventModel event,
    String teamId,
  ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unregister Team'),
        content: const Text('Are you sure you want to unregister this team?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            onPressed: () async {
              await ref.read(eventsProvider.notifier).unregisterTeamFromEvent(
                    event.id,
                    teamId,
                  );
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Unregister'),
          ),
        ],
      ),
    );
  }
} 