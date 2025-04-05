class Assistant {
  final String model;
  final String name;
  final String id;

  Assistant({required this.model, required this.name, required this.id});

  factory Assistant.fromJson(Map<String, dynamic> json) {
    return Assistant(model: json['model'], name: json['name'], id: json['id']);
  }

  Map<String, dynamic> toJson() => {'model': model, 'name': name, 'id': id};
}
