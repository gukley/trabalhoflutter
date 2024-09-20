class Task {
  String? title;
  String? description;
  bool? isDone;
  String? priority;

  Task({
    required this.title,
    required this.description,
    this.isDone = false,
    this.priority = 'Baixa',
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
      'priority': priority,
    };
  }

  Task.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    isDone = json['isDone'] ?? false;
    priority = json['priority'] ?? 'Baixa';
  }
}
