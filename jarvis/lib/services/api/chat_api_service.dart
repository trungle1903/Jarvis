import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jarvis/models/chat_message.dart';
import 'package:jarvis/models/chat_response.dart';
import 'package:jarvis/models/conversation.dart';
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
    String? conversationId,
    required String assistantId,
    required String assistantName,
    required String assistantModel,
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
                  'model': assistantModel,
                  'name': assistantName,
                  'id': assistantId,
                },
              },
              {
                "role": "model",
                "content": "Hello! How can I assist you today?",
                "assistant": {
                  "model": assistantModel,
                  "name": assistantName,
                  "id": assistantId,
                },
              },
            ],
            if (conversationId != null && conversationId.isNotEmpty)
              'id': conversationId,
          },
        },
        'assistant': {
          'model': assistantModel,
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
      print(response.data);
      return ChatResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        debugPrint(e.response?.data);
        throw Exception('Invalid request: ${e.response?.data['message']}');
      }
      rethrow;
    }
  }

  Future<List<Conversation>> getConversations() async {
    try {
      final accessToken = await StorageService().readSecureData('access_token');
      if (accessToken == null) {
        throw Exception('Access token is missing');
      }

      final response = await _dio.get(
        '$baseUrl/api/v1/ai-chat/conversations',
        queryParameters: {
          'assistantId': 'gpt-4o-mini',
          'assistantModel': 'dify',
        },
        options: Options(
          headers: {
            'x-jarvis-guid': '',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      final List<dynamic> items = response.data['items'] ?? [];
      return items.map((item) => Conversation.fromJson(item)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch conversatinos: ${e.message}');
    }
  }

  Future<List<ChatMessage>> getConversationMessages(
    String conversationId,
  ) async {
    final accessToken = await StorageService().readSecureData('access_token');
    if (accessToken == null) throw Exception('Access token is missing');

    final response = await _dio.get(
      '$baseUrl/api/v1/ai-chat/conversations/$conversationId/messages',
      queryParameters: {'assistantId': 'gpt-4o-mini', 'assistantModel': 'dify'},
      options: Options(
        headers: {'x-jarvis-guid': '', 'Authorization': 'Bearer $accessToken'},
      ),
    );

    final data = response.data['items'] as List<dynamic>;
    final messages = <ChatMessage>[];

    for (final item in data) {
      final createdAt = DateTime.parse(item['createdAt']);

      messages.add(ChatMessage.fromUser(item['query'], createdAt));
      messages.add(ChatMessage.fromAssistant(item['answer'], createdAt));
    }

    return messages;
  }
}
