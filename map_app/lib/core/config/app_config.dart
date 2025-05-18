import 'package:flutter/foundation.dart';

class AppConfig {
  static const String appName = 'Namibia Hockey Union';
  static const String apiBaseUrl = 'https://api.namibiahockey.com';
  static const String socketUrl = 'wss://api.namibiahockey.com';
  
  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String teamsEndpoint = '/teams';
  static const String playersEndpoint = '/players';
  static const String eventsEndpoint = '/events';
  static const String profileEndpoint = '/profile';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  
  // App Settings
  static const bool isDebug = kDebugMode;
  static const int apiTimeout = 30000; // 30 seconds
  static const int socketReconnectInterval = 5000; // 5 seconds
  
  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxTeamNameLength = 50;
  static const int maxPlayerNameLength = 100;

    static const String usersEndpoint = '/users';
} 