import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jarvis/models/prompt.dart';
import 'package:jarvis/services/header_service.dart';
import 'package:jarvis/services/storage.dart';

class PromptApiService {
  final Dio _dio;
  final HeaderService _headerService;
  String baseUrl = dotenv.get('APP_API_BASE_URL');
  String guid = dotenv.get('X_JARVIS_GUID');

  PromptApiService({required Dio dio, required HeaderService headerService})
      : _dio = dio,
        _headerService = headerService;

Future<List<Prompt>> getPrompts({
  String? query,
  String? category,
  bool? isFavorite,
  bool? isPublic,
  int offset = 0,
  int limit = 3,
}) async {
  try {
    final accessToken = await StorageService().readSecureData('access_token');

    final queryParams = {
      if (query != null) 'query': query,
      if (category != null && category != 'all') 'category': category,
      if (isFavorite != null) 'isFavorite': isFavorite,
      if (isPublic != null) 'isPublic': isPublic,
      'offset': offset,
      'limit': limit,
    };

    final response = await _dio.get(
      '$baseUrl/api/v1/prompts',
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
        .map((json) => Prompt.fromJson(json))
        .toList();
    }
    else {
      return [];
    }
  } on DioException catch (e) {
    print('Status Code: ${e.response?.statusCode}');
    throw Exception('Failed to fetch prompts: ${e.response?.data?['message'] ?? e.message}');
  } catch (e) {
    print('Error: $e');
    throw Exception('Unexpected error: $e');
  }
}

  Future<void> toggleFavorite(String promptId) async {
    await _dio.post('$baseUrl/prompts/$promptId/favorite');
  }

  Future<Prompt> createPrompt(Map<String, dynamic> data) async {
    final response = await _dio.post('$baseUrl/prompts', data: data);
    return Prompt.fromJson(response.data);
  }
}