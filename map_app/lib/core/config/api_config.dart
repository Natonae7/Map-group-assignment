class ApiConfig {
  static const String baseUrl = 'http://localhost:3000/api';
  
  // Auth endpoints
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String refreshToken = '$baseUrl/auth/refresh-token';
  
  // Team endpoints
  static const String teams = '$baseUrl/teams';
  static String teamById(String id) => '$teams/$id';
  static String addPlayerToTeam(String teamId) => '$teams/$teamId/players';
  static String removePlayerFromTeam(String teamId, String playerId) => '$teams/$teamId/players/$playerId';
  
  // Event endpoints
  static const String events = '$baseUrl/events';
  static String eventById(String id) => '$events/$id';
  static String registerTeamForEvent(String eventId) => '$events/$eventId/register';
  static String unregisterTeamFromEvent(String eventId, String teamId) => '$events/$eventId/register/$teamId';
} 