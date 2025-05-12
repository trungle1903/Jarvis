class ChatResponse {
  final String conversationId;
  final String message;
  final int? remainingUsage;

  ChatResponse({
    required this.conversationId,
    required this.message,
    this.remainingUsage,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      conversationId: json['conversationId'],
      message: json['message'],
      remainingUsage: json['remainingUsage'],
    );
  }
}
