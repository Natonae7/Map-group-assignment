import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/event/screens/event_details_screen.dart';
import '../../features/event/screens/event_list_screen.dart';
import '../../features/event/screens/event_registration_screen.dart';
import '../../features/team/screens/team_details_screen.dart';
import '../../features/team/screens/team_list_screen.dart';
import '../../features/team/screens/team_management_screen.dart';
// import '../../features/user/screens/dashboard_screen.dart';
import '../../features/user/screens/player_profile_screen.dart';
import '../../features/user/screens/user_list_screen.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    // Auth Routes
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    // Dashboard Route
    // GoRoute(
    //   path: '/dashboard',
    //   builder: (context, state) => const DashboardScreen(),
    // ),

    // User Routes
    GoRoute(
      path: '/users',
      builder: (context, state) => const UserListScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const PlayerProfileScreen(),
    ),

    // Team Routes
    GoRoute(
      path: '/teams',
      builder: (context, state) => const TeamListScreen(),
    ),
    GoRoute(
      path: '/teams/:id',
      builder: (context, state) => TeamDetailsScreen(
        teamId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/teams/:id/manage',
      builder: (context, state) => TeamManagementScreen(
        teamId: state.pathParameters['id']!,
      ),
    ),

    // Event Routes
    GoRoute(
      path: '/events',
      builder: (context, state) => const EventListScreen(),
    ),
    GoRoute(
      path: '/events/:id',
      builder: (context, state) => EventDetailsScreen(
        eventId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/events/:id/register',
      builder: (context, state) => EventRegistrationScreen(
        eventId: state.pathParameters['id']!,
      ),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text(
        'Page not found: ${state.uri}',
        style: const TextStyle(fontSize: 20),
      ),
    ),
  ),
); 