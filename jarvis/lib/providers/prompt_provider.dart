import 'package:flutter/material.dart';
import 'package:jarvis/models/prompt.dart';
import 'package:jarvis/models/user.dart';
import 'package:jarvis/services/api/prompt_api_service.dart';
import 'package:jarvis/services/storage.dart';

class PromptProvider with ChangeNotifier {
  final PromptApiService _apiService;
  PromptApiService get api => _apiService;
  List<Prompt> _publicPrompts = [];
  List<Prompt> _myPrompts = [];

  PromptProvider(this._apiService);

  List<Prompt> get publicPrompts => _publicPrompts;
  List<Prompt> get myPrompts => _myPrompts;

  Future<void> loadPrompts({
    String? query,
    String? category,
    bool? isFavorite,
    bool? isPublic,
  }) async {
    try {
      final username = await StorageService().readSecureData('user_name');
      final prompts = await _apiService.getPrompts(
        query: query,
        category: category,
        isFavorite: isFavorite,
        isPublic: isPublic,
      );
      _publicPrompts = prompts.where((p) => p.isPublic).toList();
      _myPrompts = prompts.where((p) => p.userName == username).toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void addPrompt(Prompt prompt) {
    if (prompt.isPublic) {
      _publicPrompts.insert(0, prompt);
    } else {
      _myPrompts.insert(0, prompt);
    }
    notifyListeners();
  }

  void updatePrompts(List<Prompt> prompts, {bool isPublic = true}) {
    if (isPublic) {
      _publicPrompts = prompts;
    } else {
      _myPrompts = prompts;
    }
    notifyListeners();
  }

}