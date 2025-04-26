import 'dart:convert';
import 'package:jarvis/models/assistant.dart';
import 'package:jarvis/models/conversation_metadata.dart';

class ChatResponse {
  final String content;
  final List<dynamic> files;
  final ConversationMetadata metadata;
  final Assistant assistant;
  final String conversationId;
  final int? remainingUsage;

  ChatResponse({
    required this.content,
    required this.files,
    required this.metadata,
    required this.assistant,
    required this.conversationId,
    this.remainingUsage,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      content: json['content'],
      files: json['files'] ?? [],
      metadata: ConversationMetadata.fromJson(json['metadata']['conversation']),
      assistant: Assistant.fromJson(json['assistant']),
      conversationId: json['metadata']['conversation']['conversation_id'],
      remainingUsage: null,
    );
  }

  factory ChatResponse.fromSSE(String rawData) {
    final lines = rawData.split('\n');
    final buffer = StringBuffer();
    String? conversationId;
    int? remainingUsage;

    for (var line in lines) {
      if (line.startsWith('data: ')) {
        final jsonPart = line.substring(6);
        final Map<String, dynamic> parsed = json.decode(jsonPart);

        if (parsed.containsKey('remainingUsage')) {
          remainingUsage = parsed['remainingUsage'];
        }
        if (parsed.containsKey('conversationId')) {
          conversationId = parsed['conversationId'];
        }
        if (parsed.containsKey('content')) {
          buffer.write(parsed['content']);
        }
      }
    }

    return ChatResponse(
      content: buffer.toString(),
      files: [],
      metadata: ConversationMetadata(messages: []),
      assistant: Assistant(
        id: '',
        name: '',
        model: '',
      ),
      conversationId: conversationId ?? '',
      remainingUsage: remainingUsage,
    );
  }
}
