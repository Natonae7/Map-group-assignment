import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:map_app/core/config/api_config.dart';
import 'package:map_app/core/error/app_error.dart';

class ApiService {
  final String? token;
  final http.Client _client = http.Client();

  ApiService({this.token});

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<T> get<T>(String url) async {
    try {
      final response = await _client.get(
        Uri.parse(url),
        headers: _headers,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      throw AppError.network(e.toString());
    }
  }

  Future<T> post<T>(String url, {required Map<String, dynamic> body}) async {
    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: _headers,
        body: jsonEncode(body),
      );
      return _handleResponse<T>(response);
    } catch (e) {
      throw AppError.network(e.toString());
    }
  }

  Future<T> put<T>(String url, {required Map<String, dynamic> body}) async {
    try {
      final response = await _client.put(
        Uri.parse(url),
        headers: _headers,
        body: jsonEncode(body),
      );
      return _handleResponse<T>(response);
    } catch (e) {
      throw AppError.network(e.toString());
    }
  }

  Future<T> delete<T>(String url) async {
    try {
      final response = await _client.delete(
        Uri.parse(url),
        headers: _headers,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      throw AppError.network(e.toString());
    }
  }

  T _handleResponse<T>(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (T == String) {
        return response.body as T;
      }
      return jsonDecode(response.body) as T;
    } else {
      final error = jsonDecode(response.body);
      throw AppError.server(
        error['message'] ?? 'Server error',
        statusCode: response.statusCode,
      );
    }
  }
} 