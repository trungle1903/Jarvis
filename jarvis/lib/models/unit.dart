class Unit {
  final String id;
  final String name;
  final String type; // e.g., 'pdf', 'txt', derived from mimeType
  final double size; // Size in KB
  bool enabled;

  Unit({
    required this.id,
    required this.name,
    required this.type,
    required this.size,
    this.enabled = true,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    // Extract file type from metadata.mimeType (e.g., 'application/pdf' → 'pdf')
    final mimeType = json['metadata']?['mimeType'] as String? ?? 'application/octet-stream';
    final fileType = mimeType.split('/').last.toLowerCase();

    return Unit(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: fileType,
      size: (json['size'] as int? ?? 0) / 1024.0, // Convert bytes to KB
      enabled: json['status'] as bool? ?? true,
    );
  }
}