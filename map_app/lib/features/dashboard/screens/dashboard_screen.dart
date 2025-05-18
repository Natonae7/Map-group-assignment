import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/theme_config.dart';
import '../../../models/user_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../event/screens/event_list_screen.dart';
import '../../team/screens/team_list_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateProvider);

    return userAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('User not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                   onPressed: () => ref.read(authStateProvider.notifier).logout(), 
              ),
            ],
          ),
          body: _buildDashboardContent(context, user),
        );
      },
    );
  }

  Widget _buildDashboardContent(BuildContext context, UserModel user) {
    switch (user.role) {
      case 'admin':
        return _buildAdminDashboard(context);
      case 'manager':
        return _buildManagerDashboard(context, user);
      case 'player':
        return _buildPlayerDashboard(context, user);
      default:
        return const Center(child: Text('Invalid role'));
    }
  }

  Widget _buildAdminDashboard(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      crossAxisCount: 2,
      crossAxisSpacing: AppTheme.spacingM,
      mainAxisSpacing: AppTheme.spacingM,
      children: [
        _buildDashboardCard(
          context,
          'Teams',
          Icons.group,
          () => context.push('/teams'),
        ),
        _buildDashboardCard(
          context,
          'Events',
          Icons.event,
          () => context.push('/events'),
        ),
        _buildDashboardCard(
          context,
          'Users',
          Icons.people,
          () => context.push('/users'),
        ),
        _buildDashboardCard(
          context,
          'Settings',
          Icons.settings,
          () => context.push('/settings'),
        ),
      ],
    );
  }

  Widget _buildManagerDashboard(BuildContext context, UserModel user) {
    return GridView.count(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      crossAxisCount: 2,
      crossAxisSpacing: AppTheme.spacingM,
      mainAxisSpacing: AppTheme.spacingM,
      children: [
        _buildDashboardCard(
          context,
          'My Team',
          Icons.group,
          () => context.push('/teams/${user.teamId}'),
        ),
        _buildDashboardCard(
          context,
          'Events',
          Icons.event,
          () => context.push('/events'),
        ),
        _buildDashboardCard(
          context,
          'Schedule',
          Icons.calendar_today,
          () => context.push('/schedule'),
        ),
        _buildDashboardCard(
          context,
          'Messages',
          Icons.message,
          () => context.push('/messages'),
        ),
      ],
    );
  }

  Widget _buildPlayerDashboard(BuildContext context, UserModel user) {
    return GridView.count(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      crossAxisCount: 2,
      crossAxisSpacing: AppTheme.spacingM,
      mainAxisSpacing: AppTheme.spacingM,
      children: [
        _buildDashboardCard(
          context,
          'My Team',
          Icons.group,
          () => context.push('/teams/${user.teamId}'),
        ),
        _buildDashboardCard(
          context,
          'Events',
          Icons.event,
          () => context.push('/events'),
        ),
        _buildDashboardCard(
          context,
          'Schedule',
          Icons.calendar_today,
          () => context.push('/schedule'),
        ),
        _buildDashboardCard(
          context,
          'Messages',
          Icons.message,
          () => context.push('/messages'),
        ),
      ],
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              title,
              style: AppTheme.heading3,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 