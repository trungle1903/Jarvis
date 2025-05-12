import 'package:flutter/material.dart';
import 'package:jarvis/components/messageTile.dart';
import 'package:jarvis/services/api/email_api_service.dart';

class EmailProvider with ChangeNotifier {
  final EmailApiService _apiService;
  final List<MessageTile> _messages = [];
  final List<String> _suggestedReplies = [];
  Map<String, dynamic>? _lastEmailInfo;
  final Map<int, List<String>> _improveActions = {};
  String _emailToken = '';

  EmailProvider(this._apiService);

  List<MessageTile> get messages => _messages;
  List<String> get suggestedReplies => _suggestedReplies;
  Map<String, dynamic>? get lastEmailInfo => _lastEmailInfo;

  bool isIdeaMessage(int index) => _messages[index].message == 'Here are 3 ideas to reply to this email';

  bool isEmailMessage(int index) => _messages[index].isAI && !isIdeaMessage(index);

  List<String>? getImproveActions(int index) => _improveActions[index];
  String getEmailToken() => _emailToken;

  bool isImproved = false;

  Future<bool> emailResponse({
    required String subject,
    required String sender,
    required String receiver,
    required String language,
    required String mainIdea,
    required String action,
    required String emailContent,
    required Map<String, String> style,
  }) async {
    if (mainIdea.trim().isEmpty) return false;

    String messageToAdd = isImproved ? action : mainIdea;
    _messages.add(MessageTile(isAI: false, message: messageToAdd));
    isImproved = !isImproved;
    notifyListeners();

    try {
      final response = await _apiService.generateEmail(
        subject: subject,
        sender: sender,
        receiver: receiver,
        language: language,
        mainIdea: mainIdea,
        action: action,
        emailContent: emailContent,
        style: style,
      );

      _messages.add(
        MessageTile(
          isAI: true,
          message: response['email'] ?? 'No email generated',
          aiLogo: 'assets/logos/jarvis.png',
          aiName: 'Jarvis',
        ),
      );
      _emailToken = response['remainingUsage'] ?? '';
      _improveActions[_messages.length - 1] = response['improvedActions'] ?? [];
      _lastEmailInfo = {
        'subject': subject,
        'sender': sender,
        'receiver': receiver,
        'mainIdea': mainIdea,
        'action': action,
        'emailContent': emailContent,
        'language': language,
        'style': style,
      };
      notifyListeners();
      return true;
    } catch (e) {
      _messages.add(
        MessageTile(
          isAI: true,
          message: 'Error generating email: $e',
          aiLogo: 'assets/logos/jarvis.png',
          aiName: 'Jarvis',
        ),
      );
      notifyListeners();
      return false;
    }
  }

  Future<bool> replyIdea({
    required String subject,
    required String sender,
    required String receiver,
    required String language,
    required String emailContent,
  }) async {
    if (emailContent.trim().isEmpty) return false;

    try {
      final ideas = await _apiService.generateIdea(
        subject: subject,
        sender: sender,
        receiver: receiver,
        language: language,
        emailContent: emailContent,
      );

      _suggestedReplies.clear();
      _suggestedReplies.addAll(ideas);
      _messages.add(
        MessageTile(
          isAI: true,
          message: 'Here are 3 ideas to reply to this email',
          aiLogo: 'assets/logos/jarvis.png',
          aiName: 'Jarvis',
        ),
      );
      _lastEmailInfo = {
        'subject': subject,
        'sender': sender,
        'receiver': receiver,
        'mainIdea': '',
        'action': 'Generate email',
        'emailContent': emailContent,
        'language': language,
        'style': <String, String>{},
      };
      notifyListeners();
      return true;
    } catch (e) {
      _messages.add(
        MessageTile(
          isAI: true,
          message: 'Error generating reply ideas: $e',
          aiLogo: 'assets/logos/jarvis.png',
          aiName: 'Jarvis',
        ),
      );
      notifyListeners();
      return false;
    }
  }

  void setLastEmailInfo(Map<String, dynamic> emailInfo) {
    _lastEmailInfo = emailInfo;
    notifyListeners();
  }
}
