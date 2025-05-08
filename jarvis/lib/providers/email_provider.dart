import 'package:flutter/material.dart';
import 'package:jarvis/components/messageTile.dart';
import 'package:jarvis/models/bot.dart';
import 'package:jarvis/services/api/email_api_service.dart';

class EmailProvider with ChangeNotifier {
  final EmailApiService _apiService;
  EmailApiService get api => _apiService;
  EmailProvider(this._apiService);
  
  final List<MessageTile> _messages = [];
  final List<Bot> _aiModels = [
    Bot(id: 'jarvis', name: 'Jarvis AI', model: 'jarvis'),
  ];
  late Bot _currentAssistant = _aiModels[0];

  List<MessageTile> get messages => _messages;
  List<Bot> get aiModels => _aiModels;
  Bot get currentAssistant => _currentAssistant;

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    _messages.add(MessageTile(isAI: false, message: message));
    notifyListeners();

    try {
      final response = await _apiService.generateEmail(message);
      _messages.add(
        MessageTile(
          isAI: true,
          message: response,
          aiLogo: _getAssistantLogo(_currentAssistant.model),
          aiName: _currentAssistant.name,
        ),
      );
    } catch (e) {
      _messages.add(
        MessageTile(
          isAI: true,
          message: 'Error generating email: $e',
          aiLogo: _getAssistantLogo(_currentAssistant.model),
          aiName: _currentAssistant.name,
        ),
      );
    }

    notifyListeners();
  }

  void handleModelChange(Bot newAssistant) {
    _currentAssistant = newAssistant;
    notifyListeners();
  }

  String _getAssistantLogo(String model) {
    switch (model) {
      case 'jarvis':
        return 'assets/logos/jarvis.png';
      default:
        return 'assets/logos/default_ai.png';
    }
  }
}