import 'package:dio/dio.dart';
import 'package:jarvis/services/header_service.dart';
import 'package:jarvis/services/storage.dart';

import '../../models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthApiService {
  String baseUrl = dotenv.get('AUTH_API_BASE_URL');
  String appBaseURL = dotenv.get('APP_API_BASE_URL');
  final HeaderService _headerService;
  final Dio _dio;
  String guid = dotenv.get('X_JARVIS_GUID');

  AuthApiService(this._headerService, this._dio);
  Future<User> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/api/v1/auth/password/sign-in',
        data: {'email': email, 'password': password},
        options: Options(headers: _headerService.baseHeaders),
      );
      final loginData = response.data;
      final token = loginData['access_token'];
      final refreshToken = loginData['refresh_token'];

      final user = await fetchUserProfile(token, refreshToken);
      return user;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final errorMessage = e.response?.data['error'] ?? 'Login failed';
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error, please try again.');
      }
    } catch (e) {
      throw Exception('Something went wrong. Please try again later.');
    }
  }

  Future<User> register(String email, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/api/v1/auth/password/sign-up',
        data: {
          'email': email,
          'password': password,
          'verification_callback_url': 'https://call-back-url.com/',
        },
        options: Options(headers: _headerService.baseHeaders),
      );
      if (response.statusCode != 200) {
        final errorMessage = response.data['error'] ?? 'Invalid request';
        throw Exception(errorMessage);
      }
      return User.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode != 200) {
        final errorData = e.response?.data;
        throw Exception(
          errorData['error'] ?? 'Invalid email or password',
        );
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      final accessToken = await StorageService().readSecureData('access_token');
      final refreshToken = await StorageService().readSecureData(
        'refresh_token',
      );
      final userId = await StorageService().readSecureData('user_id');
      if (accessToken != null && refreshToken != null) {
        final headers = {
          'Authorization': 'Bearer $accessToken',
          ..._headerService.baseHeaders,
          'X-Stack-Refresh-Token': refreshToken,
        };
        final response = await _dio.delete(
          '$baseUrl/api/v1/auth/sessions/current',
          data: {},
          options: Options(headers: headers),
        );
        if (response.statusCode != 200) {
          debugPrint(
            'Logout failed: ${response.statusCode} - ${response.data}',
          );
          throw Exception('Logout failed: ${response.data}');
        }
      }
      await StorageService().clearAll();
    } catch (e) {
      debugPrint('Logout error: $e');
      await StorageService().clearAll();
      rethrow;
    }
  }

  Future<String?> refreshAccessToken() async {
    try {
      final refreshToken = await StorageService().readSecureData(
        'refresh_token',
      );
      if (refreshToken == null) return null;
      final response = await _dio.post(
        '$baseUrl/api/v1/auth/sessions/current/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(headers: _headerService.baseHeaders),
      );

      if (response.statusCode == 200) {
        final newToken = jsonDecode(response.data)['access_token'];
        await StorageService().writeSecureData('access_token', newToken);
        return newToken;
      }
    } catch (e) {
      debugPrint('Token refresh failed: $e');
    }
    return null;
  }

  Future<User> fetchUserProfile(String accessToken, String refreshToken) async {
    try {
      final response = await _dio.get(
        '$appBaseURL/api/v1/auth/me',
        options: Options(
          headers: {
            'x-jarvis-guid': guid,
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      final data = response.data;

      return User(
        id: data['id'].toString(),
        name: data['username'],
        email: data['email'],
        token: accessToken,
        refreshToken: refreshToken,
      );
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.statusCode} - ${e.response?.data}");
      throw Exception('Failed to fetch user profile: ${e.message}');
    } catch (e) {
      debugPrint("Unexpected error: $e");
      throw Exception('Failed to fetch user profile: $e');
    }
  }
}
