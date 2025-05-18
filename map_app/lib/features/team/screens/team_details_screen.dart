import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/theme_config.dart';
import '../../../models/team_model.dart';
import '../providers/team_provider.dart';

class TeamDetailsScreen extends ConsumerWidget {
  final String teamId;

  const TeamDetailsScreen({
    super.key,
    required this.teamId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.watch(teamsProvider);

    return teamsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
      data: (teams) {
        final team = teams.firstWhere(
          (t) => t.id == teamId,
          orElse: () => throw Exception('Team not found'),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(team.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: () => _showAddPlayerDialog(context, ref, team),
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
                        'Team Information',
                        style: AppTheme.heading2,
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      _buildInfoRow('Created', team.createdAt.toString()),
                      _buildInfoRow('Last Updated', team.updatedAt.toString()),
                      _buildInfoRow('Manager', team.managerId),
                      _buildInfoRow(
                        'Players',
                        '${team.playerIds.length} players',
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: team.playerIds.isEmpty
                    ? const Center(
                        child: Text('No players in this team'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppTheme.spacingM),
                        itemCount: team.playerIds.length,
                        itemBuilder: (context, index) {
                          final playerId = team.playerIds[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                            child: ListTile(
                              title: Text('Player ${index + 1}'),
                              subtitle: Text('ID: $playerId'),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => _showRemovePlayerConfirmation(
                                  context,
                                  ref,
                                  team,
                                  playerId,
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

  Future<void> _showAddPlayerDialog(
    BuildContext context,
    WidgetRef ref,
    TeamModel team,
  ) async {
    final playerIdController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Player'),
        content: TextField(
          controller: playerIdController,
          decoration: const InputDecoration(
            labelText: 'Player ID',
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
              if (playerIdController.text.isNotEmpty) {
                await ref.read(teamsProvider.notifier).addPlayerToTeam(
                      team.id,
                      playerIdController.text,
                    );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _showRemovePlayerConfirmation(
    BuildContext context,
    WidgetRef ref,
    TeamModel team,
    String playerId,
  ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Player'),
        content: const Text('Are you sure you want to remove this player?'),
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
              await ref.read(teamsProvider.notifier).removePlayerFromTeam(
                    team.id,
                    playerId,
                  );
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
} 