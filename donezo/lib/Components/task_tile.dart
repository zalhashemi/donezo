import 'package:donezo/Models/task.dart';
import 'package:donezo/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// This is a custom task tile widget that displays a task with its details
// It takes a task, a delete function, and a check function as parameters
// It is used to create a list of tasks with specific functionality
// It also allows the user to delete or check off a task
class TaskTile extends StatefulWidget {
  final Task task;
  final VoidCallback onDelete;
  final ValueChanged<Task> onCheck;

  const TaskTile({
    Key? key,
    required this.task,
    required this.onDelete,
    required this.onCheck,
  }) : super(key: key);

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  // This method returns a color based on the task's priority
  // It uses a switch statement to check the priority and return the corresponding color
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

  // This method returns the priority indicator text
  // It uses a switch statement to return the appropriate number of exclamation marks
  String _getPriorityText() {
    switch (widget.task.priority.toLowerCase()) {
      case 'high':
        return '!!!';
      case 'medium':
        return '!!';
      case 'low':
        return '!';
      default:
        return '!';
    }
  }

  // This method handles the checkbox change event
  // It updates the task's completed status and saves it to the database
  // It also calls the onCheck function to update the task in the list
  void _handleCheckboxChange(bool? value) {
    if (value == null) return;
    setState(() => widget.task.completed = value);
    widget.task.save();
    widget.onCheck(widget.task);
  }

  // This method shows the task details in a dialog
  // It displays the title, priority, description, and due date
  // The user can close the dialog using the X button in the top-right corner
  void _showTaskDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(30),
        content: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Centered task title
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.task.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      fontFamily: 'Baloo',
                    ),
                  ),
                ),

                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('EEEE d MMMM, yyyy')
                          .format(widget.task.dueDate),
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondary,
                        fontFamily: 'Baloo 2',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  'Description:',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Baloo 2',
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  // Handle both null and empty cases safely
                  (widget.task.description?.isEmpty ?? true)
                      ? 'No description provided'
                      : widget.task.description!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                    fontFamily: 'Baloo 2',
                  ),
                ),
                SizedBox(height: 20),
                // Priority display with color
                Center(
                  child: Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                      color: _getPriorityColor(),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.task.priority[0].toUpperCase() +
                          widget.task.priority.substring(1),
                      style: const TextStyle(
                        fontFamily: 'Baloo 2',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Close button positioned in top-right
            Positioned(
              top: -10,
              right: -10,
              child: IconButton(
                icon: const Icon(Icons.close),
                color: Colors.grey[600],
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      // This is a dismissible widget that allows the user to swipe to delete the task
      // It takes a key, a direction, a background, and a confirmDismiss function as parameters
      // The key is used to identify the widget, the direction is the swipe direction,
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
      confirmDismiss: (direction) async => await showDialog(
        // This is a dialog that asks the user to confirm the deletion of the task
        // It takes a context and a builder function as parameters
        context: context,
        builder: (context) => AlertDialog(
          title: Center(
            child: Text("Confirm Delete",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.secondary)),
          ),
          content: const Text("Are you sure you want to delete this task?",
              style: TextStyle(fontSize: 18)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
            ),
          ],
        ),
      ),
      onDismissed: (direction) => widget.onDelete(),
      child: GestureDetector(
        // This gesture detector now shows task details on tap
        // while maintaining checkbox functionality through separate handling
        onTap: () => _showTaskDetails(context),
        child: Container(
          height: 40,
          width: 350,
          decoration: BoxDecoration(
            color: Theme.of(context).ourGrey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
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
                        // This is the theme data for the checkbox
                        // It sets the shape, side, splash radius, and material tap target size
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
                        onChanged: _handleCheckboxChange,
                        activeColor: Colors.transparent,
                        checkColor: const Color(0xFFF8C631),
                        fillColor: WidgetStateProperty.all(Colors.transparent),
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
                    decorationThickness: 2.0,
                  ),
                ),
              ]),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(
                  children: [
                    // Priority indicator text with dynamic color

                    Text(
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
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getPriorityText(),
                      style: TextStyle(
                        color: _getPriorityColor(),
                        fontFamily: 'Baloo 2',
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
