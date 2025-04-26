import 'package:jarvis/models/assistant.dart';

class ChatMessage {
  final String role;
  final String content;
  final List<dynamic> files;
  final Assistant assistant;

  ChatMessage({
    required this.role,
    required this.content,
    required this.files,
    required this.assistant,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'],
      content: json['content'],
      files: json['files'] ?? [],
      assistant: Assistant.fromJson(json['assistant']),
    );
  }

  Map<String, dynamic> toJson() => {
    'role': role,
    'content': content,
    'files': files,
    'assistant': assistant.toJson(),
  };
}
