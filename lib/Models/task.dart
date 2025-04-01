import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime dueDate;

  @HiveField(2)
  String priority;

  @HiveField(3)
  bool completed;

  Task({
    required this.title,
    required this.dueDate,
    this.priority = 'medium',
    this.completed = false,
  });

  // Essential copyWith method
  Task copyWith({
    String? title,
    DateTime? dueDate,
    String? priority,
    bool? completed,
  }) {
    return Task(
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      completed: completed ?? this.completed,
    );
  }
}
