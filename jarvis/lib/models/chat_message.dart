import 'package:jarvis/models/assistant.dart';

class ChatMessage {
  final String role;
  final String content;
  final List<dynamic> files;
  final Assistant assistant;
  final DateTime createdAt;

  ChatMessage({
    required this.role,
    required this.content,
    required this.files,
    required this.assistant,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'],
      content: json['content'],
      files: json['files'] ?? [],
      assistant: Assistant.fromJson(json['assistant']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'role': role,
    'content': content,
    'files': files,
    'assistant': assistant.toJson(),
  };

  factory ChatMessage.fromUser(String query, DateTime createdAt) {
    return ChatMessage(
      role: 'user',
      content: query,
      files: [],
      assistant: Assistant(id: 'user', name: 'User', model: 'user'),
      createdAt: createdAt,
    );
  }

  factory ChatMessage.fromAssistant(String answer, DateTime createdAt) {
    return ChatMessage(
      role: 'model',
      content: answer,
      files: [],
      assistant: Assistant(
        id: 'assistant',
        name: 'Jarvis',
        model: 'dify', // or whatever model you use
      ),
      createdAt: createdAt,
    );
  }
}
