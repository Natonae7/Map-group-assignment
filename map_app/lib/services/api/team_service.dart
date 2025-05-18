import 'package:dio/dio.dart';
import '../../models/team_model.dart';
import 'auth_service.dart';
import '../../core/config/app_config.dart';

class TeamService {
  final Dio _dio;
  final AuthService _authService;

  TeamService({
    required Dio dio,
    required AuthService authService,
  })  : _dio = dio,
        _authService = authService;

  Future<List<TeamModel>> getTeams() async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await _dio.get(
      '${AppConfig.apiBaseUrl}${AppConfig.teamsEndpoint}',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => TeamModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch teams');
    }
  }

  Future<TeamModel> createTeam(String name) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await _dio.post(
      '${AppConfig.apiBaseUrl}${AppConfig.teamsEndpoint}',
      data: {'name': name},
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response.statusCode == 201) {
      return TeamModel.fromJson(response.data);
    } else {
      throw Exception('Failed to create team');
    }
  }

  Future<TeamModel> updateTeam(String id, String name) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await _dio.put(
      '${AppConfig.apiBaseUrl}${AppConfig.teamsEndpoint}/$id',
      data: {'name': name},
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response.statusCode == 200) {
      return TeamModel.fromJson(response.data);
    } else {
      throw Exception('Failed to update team');
    }
  }

  Future<void> deleteTeam(String id) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await _dio.delete(
      '${AppConfig.apiBaseUrl}${AppConfig.teamsEndpoint}/$id',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete team');
    }
  }

  Future<void> addPlayerToTeam(String teamId, String playerId) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await _dio.post(
      '${AppConfig.apiBaseUrl}${AppConfig.teamsEndpoint}/$teamId/players',
      data: {'player_id': playerId},
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add player to team');
    }
  }

  Future<void> removePlayerFromTeam(String teamId, String playerId) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await _dio.delete(
      '${AppConfig.apiBaseUrl}${AppConfig.teamsEndpoint}/$teamId/players/$playerId',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to remove player from team');
    }
  }
} 