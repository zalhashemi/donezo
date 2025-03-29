import 'package:donezo/Components/progress_tile.dart';
import 'package:flutter/material.dart';
import 'package:donezo/Components/task_tile.dart';
import 'package:donezo/Models/task.dart';

class HomePage extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task) onTaskDeleted;
  final Function(Task, bool?) onTaskChecked;

  const HomePage({
    super.key,
    required this.tasks,
    required this.onTaskDeleted,
    required this.onTaskChecked,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final pendingTasks = widget.tasks.where((task) => !task.completed).toList();
    final completedTasks =
        widget.tasks.where((task) => task.completed).toList();

    pendingTasks.sort(_sortTasks);
    completedTasks.sort(_sortTasks);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF22162B), Color(0xFF451F55)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 700,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, top: 40),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Image.asset(
                            'lib/Images/dino.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 40),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Hello, user",
                            style: TextStyle(
                              fontSize: 36,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: ProgressTile(),
                  ),
                  _buildTaskSection(
                    title: "Pending Tasks",
                    tasks: pendingTasks,
                    isEmptyMessage: "You have no pending tasks!",
                  ),
                  _buildTaskSection(
                    title: "Completed Tasks",
                    tasks: completedTasks,
                    isEmptyMessage: "No completed tasks yet!",
                    topPadding: pendingTasks.isEmpty ? 40.0 : 20.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _sortTasks(Task a, Task b) {
    const priorityOrder = {'high': 1, 'medium': 2, 'low': 3};
    final priorityCompare = priorityOrder[a.priority.toLowerCase()]!
        .compareTo(priorityOrder[b.priority.toLowerCase()]!);
    return priorityCompare != 0
        ? priorityCompare
        : a.dueDate.compareTo(b.dueDate);
  }

  Widget _buildTaskSection({
    required String title,
    required List<Task> tasks,
    required String isEmptyMessage,
    double topPadding = 0,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 40.0, top: topPadding),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        tasks.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    isEmptyMessage,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            : SizedBox(
                height: tasks.length * 80.0,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 5,
                      ),
                      child: TaskTile(
                        key: ValueKey(task.id),
                        task: task, // Changed to pass whole task object
                        onDelete: () => widget.onTaskDeleted(task),
                        onCheck: (value) => widget.onTaskChecked(task, value),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
