import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jarvis/services/header_service.dart';
import 'package:jarvis/services/storage.dart';

class EmailApiService {
  final Dio _dio;
  final HeaderService _headerService;
  String baseUrl = dotenv.get('APP_API_BASE_URL');
  String guid = dotenv.get('EMAIL_X_JARVIS_GUID');

  EmailApiService({required Dio dio, required HeaderService headerService})
    : _dio = dio,
      _headerService = headerService;

  Future<String> generateEmail(String mainIdea) async {
    try {
      final accessToken = await StorageService().readSecureData('access_token');
      final response = await _dio.post(
        '$baseUrl/api/v1/ai-email', 
        data: {
          "mainIdea": mainIdea,
          "action": "Reply to this email",
          "email": "Các bạn sinh viên thân mến, Trung tâm Hỗ trợ Sinh viên giới thiệu tới các bạn “Ngày Hội Sinh viên và Doanh nghiệp - Năm 2024",
          "metadata": {
            "context": [],
            "subject": "Generated Email",
            "sender": "user@example.com",
            "receiver": "recipient@example.com",
            "style": {
              "length": "medium",
              "formality": "neutral",
              "tone": "friendly"
            },
            "language": "english"
          }
        },
        options: Options(
          headers: {
            'x-jarvis-guid': guid,
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        print(response.data);
        return response.data.toString();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to generate email: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception('API error: ${e.message}');
    }
  }
}