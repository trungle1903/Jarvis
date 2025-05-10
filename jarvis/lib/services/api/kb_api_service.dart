import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jarvis/models/assistant.dart';
import 'package:jarvis/models/knowledge.dart';
import 'package:jarvis/models/unit.dart';
import 'package:jarvis/services/header_service.dart';
import 'package:jarvis/services/storage.dart';

class KnowledgeBaseApiService {
  final Dio _dio;
  final HeaderService _headerService;
  String baseUrl = dotenv.get('KB_API_BASE_URL');
  String guid = dotenv.get('KB_X_JARVIS_GUID');

  KnowledgeBaseApiService({required Dio dio, required HeaderService headerService})
    : _dio = dio,
      _headerService = headerService;

  Future<List<Knowledge>> getKnowledges({
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
        '$baseUrl/kb-core/v1/knowledge',
        queryParameters: queryParams,
        options: Options(
          headers: {
            'x-jarvis-guid': guid,
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['data'] != null) {
          final List<dynamic> dataList = response.data['data'];
          return dataList.map((json) => Knowledge.fromJson(json))
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
        'Failed to fetch knowledges: ${e.response?.data?['message'] ?? e.message}',
      );
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Knowledge> createKnowledgeBase(Map<String, dynamic> data) async {
    try {
      final accessToken = await StorageService().readSecureData('access_token');

      final response = await _dio.post(
        '$baseUrl/kb-core/v1/knowledge',
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
        return Knowledge.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to create KB: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('Status Code: ${e.response?.statusCode}');
      throw Exception(
        'Failed to create KB: ${e.response?.data?['message'] ?? e.message}',
      );
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> deleteKnowledgeBase(String id) async {
    final accessToken = await StorageService().readSecureData('access_token');
    await _dio.delete(
      '$baseUrl/kb-core/v1/knowledge/$id',
      options: Options(
        headers: {
          'x-jarvis-guid': guid,
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
  }

  Future<Knowledge> updateKnowledgeBase({
    required String id,
    required String name,
    required String description,
  }) async {
    final accessToken = await StorageService().readSecureData('access_token');
    final response = await _dio.patch(
      '$baseUrl/kb-core/v1/knowledge/$id',
      data: {
        'knowledgeName': name,
        'description': description,
      },
      options: Options(
        headers: {
          'x-jarvis-guid': guid,
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
    print(response.data);
    return Knowledge.fromJson(response.data);
  }

  Future<List<Unit>> getKnowledgeUnits(
    {
    String? query,
    String? order,
    String? order_field,
    bool? isFavorite,
    bool? isPublic,
    int offset = 0,
    int limit = 20, 
    required String id,
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
        '$baseUrl/kb-core/v1/knowledge/$id/datasources',
        queryParameters: queryParams,
        options: Options(
          headers: {
            'x-jarvis-guid': guid,
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['data'] != null) {
          print(response.data);
          final List<dynamic> dataList = response.data['data'];
          return dataList.map((json) => Unit.fromJson(json))
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
        'Failed to fetch knowledges: ${e.response?.data?['message'] ?? e.message}',
      );
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  String getMimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'txt':
        return 'text/plain';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'md':
        return 'text/markdown';
      default:
        return 'application/octet-stream';
    }
  }

  Future<String> uploadLocalFile({
    String? filePath,
    String? fileName,
    Uint8List? fileBytes,
  }) async {
    try {
      final accessToken = await StorageService().readSecureData('access_token');
      if (accessToken == null) {
        throw Exception('Access token is missing');
      }

      FormData formData;
      String resolvedFileName;
      if (kIsWeb) {
        if (fileName == null || fileBytes == null) {
          throw Exception('File name and bytes are required for web upload');
        }
        resolvedFileName = fileName;
        formData = FormData.fromMap({
          'files': MultipartFile.fromBytes(fileBytes, filename: fileName, contentType: DioMediaType.parse(getMimeType(fileName))),
        });
      } else {
        if (filePath == null) {
          throw Exception('File path is required for non-web upload');
        }
        resolvedFileName = filePath.split('/').last;
        formData = FormData.fromMap({
          'files': await MultipartFile.fromFile(filePath, filename: fileName, contentType: DioMediaType.parse(getMimeType(resolvedFileName))),
        });
      }

      final response = await _dio.post(
        '$baseUrl/kb-core/v1/knowledge/files',
        data: formData,
        options: Options(
          headers: {
            'x-jarvis-guid': guid,
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final files = response.data['files'];
        if (files != null && files.isNotEmpty) {
          return files[0]['id'];
        } else {
          throw Exception('No files returned in response: ${response.data}');
        }
      } else {
        throw Exception('File upload failed: ${response.statusCode} ${response.data}');
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        print('DioException: ${e.message}');
        print('Response data: ${e.response?.data}');
        print('Response status: ${e.response?.statusCode}');
        throw Exception('File upload failed: ${e.response?.statusCode} ${e.response?.data}');
      }
      print('Error in uploadLocalFile: $e');
      rethrow;
    }
  }

  Future<void> linkFileToKnowledgeBase({
    required String knowledgeBaseId,
    required String fileId,
    required String fileName,
  }) async {
    final accessToken = await StorageService().readSecureData('access_token');

    final data = {
      "datasources": [
        {
          "name": fileName,
          "type": "local_file",
         "credentials": {
            "email": "string",
            "file": fileId,
            "info": {},
            "password": "string",
            "token": "string",
            "url": "string",
            "username": "string",
            "type": "string"
         }
        }
      ]
    };

    final response = await _dio.post(
      '$baseUrl/kb-core/v1/knowledge/$knowledgeBaseId/datasources',
      data: data,
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'x-jarvis-guid': guid,
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to link local file');
    }
  }

  Future<void> updateUnit(String knowledgeId, String unitId, bool enabled) async {
    try {
      final accessToken = await StorageService().readSecureData('access_token');
      if (accessToken == null) {
        throw Exception('Access token is missing');
      }

      final response = await _dio.patch(
        '$baseUrl/kb-core/v1/knowledge/$knowledgeId/datasources/$unitId',
        data: {'status': enabled},
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'x-jarvis-guid': guid,
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to update unit: ${response.statusCode} ${response.data}');
      }
    } catch (e) {
      print('Error in updateUnit: $e');
      rethrow;
    }
  }

  Future<void> deleteUnit(String knowledgebaseId, String unitId) async {
    try {
      final accessToken = await StorageService().readSecureData('access_token');
      if (accessToken == null) {
        throw Exception('Access token is missing');
      }

      final response = await _dio.delete(
        '$baseUrl/kb-core/v1/knowledge/$knowledgebaseId/datasources/$unitId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'x-jarvis-guid': guid,
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete unit: ${response.statusCode} ${response.data}');
      }
    } catch (e) {
      print('Error in deleteUnit: $e');
      rethrow;
    }
  }
}
