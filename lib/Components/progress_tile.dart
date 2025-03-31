import 'package:donezo/Components/dropdown.dart';
import 'package:donezo/theme.dart';
import 'package:flutter/material.dart';
import 'package:donezo/Models/task.dart';

class ProgressTile extends StatefulWidget {
  final List<Task> tasks;
  const ProgressTile({super.key, required this.tasks});

  @override
  State<ProgressTile> createState() => _ProgressTileState();
}

class _ProgressTileState extends State<ProgressTile> {
  double get progressPercentage {
    if (widget.tasks.isEmpty) return 0;
    final completed = widget.tasks.where((t) => t.completed).length;
    return completed / widget.tasks.length;
  }

  String get progressMessage {
    if (widget.tasks.isEmpty) return 'Start adding tasks to make progress!';
    if (progressPercentage == 1) return 'All tasks completed! 🎉';
    if (progressPercentage > 0.5) return 'You\'re almost done. Keep going!';
    return 'Keep making progress! 💪';
  }

  @override
  Widget build(BuildContext context) {
    final completedTasks = widget.tasks.where((t) => t.completed).length;
    final totalTasks = widget.tasks.length;

    return Container(
      height: 125,
      width: 350,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF461E55), Color(0xFF906DB0)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 15),
            child: Text(
              'Today\'s Progress',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 40),
            child: Text(
              widget.tasks.isEmpty 
                  ? 'No tasks yet'
                  : '$completedTasks/$totalTasks Tasks Completed',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 60),
            child: Text(
              progressMessage,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Baloo 2',
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          if (widget.tasks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 90),
              child: Container(
                width: 270,
                height: 10,
                decoration: BoxDecoration(
                  color: Theme.of(context).ourGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: 270 * progressPercentage,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}