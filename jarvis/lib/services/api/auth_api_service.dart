import 'package:jarvis/services/storage.dart';

import '../../models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthApiService {
  String baseUrl = dotenv.get('AUTH_API_BASE_URL');
  String projectId = dotenv.get('PROJECT_ID');
  String clientKey = dotenv.get('CLIENT_KEY');
  Future<User> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/password/sign-in'),
        headers: {
          'Content-Type': 'application/json',
          'X-Stack-Access-Type': 'client',
          'X-Stack-Project-Id': projectId,
          'X-Stack-Publishable-Client-Key': clientKey,
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User(
          id: data['user_id']?.toString() ?? '0',
          name: '',
          email: email,
          token: data['access_token'],
          refreshToken: data['refresh_token'],
        );
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Login error: $e');
      rethrow;
    }
  }

  Future<User> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/sessions/current'),
        headers: {
          'Content-Type': 'application/json',
          'X-Stack-Access-Type': 'client',
          'X-Stack-Project-Id': projectId,
          'X-Stack-Publishable-Client-Key': clientKey,
        },
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['user']);
      } else {
        throw Exception('Registration failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Registration error: $e');
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
        await http.post(
          Uri.parse('$baseUrl/auth/logout'),
          headers: {
            'Content-Type': 'application/json',
            'X-Stack-Access-Type': 'client',
            'X-Stack-Project-Id': projectId,
            'X-Stack-Publishable-Client-Key': clientKey,
          },
          body: jsonEncode({
            'access_token': accessToken,
            'refresh_token': refreshToken,
            'user_id': userId,
          }),
        );
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

      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {
          'Content-Type': 'application/json',
          'X-Stack-Access-Type': 'client',
          'X-Stack-Project-Id': projectId,
          'X-Stack-Publishable-Client-Key': clientKey,
        },
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 200) {
        final newToken = jsonDecode(response.body)['access_token'];
        await StorageService().writeSecureData('access_token', newToken);
        return newToken;
      }
    } catch (e) {
      debugPrint('Token refresh failed: $e');
    }
    return null;
  }
}
