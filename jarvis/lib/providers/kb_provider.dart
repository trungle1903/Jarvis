import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jarvis/models/knowledge.dart';
import 'package:jarvis/models/unit.dart';
import 'package:jarvis/services/api/kb_api_service.dart';

class KnowledgeBaseProvider with ChangeNotifier {
  final KnowledgeBaseApiService _apiService;
  KnowledgeBaseApiService get api => _apiService;

  KnowledgeBaseProvider(this._apiService);

  List<Knowledge> _knowledges = [];
  bool _isLoading = false;
  String? _errorMessage;
  List<Unit> _units = [];
  bool _isUploading = false;

  List<Knowledge> get knowledges => _knowledges;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Unit> get units => _units;
  bool get isUploading => _isUploading;

  Future<void> fetchKnowledges({
    String? query,
    String? order,
    String? orderField,
    bool? isFavorite,
    bool? isPublic,
    int offset = 0,
    int limit = 20,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _knowledges = await _apiService.getKnowledges(
        query: query,
        order: order,
        order_field: orderField,
        isFavorite: isFavorite,
        isPublic: isPublic,
        offset: offset,
        limit: limit,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createKnowledgeBase({
    required String name,
    String? description,
  }) async {
    try {
      final newKnowledge = await _apiService.createKnowledgeBase({
        'knowledgeName': name,
        if (description != null && description.isNotEmpty)
          'description': description,
      });

      knowledges.insert(0, newKnowledge);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateKnowledgeBase({
    required String id,
    required String name,
    required String description,
  }) async {
    try {
      final updatedKnowledge = await _apiService.updateKnowledgeBase(
        id: id,
        name: name,
        description: description,
      );

      final index = knowledges.indexWhere((a) => a.id == id);
      if (index != -1) {
        knowledges[index] = updatedKnowledge;
        notifyListeners();
      }

      return true;
    } catch (e) {
      print('Update KB failed: $e');
      _errorMessage = 'Failed to update KB.';
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchKnowledgeUnits(
    String id, {
    String? query,
    String? order,
    String? orderField,
    bool? isFavorite,
    bool? isPublic,
    int offset = 0,
    int limit = 20,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _units = await _apiService.getKnowledgeUnits(
        id: id,
        query: query,
        order: order,
        order_field: orderField,
        isFavorite: isFavorite,
        isPublic: isPublic,
        offset: offset,
        limit: limit,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> importLocalFile({
    String? filePath,
    String? fileName,
    Uint8List? fileBytes,
  }) async {
    _isUploading = true;
    notifyListeners();

    try {
      if (kIsWeb) {
        if (fileName == null || fileBytes == null) {
          throw Exception('File name and bytes are required for web upload');
        }
        final fileId = await _apiService.uploadLocalFile(
          fileName: fileName,
          fileBytes: fileBytes,
        );
        return fileId;
      } else {
        if (filePath == null) {
          throw Exception('File path is required for non-web upload');
        }
        final fileId = await _apiService.uploadLocalFile(filePath: filePath);
        return fileId;
      }
    } catch (e) {
      rethrow;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  Future<void> linkFileToKnowledgeBase({
    required String knowledgeBaseId,
    required String fileId,
    required String fileName,
  }) async {
    _isUploading = true;
    notifyListeners();

    try {
      await _apiService.linkFileToKnowledgeBase(
        knowledgeBaseId: knowledgeBaseId,
        fileId: fileId,
        fileName: fileName,
      );
    } catch (e) {
      rethrow;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
}
