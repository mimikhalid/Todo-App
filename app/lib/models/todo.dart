// ignore_for_file: non_constant_identifier_names

class Todo {
  int? id;
  final String title;
  final String description;
  final bool statusDone;
  final DateTime created_at;
  DateTime updated_at;

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.statusDone,
    required this.created_at,
    required this.updated_at,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      statusDone: json['statusDone'],
      created_at: DateTime.parse(json['created_at']),
      updated_at: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'statusDone': statusDone,
      'created_at': created_at.toIso8601String(), // Convert DateTime to ISO 8601 string
      'updated_at': updated_at.toIso8601String(), // Convert DateTime to ISO 8601 string
    };
  }
}
