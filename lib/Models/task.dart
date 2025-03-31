import 'package:hive/hive.dart';

part 'task.g.dart'; // This will be generated

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  DateTime dueDate;

  @HiveField(3)
  String priority;

  @HiveField(4)
  bool completed;

  Task({
    required this.id,
    required this.title,
    required this.dueDate,
    this.priority = 'medium',
    this.completed = false,
  });
}
