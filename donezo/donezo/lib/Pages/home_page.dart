import 'package:donezo/Components/progress_tile.dart';
import 'package:donezo/Components/task_tile.dart';
import 'package:donezo/Data/database.dart';
import 'package:donezo/Models/task.dart';
import 'package:donezo/Pages/login_page.dart';
import 'package:flutter/material.dart';

// This is the home page of the Donezo app
// It displays the user's tasks and allows them to manage them
class HomePage extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task) onTaskDeleted;
  final Function(Task) onTaskChecked;
  final String userName;
  final String userEmail;

  const HomePage({
    super.key,
    required this.tasks,
    required this.onTaskDeleted,
    required this.onTaskChecked,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DonezoDB _db = DonezoDB();

  @override
  Widget build(BuildContext context) {
    final pendingTasks = widget.tasks.where((task) => !task.completed).toList();
    final completedTasks =
        widget.tasks.where((task) => task.completed).toList();

    pendingTasks.sort(_sortTasks);
    completedTasks.sort(_sortTasks);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
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
            top: 50,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Distribute space evenly
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'lib/Images/dino.png',
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Hello, ${widget.userName.split(' ')[0]}",
                        style: TextStyle(
                          fontSize: 36,
                          color: Theme.of(context).colorScheme.surfaceBright,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.logout, color: Colors.white, size: 30),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Center(
                          child: Text(
                            "Logout Confirmation",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                        content: const Text(
                          "Are you sure you want to logout of Donezo?",
                          style: TextStyle(fontSize: 18),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _db.logout();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Logout",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 120,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 700,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(40))),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    // This is the section for today's progress
                    // It shows the number of completed tasks and a message if there are no tasks
                    Center(child: ProgressTile(tasks: widget.tasks)),
                    const SizedBox(height: 25),
                    // This is the section for pending tasks
                    // It shows the number of pending tasks and a message if there are no tasks
                    _buildTaskSection(
                      title: "Pending Tasks",
                      tasks: pendingTasks,
                      isEmptyMessage: "You have no pending tasks!",
                    ),
                    const SizedBox(height: 15),
                    // This is the section for completed tasks
                    // It shows the number of completed tasks and a message if there are no tasks
                    _buildTaskSection(
                      title: "Completed Tasks",
                      tasks: completedTasks,
                      isEmptyMessage: "No completed tasks yet!",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// This function sorts the tasks based on their priority and due date
  /// It uses a map to define the priority order and compares the tasks accordingly
  int _sortTasks(Task a, Task b) {
    const priorityOrder = {'high': 1, 'medium': 2, 'low': 3};
    final priorityCompare = priorityOrder[a.priority.toLowerCase()]!
        .compareTo(priorityOrder[b.priority.toLowerCase()]!);
    return priorityCompare != 0
        ? priorityCompare
        : a.dueDate.compareTo(b.dueDate);
  }

  // This function builds a section for tasks with a title and a list of tasks
  /// It uses a column to display the title and the tasks in a list view
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
                height: tasks.length * 55.0,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
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
                        key: ValueKey(task.key),
                        task: task,
                        onDelete: () => widget.onTaskDeleted(task),
                        onCheck: (task) => widget.onTaskChecked(task),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
