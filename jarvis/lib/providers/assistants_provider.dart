import 'package:flutter/material.dart';
import 'package:jarvis/models/assistant.dart';
import 'package:jarvis/services/api/assistants_api_service.dart';

class AssistantProvider with ChangeNotifier {
  final AssistantApiService _apiService;
  AssistantApiService get api => _apiService;

  AssistantProvider(this._apiService);

  List<Assistant> _assistants = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Assistant> get assistants => _assistants;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAssistants({
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
      _assistants = await _apiService.getAssistants(
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

  Future<bool> createAssistant({
    required String name,
    String? description,
    String? instructions,
  }) async {
    try {
      final newAssistant = await _apiService.createAssistant({
        'assistantName': name,
        if (description != null && description.isNotEmpty)
          'description': description,
        if (instructions != null && instructions.isNotEmpty)
          'instructions': instructions,
      });

      _assistants.insert(0, newAssistant);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
