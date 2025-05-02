class Bot {
  final String model;
  final String name;
  final String id;

  Bot({required this.model, required this.name, required this.id});

  factory Bot.fromJson(Map<String, dynamic> json) {
    return Bot(model: json['model'], name: json['name'], id: json['id']);
  }

  Map<String, dynamic> toJson() => {'model': model, 'name': name, 'id': id};
}
