import 'dart:convert';

enum TaskStatus { todo, inProgress, done }

class Task {
  String id;
  String title;
  String description;
  DateTime dueDate;
  TaskStatus status;
  String? blockedBy;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.status = TaskStatus.todo,
    this.blockedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': status.index,
      'blockedBy': blockedBy,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : DateTime.now(),
      status: map['status'] != null ? TaskStatus.values[map['status']] : TaskStatus.todo,
      blockedBy: map['blockedBy'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));
}
