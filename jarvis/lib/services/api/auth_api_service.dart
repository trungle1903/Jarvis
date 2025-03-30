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
        headers: {'Content-Type': 'application/json'},
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
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
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
    // Xử lý logout API nếu cần
  }
}
