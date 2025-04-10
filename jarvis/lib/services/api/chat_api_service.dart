import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jarvis/models/chat_response.dart';
import 'package:jarvis/services/header_service.dart';
import 'package:jarvis/services/storage.dart';

class ChatApiService {
  final Dio _dio;
  final HeaderService _headerService;
  String baseUrl = dotenv.get('APP_API_BASE_URL');

  ChatApiService({required Dio dio, required HeaderService headerService})
    : _dio = dio,
      _headerService = headerService;

  Future<ChatResponse> sendMessage({
    required String message,
    required String conversationId,
    required String assistantId,
    required String assistantName,
    List<dynamic> files = const [],
  }) async {
    try {
      final accessToken = await StorageService().readSecureData('access_token');
      if (accessToken == null) {
        throw Exception('Access token is missing.');
      }

      final payload = {
        'content': message,
        'files': files,
        'metadata': {
          'conversation': {
            'messages': [
              {
                'role': 'user',
                'content': message,
                'files': files,
                'assistant': {
                  'model': 'dify',
                  'name': assistantName,
                  'id': assistantId,
                },
              },
              {
                "role": "model",
                "content": "Hello! How can I assist you today?",
                "assistant": {
                  "model": "dify",
                  "name": assistantName,
                  "id": assistantId,
                },
              },
            ],
          },
        },
        'assistant': {
          'model': 'dify',
          'name': assistantName,
          'id': assistantId,
        },
      };

      final response = await _dio.post(
        '$baseUrl/api/v1/ai-chat/messages',
        data: payload,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );
      return ChatResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        debugPrint(e.response?.data);
        throw Exception('Invalid request: ${e.response?.data['message']}');
      }
      rethrow;
    }
  }
}
