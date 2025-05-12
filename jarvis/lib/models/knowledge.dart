class Knowledge {
  final String id;
  final String knowledgeName;
  final String description;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? deletedAt;
  final int numUnits;
  final int totalSize;

  Knowledge({
    required this.id,
    required this.knowledgeName,
    required this.description,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
    required this.numUnits,
    required this.totalSize,
  });

factory Knowledge.fromJson(Map<String, dynamic> json) {
  return Knowledge(
    id: json['id'] ?? '',
    knowledgeName: json['knowledgeName'] ?? '',
    description: json['description'] ?? '',
    userId: json['userId'] ?? '',
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    createdBy: json['createdBy'] as String?,
    updatedBy: json['updatedBy'] as String?,
    deletedAt: (json['deletedAt'] != null && json['deletedAt'] != '')
        ? DateTime.parse(json['deletedAt'])
        : null,
    numUnits: (json['numUnits'] is int) ? json['numUnits'] : int.tryParse(json['numUnits']?.toString() ?? '0') ?? 0,
    totalSize: (json['totalSize'] is int) ? json['totalSize'] : int.tryParse(json['totalSize']?.toString() ?? '0') ?? 0,
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'knowledgeName': knowledgeName,
      'description': description,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'deletedAt': deletedAt?.toIso8601String(),
      'numUnits': numUnits,
      'totalSize': totalSize,
    };
  }
}
