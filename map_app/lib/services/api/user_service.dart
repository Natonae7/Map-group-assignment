import 'package:dio/dio.dart';
import '../../models/user_model.dart';
import 'auth_service.dart';
import '../../core/config/app_config.dart';

class UserService {
  final Dio _dio;
  final AuthService _authService;

  UserService({
    required Dio dio,
    required AuthService authService,
  })  : _dio = dio,
        _authService = authService;

  Future<List<UserModel>> getUsers() async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await _dio.get(
      '${AppConfig.apiBaseUrl}${AppConfig.usersEndpoint}',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  Future<UserModel> getUser(String id) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await _dio.get(
      '${AppConfig.apiBaseUrl}${AppConfig.usersEndpoint}/$id',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch user');
    }
  }

  Future<UserModel> updateUser(
    String id,
    String fullName,
    String email,
    String role,
  ) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await _dio.put(
      '${AppConfig.apiBaseUrl}${AppConfig.usersEndpoint}/$id',
      data: {
        'full_name': fullName,
        'email': email,
        'role': role,
      },
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(String id) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await _dio.delete(
      '${AppConfig.apiBaseUrl}${AppConfig.usersEndpoint}/$id',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }

  Future<void> assignTeamToUser(String userId, String teamId) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await _dio.post(
      '${AppConfig.apiBaseUrl}${AppConfig.usersEndpoint}/$userId/team',
      data: {'team_id': teamId},
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to assign team to user');
    }
  }

  Future<void> removeTeamFromUser(String userId) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await _dio.delete(
      '${AppConfig.apiBaseUrl}${AppConfig.usersEndpoint}/$userId/team',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove team from user');
    }
  }
} 