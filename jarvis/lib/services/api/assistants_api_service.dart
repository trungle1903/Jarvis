import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jarvis/models/assistant.dart';
import 'package:jarvis/models/knowledge.dart';
import 'package:jarvis/services/header_service.dart';
import 'package:jarvis/services/storage.dart';

class AssistantApiService {
  final Dio _dio;
  final HeaderService _headerService;
  String baseUrl = dotenv.get('KB_API_BASE_URL');
  String guid = dotenv.get('KB_X_JARVIS_GUID');

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
        '$baseUrl/kb-core/v1/ai-assistant',
        queryParameters: queryParams,
        options: Options(
          headers: {
            'x-jarvis-guid': guid,
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);
        if (response.data != null && response.data['data'] != null) {
          final List<dynamic> dataList = response.data['data'];
          return dataList
              .map((json) => Assistant.fromJson(json))
              .toList();
        } else {
          return [];
        }
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
        '$baseUrl/kb-core/v1/ai-assistant',
        data: data,
        options: Options(
          headers: {
            'x-jarvis-guid': guid,
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print(response.data);
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

  Future<List<Knowledge>> getKnowledgesInAssistant(
    String assistantId, {
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
        '$baseUrl/kb-core/v1/ai-assistant/$assistantId/knowledges',
        queryParameters: queryParams,
        options: Options(
          headers: {
            'x-jarvis-guid': guid,
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);
        if (response.data != null && response.data['data'] != null) {
          final List<dynamic> dataList = response.data['data'];
          return dataList
              .map((json) => Knowledge.fromJson(json))
              .toList();
        } else {
          return [];
        }
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

  Future<void> importKnowledgeToAssistant(String assistantId, String knowledgeBaseId) async {
    final accessToken = await StorageService().readSecureData('access_token');
    final response = await _dio.post(
      '$baseUrl/kb-core/v1/ai-assistant/$assistantId/knowledges/$knowledgeBaseId',
      options: Options(
        headers: {
          'x-jarvis-guid': guid,
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to import knowledge to assistant');
    }
  }

  Future<void> removeKnowledgeFromAssistant(String assistantId, String knowledgeBaseId) async {
    final accessToken = await StorageService().readSecureData('access_token');

    final response = await _dio.delete(
      '$baseUrl/kb-core/v1/ai-assistant/$assistantId/knowledges/$knowledgeBaseId',
      options: Options(
        headers: {
          'x-jarvis-guid': guid,
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove knowledge from assistant');
    }
  }
}
