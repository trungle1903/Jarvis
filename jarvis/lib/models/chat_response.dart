import 'package:jarvis/models/assistant.dart';
import 'package:jarvis/models/conversation_metadata.dart';

class ChatResponse {
  final String content;
  final List<dynamic> files;
  final ConversationMetadata metadata;
  final Assistant assistant;

  ChatResponse({
    required this.content,
    required this.files,
    required this.metadata,
    required this.assistant,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      content: json['content'],
      files: json['files'] ?? [],
      metadata: ConversationMetadata.fromJson(json['metadata']['conversation']),
      assistant: Assistant.fromJson(json['assistant']),
    );
  }
}
