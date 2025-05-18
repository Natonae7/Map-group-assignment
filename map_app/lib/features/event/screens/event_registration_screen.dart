import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/theme_config.dart';
import '../providers/event_provider.dart';
import '../../team/providers/team_provider.dart';

class EventRegistrationScreen extends ConsumerWidget {
    final String eventId;
    
    const EventRegistrationScreen({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);
    final teamsAsync = ref.watch(teamsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Registration'),
      ),
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (events) {
          if (events.isEmpty) {
            return const Center(child: Text('No events available'));
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: AppTheme.heading3,
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      Text(
                        event.description,
                        style: AppTheme.body2,
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      Text(
                        'Location: ${event.location}',
                        style: AppTheme.body2,
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      Text(
                        'Date: ${event.startDate} - ${event.endDate}',
                        style: AppTheme.body2,
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      teamsAsync.when(
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) => Center(child: Text('Error: $error')),
                        data: (teams) {
                          final isRegistered = event.registeredTeamIds.contains(teams.first.id);
                          
                          return ElevatedButton(
                            onPressed: () {
                              if (isRegistered) {
                                _showUnregisterConfirmation(context, ref, event.id);
                              } else {
                                _showRegisterConfirmation(context, ref, event.id);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isRegistered
                                  ? AppTheme.errorColor
                                  : AppTheme.primaryColor,
                            ),
                            child: Text(
                              isRegistered ? 'Unregister' : 'Register',
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showRegisterConfirmation(
    BuildContext context,
    WidgetRef ref,
    String eventId,
  ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Register for Event'),
        content: const Text('Are you sure you want to register your team for this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final teamsAsync = ref.read(teamsProvider);
              teamsAsync.whenData((teams) async {
                await ref.read(eventsProvider.notifier).registerTeamForEvent(
                      eventId,
                      teams.first.id,
                    );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              });
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }

  Future<void> _showUnregisterConfirmation(
    BuildContext context,
    WidgetRef ref,
    String eventId,
  ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unregister from Event'),
        content: const Text('Are you sure you want to unregister your team from this event?'),
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
              final teamsAsync = ref.read(teamsProvider);
              teamsAsync.whenData((teams) async {
                await ref.read(eventsProvider.notifier).unregisterTeamFromEvent(
                      eventId,
                      teams.first.id,
                    );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              });
            },
            child: const Text('Unregister'),
          ),
        ],
      ),
    );
  }
} 