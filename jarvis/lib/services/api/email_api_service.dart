import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jarvis/services/header_service.dart';
import 'package:jarvis/services/storage.dart';

class EmailApiService {
  final Dio _dio;
  final HeaderService _headerService;
  final String baseUrl = dotenv.get('APP_API_BASE_URL');
  final String guid = dotenv.get('EMAIL_X_JARVIS_GUID');

  EmailApiService({required Dio dio, required HeaderService headerService})
      : _dio = dio,
        _headerService = headerService;

  Future<Map<String, dynamic>> generateEmail({
    required String subject,
    required String sender,
    required String receiver,
    required String language,
    required String mainIdea,
    required String action,
    required String emailContent,
    required Map<String, String> style,
  }) async {
    try {
      final accessToken = await StorageService().readSecureData('access_token');
      final emailData = {
        "mainIdea": mainIdea,
        "action": action,
        "email": emailContent,
        "metadata": {
          "context": [],
          "subject": subject,
          "sender": sender,
          "receiver": receiver,
          "style": style,
          "language": language,
        },
      };
      final response = await _dio.post(
        '$baseUrl/api/v1/ai-email',
        data: emailData,
        options: Options(
          headers: {
            'x-jarvis-guid': guid,
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        return {
          'email': response.data['email']?.toString() ?? '',
          'improvedActions': List<String>.from(response.data['improvedActions'] ?? []),
          'remainingUsage': response.data['remainingUsage']?.toString() ?? ''
        };
      } else {
        throw Exception('Failed to generate email: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('API error: ${e.toString()}');
    }
  }

  Future<List<String>> generateIdea({
    required String subject,
    required String sender,
    required String receiver,
    required String language,
    required String emailContent,
  }) async {
    try {
      final accessToken = await StorageService().readSecureData('access_token');
      final response = await _dio.post(
        '$baseUrl/api/v1/ai-email/reply-ideas',
        data: {
          "action": "Suggest 3 ideas for this email",
          "email": emailContent,
          "metadata": {
            "context": [],
            "subject": subject,
            "sender": sender,
            "receiver": receiver,
            "language": language.toLowerCase(),
          },
        },
        options: Options(
          headers: {
            'x-jarvis-guid': guid,
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        return List<String>.from(response.data['ideas']);
      } else {
        throw Exception('Failed to generate ideas: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('API error: ${e.toString()}');
    }
  }
}
