class Task {
  final int? id;
  final String title;
  final String description;
  final String priority; // Low, Medium, High
  final String dueDate;
  final int isCompleted; // 0 = false, 1 = true

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    this.isCompleted = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'dueDate': dueDate,
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      priority: map['priority'],
      dueDate: map['dueDate'],
      isCompleted: map['isCompleted'],
    );
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? priority,
    String? dueDate,
    int? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
