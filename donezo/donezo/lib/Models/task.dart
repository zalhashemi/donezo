import 'package:hive/hive.dart';

part 'task.g.dart';

// This is a model class for a task in the Donezo app

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String? description;
  @HiveField(3)
  DateTime dueDate;
  @HiveField(4)
  String priority;
  @HiveField(5)
  bool completed;

  Task({
    required this.id,
    required this.title,
    required this.dueDate,
    this.description = '',
    this.priority = 'medium',
    this.completed = false,
  });

  // Update copyWith
  Task copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    String? priority,
    bool? completed,
    String? id,
  }) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      completed: completed ?? this.completed,
      id: id ?? this.id,
    );
  }
}
