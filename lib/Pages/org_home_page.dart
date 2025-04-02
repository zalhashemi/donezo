import 'package:donezo/Components/main_button.dart';
import 'package:donezo/Components/progress_tile.dart';
import 'package:donezo/Components/team_task_tile.dart';
import 'package:donezo/Data/database.dart';
import 'package:flutter/material.dart';
import 'package:donezo/Components/task_tile.dart';
import 'package:donezo/Models/task.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:donezo/Pages/login_page.dart'; 

class OrgHomePage extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task) onTaskDeleted;
  final Function(Task) onTaskChecked; 
  final String userName;
  final String userEmail;

  const OrgHomePage({
    super.key,
    required this.tasks,
    required this.onTaskDeleted,
    required this.onTaskChecked, 
    required this.userName,
    required this.userEmail,
  });

  @override
  State<OrgHomePage> createState() => _OrgHomePageState();
}

class _OrgHomePageState extends State<OrgHomePage> {
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
            left: 20,
            child: PopupMenuButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              itemBuilder: (context) => <PopupMenuEntry>[
                PopupMenuItem(
                  enabled: false,
                  child: Column(
                    children: [
                      const Icon(Icons.person, size: 60, color: Colors.black),
                      const SizedBox(height: 8),
                      Text(widget.userName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(widget.userEmail,
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  onTap: () {}, 
                  child: const ListTile(
                    leading: Icon(Icons.group_outlined),
                    title: Text('Switch to Organization Mode'),
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    _db.logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  child: const ListTile(
                    leading: Icon(Icons.logout_outlined),
                    title: Text('Log out'),
                  ),
                ),
              ],
              child: Row(
                children: const [
                  Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 40,
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
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
              child: SingleChildScrollView(
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
                              "Hello, ${widget.userName.split(' ')[0]}",
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
                    Center(child: ProgressTile(tasks: widget.tasks)),
                    const SizedBox(height: 25),

                    TeamTaskTile(
                        teamName: 'Design',
                        taskName: 'The Logo Process',
                        priorityColor: Colors.red,
                        taskStartDate: '14 Feb 2025',
                        taskEndDate: '25 Apr 2025',
                        taskPriority: 'High'),
                    SizedBox(height: 20),
                    TeamTaskTile(
                        teamName: 'Marketing',
                        taskName: 'Formulating the Strategy',
                        priorityColor: Colors.purple,
                        taskStartDate: '1 Mar 2025',
                        taskEndDate: '10 Apr 2025',
                        taskPriority: 'Low'),
                    // Center(child: ProgressTile(tasks: widget.tasks)),
                    // const SizedBox(height: 35),
                    // _buildTaskSection(
                    //   title: "Pending Tasks",
                    //   tasks: pendingTasks,
                    //   isEmptyMessage: "You have no pending tasks!",
                    // ),
                    // _buildTaskSection(
                    //   title: "Completed Tasks",
                    //   tasks: completedTasks,
                    //   isEmptyMessage: "No completed tasks yet!",
                    // ),
                  ],
                ),
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
                        onCheck: (task) =>
                            widget.onTaskChecked(task), 
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
