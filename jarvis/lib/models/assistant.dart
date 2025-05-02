class Assistant {
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String updatedBy;
  final String assistantName;
  final String openAiAssistantId;
  final String instructions;
  final String description;
  final String openAiThreadIdPlay;

  Assistant({
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.assistantName,
    required this.openAiAssistantId,
    required this.instructions,
    required this.description,
    required this.openAiThreadIdPlay,
  });

  factory Assistant.fromJson(Map<String, dynamic> json) {
    return Assistant(
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      assistantName: json['assistantName'],
      openAiAssistantId: json['openAiAssistantId'],
      instructions: json['instructions'],
      description: json['description'],
      openAiThreadIdPlay: json['openAiThreadIdPlay'],
    );
  }
}
