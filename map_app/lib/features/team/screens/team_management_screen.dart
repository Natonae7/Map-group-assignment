import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/theme_config.dart';
import '../providers/team_provider.dart';
import '../../user/providers/user_provider.dart';

class TeamManagementScreen extends ConsumerWidget {
    final String teamId;
    
    const TeamManagementScreen({
    super.key,
    required this.teamId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamAsync = ref.watch(teamsProvider);
    final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Management'),
      ),
      body: teamAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (teams) {
          if (teams.isEmpty) {
            return const Center(child: Text('No team found'));
          }
          
          final team = teams.first; // Assuming manager has only one team
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          team.name,
                          style: AppTheme.heading2,
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Team ID: ${team.id}',
                              style: AppTheme.body2,
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showEditTeamDialog(context, ref, team),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingL),
                Text(
                  'Players',
                  style: AppTheme.heading3,
                ),
                const SizedBox(height: AppTheme.spacingM),
                usersAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Center(child: Text('Error: $error')),
                  data: (users) {
                    final teamPlayers = users.where((user) => 
                      user.teamId == team.id && user.role == 'player'
                    ).toList();
                    
                    if (teamPlayers.isEmpty) {
                      return const Center(child: Text('No players in the team'));
                    }
                    
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: teamPlayers.length,
                      itemBuilder: (context, index) {
                        final player = teamPlayers[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                          child: ListTile(
                            title: Text(player.name),
                            subtitle: Text(player.email),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              color: AppTheme.errorColor,
                              onPressed: () => _showRemovePlayerConfirmation(
                                context,
                                ref,
                                team.id,
                                player.id,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: AppTheme.spacingL),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddPlayerDialog(context, ref, team.id),
                    icon: const Icon(Icons.person_add),
                    label: const Text('Add Player'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showEditTeamDialog(
    BuildContext context,
    WidgetRef ref,
    dynamic team,
  ) async {
    final nameController = TextEditingController(text: team.name);

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Team'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Team Name',
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
              if (nameController.text.isNotEmpty) {
                await ref.read(teamsProvider.notifier).updateTeam(
                      team.id,
                      nameController.text,
                    );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddPlayerDialog(
    BuildContext context,
    WidgetRef ref,
    String teamId,
  ) async {
    final usersAsync = ref.watch(usersProvider);
    
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Player'),
        content: SizedBox(
          width: double.maxFinite,
          child: usersAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
            data: (users) {
              final availablePlayers = users.where((user) => 
                user.role == 'player' && user.teamId == null
              ).toList();
              
              if (availablePlayers.isEmpty) {
                return const Center(child: Text('No available players'));
              }
              
              return ListView.builder(
                shrinkWrap: true,
                itemCount: availablePlayers.length,
                itemBuilder: (context, index) {
                  final player = availablePlayers[index];
                  return ListTile(
                    title: Text(player.name),
                    subtitle: Text(player.email),
                    onTap: () async {
                      await ref.read(teamsProvider.notifier).addPlayerToTeam(
                            teamId,
                            player.id,
                          );
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _showRemovePlayerConfirmation(
    BuildContext context,
    WidgetRef ref,
    String teamId,
    String playerId,
  ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Player'),
        content: const Text('Are you sure you want to remove this player from the team?'),
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
                    teamId,
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