import 'package:flutter/material.dart';
import 'package:jarvis/models/knowledge.dart';
import 'package:jarvis/services/api/kb_api_service.dart';

class KnowledgeBaseProvider with ChangeNotifier {
  final KnowledgeBaseApiService _apiService;
  KnowledgeBaseApiService get api => _apiService;

  KnowledgeBaseProvider(this._apiService);

  List<Knowledge> _knowledges = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Knowledge> get knowledges => _knowledges;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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
}
