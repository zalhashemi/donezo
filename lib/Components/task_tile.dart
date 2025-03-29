import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:donezo/Models/task.dart';
import 'package:donezo/theme.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  final VoidCallback onDelete;
  final ValueChanged<bool?> onCheck;

  const TaskTile({
    required Key key,
    required this.task,
    required this.onDelete,
    required this.onCheck,
  }) : super(key: key);

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  Color _getPriorityColor() {
    switch (widget.task.priority.toLowerCase()) {
      case 'high':
        return const Color(0xFFE64E6D);
      case 'medium':
        return const Color(0xFFF8C631);
      case 'low':
        return const Color(0xFF9747FF);
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: widget.key!,
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm Delete"),
            content: const Text(
              "Are you sure you want to delete this task?",
              style: TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Delete"),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) => widget.onDelete(),
      child: GestureDetector(
        onTap: () {}, // Add your onTap functionality if needed
        child: Container(
          height: 40,
          width: 350,
          decoration: BoxDecoration(
            color: Theme.of(context).ourGrey,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _getPriorityColor(),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF461E55), Color(0xFF724D90)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Theme(
                        data: ThemeData(
                          checkboxTheme: CheckboxThemeData(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: BorderSide.none,
                            splashRadius: 0,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        child: Checkbox(
                          value: widget.task.completed,
                          onChanged: widget.onCheck,
                          activeColor: Colors.transparent,
                          checkColor: const Color(0xFFF8C631),
                          fillColor:
                              WidgetStateProperty.all(Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.task.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Baloo 2',
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(widget.task.completed ? 0.5 : 1.0),
                      decoration: widget.task.completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: Theme.of(context).colorScheme.primary,
                      decorationThickness: 2.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text(
                  DateFormat('MMM d').format(widget.task.dueDate),
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Baloo 2',
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(widget.task.completed ? 0.5 : 1.0),
                    decoration: widget.task.completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: Theme.of(context).colorScheme.primary,
                    decorationThickness: 2.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
