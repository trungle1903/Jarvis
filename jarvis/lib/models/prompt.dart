class Prompt {
  final String id;
  final String category;
  final String title;
  final String content;
  final String description;
  final bool isPublic;
  bool isFavorite;
  final String language;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userName;

  Prompt({
    required this.id,
    required this.category,
    required this.title,
    required this.content,
    required this.description,
    required this.isPublic,
    required this.isFavorite,
    required this.language,
    required this.createdAt,
    required this.updatedAt,
    required this.userName,
  });

  factory Prompt.fromJson(Map<String, dynamic> json) {
    return Prompt(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      isPublic: json['isPublic'] ?? true,
      isFavorite: json['isFavorite'] ?? false,
      language: json['language'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      userName: json['userName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'category': category,
      'description': description,
      'isPublic': isPublic,
    };
  }
}