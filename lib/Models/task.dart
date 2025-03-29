class Task {
  final String id;
  final String title;
  final DateTime dueDate;
  final String priority;
  bool completed;

  Task({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.priority,
    this.completed = false,
  });
}