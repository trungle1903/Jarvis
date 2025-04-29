// providers/chat_provider.dart
import 'package:flutter/foundation.dart';
import 'package:jarvis/models/assistant.dart';
import 'package:jarvis/models/chat_message.dart';
import 'package:jarvis/models/conversation.dart';
import 'package:jarvis/services/api/chat_api_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatApiService _apiService;
  List<ChatMessage> _messages = [];
  List<Conversation> _history = [];
  bool _isLoading = false;
  String? _error;
  String? _conversationId;

  ChatProvider(this._apiService);

  List<ChatMessage> get messages => _messages;
  List<Conversation> get history => _history;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get conversationId => _conversationId;

  Future<void> sendMessage({
    required String message,
    required String assistantId,
    required String assistantName,
    String? conversationId,
    List<dynamic> files = const [],
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _messages.add(
        ChatMessage(
          role: 'user',
          content: message,
          files: files,
          assistant: Assistant(
            model: 'knowledge-base',
            name: 'User',
            id: 'user-${DateTime.now().millisecondsSinceEpoch}',
          ),
        ),
      );
      notifyListeners();

      final response = await _apiService.sendMessage(
        message: message,
        conversationId: conversationId ?? 'new-conversation',
        assistantId: assistantId,
        assistantName: assistantName,
        files: files,
      );

      _conversationId = response.conversationId;
      _messages.add(
        ChatMessage(
          role: 'model',
          content: response.message,
          files: [],
          assistant: Assistant(
            model: 'dify',
            name: assistantName,
            id: assistantId,
          ),
        ),
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
      if (_messages.isNotEmpty && _messages.last.role == 'user') {
        _messages.removeLast();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearConversation() {
    _messages.clear();
    _error = null;
    _conversationId = null;
    notifyListeners();
  }

  Future<void> loadHistory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final conversations = await _apiService.getConversations();
      _history = conversations;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
