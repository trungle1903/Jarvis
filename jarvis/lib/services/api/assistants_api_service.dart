import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jarvis/models/assistant.dart';
import 'package:jarvis/services/header_service.dart';
import 'package:jarvis/services/storage.dart';

class AssistantApiService {
  final Dio _dio;
  final HeaderService _headerService;
  String baseUrl = dotenv.get('KB_API_BASE_URL');
  String guid = dotenv.get('X_JARVIS_GUID');

  AssistantApiService({required Dio dio, required HeaderService headerService})
    : _dio = dio,
      _headerService = headerService;

  Future<List<Assistant>> getAssistants({
    String? query,
    String? order,
    String? order_field,
    bool? isFavorite,
    bool? isPublic,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final accessToken = await StorageService().readSecureData('access_token');

      final queryParams = {
        if (query != null) 'q': query,
        if (order != null) 'order': order,
        if (order_field != null) 'order_field': order_field,
        if (isFavorite != null) 'isFavorite': isFavorite,
        if (isPublic != null) 'isPublic': isPublic,
        'offset': offset,
        'limit': limit,
      };

      final response = await _dio.get(
        '$baseUrl/kb_core/v1/ai-assistant',
        queryParameters: queryParams,
        options: Options(
          headers: {
            'x-jarvis-guid': guid,
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        return (response.data['items'] as List)
            .map((json) => Assistant.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      print('Status Code: ${e.response?.statusCode}');
      throw Exception(
        'Failed to fetch assistant: ${e.response?.data?['message'] ?? e.message}',
      );
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Assistant> createAssistant(Map<String, dynamic> data) async {
    try {
      final accessToken = await StorageService().readSecureData('access_token');

      final response = await _dio.post(
        '$baseUrl/kb_core/v1/ai-assistant',
        data: data,
        options: Options(
          headers: {
            'x-jarvis-guid': guid,
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Assistant.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to create assistant: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('Status Code: ${e.response?.statusCode}');
      throw Exception(
        'Failed to create assistant: ${e.response?.data?['message'] ?? e.message}',
      );
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> deleteAssistant(String id) async {
    final accessToken = await StorageService().readSecureData('access_token');
    await _dio.delete(
      '$baseUrl/kb-core/v1/ai-assistant/$id',
      options: Options(
        headers: {
          'x-jarvis-guid': guid,
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
  }

  Future<Assistant> updateAssistant({
    required String id,
    required String name,
    required String description,
    required String instructions,
  }) async {
    final accessToken = await StorageService().readSecureData('access_token');
    final response = await _dio.patch(
      '$baseUrl/kb-core/v1/ai-assistant/$id',
      data: {
        'assistantName': name,
        'description': description,
        'instructions': instructions,
      },
      options: Options(
        headers: {
          'x-jarvis-guid': guid,
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    return Assistant.fromJson(response.data);
  }

  Future<void> favoriteAssistant(String assistantId) async {
    final accessToken = await StorageService().readSecureData('access_token');
    final response = await _dio.post(
      '$baseUrl/kb-core/v1/ai-assistant/$assistantId/favorite',
      options: Options(
        headers: {
          'x-jarvis-guid': guid,
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to favorite assistant');
    }
  }

  Future<void> unfavoriteAssistant(String assistantId) async {
    final accessToken = await StorageService().readSecureData('access_token');

    final response = await _dio.delete(
      '$baseUrl/kb-core/v1/ai-assistant/$assistantId/favorite',
      options: Options(
        headers: {
          'x-jarvis-guid': guid,
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove assistant from favorites');
    }
  }
}
