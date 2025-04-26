import 'package:jarvis/models/chat_message.dart';

class ConversationMetadata {
  final List<ChatMessage> messages;

  ConversationMetadata({required this.messages});

  factory ConversationMetadata.fromJson(Map<String, dynamic> json) {
    return ConversationMetadata(
      messages:
          (json['messages'] as List)
              .map((msg) => ChatMessage.fromJson(msg))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'messages': messages.map((msg) => msg.toJson()).toList(),
  };
}
