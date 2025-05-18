import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/theme_config.dart';
import '../providers/user_provider.dart';
import '../../team/providers/team_provider.dart';

class PlayerProfileScreen extends ConsumerWidget {
  const PlayerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final teamsAsync = ref.watch(teamsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditProfileDialog(context, ref),
          ),
        ],
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingL),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Personal Information', style: AppTheme.heading3),
                        const SizedBox(height: AppTheme.spacingM),
                        _buildInfoRow('Full Name', user.name),
                        _buildInfoRow('Email', user.email),
                        _buildInfoRow('Role', user.role),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingL),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Team Information', style: AppTheme.heading3),
                        const SizedBox(height: AppTheme.spacingM),
                        teamsAsync.when(
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (error, stackTrace) =>
                              Center(child: Text('Error: $error')),
                          data: (teams) {
                            if (user.teamId == null) {
                              return const Text('Not assigned to any team');
                            }

                           final matchingTeams = teams.where((team) => team.id == user.teamId);
                          final team = matchingTeams.isNotEmpty ? matchingTeams.first : null;

                            if (team == null) {
                              return const Text('Team not found');
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow('Team Name', team.name),
                                _buildInfoRow('Team ID', team.id),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
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
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.body2,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditProfileDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      loading: () => showDialog(
        context: context,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => showDialog(
        context: context,
        builder: (_) => Center(child: Text('Error: $error')),
      ),
      data: (user) {
        if (user == null) {
          return showDialog(
            context: context,
            builder: (_) => const AlertDialog(
              title: Text('Error'),
              content: Text('User not found.'),
            ),
          );
        }

        final fullNameController = TextEditingController(text: user.name);
        final emailController = TextEditingController(text: user.email);

        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Edit Profile'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (fullNameController.text.isNotEmpty &&
                      emailController.text.isNotEmpty) {
                    await ref.read(usersProvider.notifier).updateUser(
                          user.id,
                          fullNameController.text,
                          emailController.text,
                          user.role,
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
      },
    );
  }
}
