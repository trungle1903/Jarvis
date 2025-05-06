class Assistant {
  final String id;
  final String createdAt;
  final String updatedAt;
  final String? createdBy;
  final String? updatedBy;
  final String assistantName;
  final String openAiAssistantId;
  final String instructions;
  final String description;
  final String openAiThreadIdPlay;

  Assistant({
    required this.id,
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
      id: json['id'] ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      createdBy: json['createdBy'] ?? 'Anonymous',
      updatedBy: json['updatedBy'] ?? 'Anonymous',
      assistantName: json['assistantName'] ?? '',
      openAiAssistantId: json['openAiAssistantId'] ?? '',
      instructions: json['instructions'] ?? 'No instructions available',
      description: json['description'] ?? 'No description available',
      openAiThreadIdPlay: json['openAiThreadIdPlay'] ?? '',
    );
  }
}
