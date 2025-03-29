import 'package:flutter/material.dart';
import 'package:donezo/Components/main_button.dart';
import 'package:donezo/Components/task_tile.dart';
import 'package:donezo/Pages/home_page.dart';
import 'package:donezo/Pages/calendar_page.dart';
import 'package:donezo/theme.dart';
import 'package:donezo/Models/task.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:donezo/Components/textbox.dart';
import 'package:intl/intl.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int selectedPageIndex = 0;
  List<Task> tasks = [];
  void onItemTapped(int index) {
    if (index == 1) {
      CreateTaskBottomSheet.show(context, addTask);
      return;
    }

    setState(() {
      selectedPageIndex = index == 2 ? 1 : index;
    });
  }

  List<Widget> get pages => [
        HomePage(
          tasks: tasks,
          onTaskDeleted: _handleTaskDeleted,
          onTaskChecked: _handleTaskChecked,
        ),
        const CalendarPage(),
      ];

  void _handleTaskDeleted(Task deletedTask) {
    setState(() => tasks.remove(deletedTask));
  }

  void _handleTaskChecked(Task task, bool? completed) {
    setState(() {
      task.completed = completed ?? false;
      _sortTasks();
    });
  }

  void _sortTasks() {
    tasks.sort((a, b) {
      if (a.completed != b.completed) return a.completed ? 1 : -1;
      return _comparePriorities(a, b);
    });
  }

  int _comparePriorities(Task a, Task b) {
    const priorityOrder = {'high': 1, 'medium': 2, 'low': 3};
    final priorityCompare = priorityOrder[a.priority.toLowerCase()]!
        .compareTo(priorityOrder[b.priority.toLowerCase()]!);
    return priorityCompare != 0
        ? priorityCompare
        : a.dueDate.compareTo(b.dueDate);
  }

  void addTask(Task newTask) {
    setState(() {
      tasks.add(newTask);
      _sortTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedPageIndex,
        children: pages, // Now dynamically rebuilt
      ),
      bottomNavigationBar: Container(
        height: 100,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          color: CustomColors.ourYellow,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            selectedItemColor: Theme.of(context).colorScheme.secondary,
            unselectedItemColor: Theme.of(context).colorScheme.primary,
            currentIndex: selectedPageIndex == 1 ? 2 : selectedPageIndex,
            iconSize: 30,
            selectedFontSize: 14,
            unselectedFontSize: 14,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded, size: 40),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle, size: 60),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined, size: 40),
                label: "",
              ),
            ],
            onTap: onItemTapped,
          ),
        ),
      ),
    );
  }
}

class CreateTaskBottomSheet {
  static void show(BuildContext context, Function(Task) addTask) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CreateTaskBottomSheetContent(addTask: addTask),
    );
  }
}

class _CreateTaskBottomSheetContent extends StatefulWidget {
  final Function(Task) addTask;

  const _CreateTaskBottomSheetContent({required this.addTask});

  @override
  _CreateTaskBottomSheetContentState createState() =>
      _CreateTaskBottomSheetContentState();
}

class _CreateTaskBottomSheetContentState
    extends State<_CreateTaskBottomSheetContent> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool reminderEnabled = false;
  String selectedPriority = 'medium';
  final TextEditingController taskTitle = TextEditingController();
  final TextEditingController taskDescription = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          height: 180,
          width: 290,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFE64E6D),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.error_outline,
                    size: 34,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }

  void selectPriority(String priority) {
    setState(() {
      selectedPriority = priority;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(70, 30, 85, 1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Create New Task',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Baloo',
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 330,
                        child: FormBuilderTextField(
                          name: 'title',
                          controller: taskTitle,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a task title';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Task Title',
                            labelStyle: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Baloo 2',
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextBox(
                        labelText: 'Description',
                        height: 100,
                        controller: taskDescription,
                        maxLines: 5,
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 50.0, top: 10, bottom: 2),
                        child: Text(
                          "Due Date",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 50.0, top: 0, bottom: 3),
                        child: Container(
                          height: 45,
                          width: 320,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 25,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: FormBuilderDateTimePicker(
                                    name: 'date',
                                    inputType: InputType.date,
                                    format: DateFormat("MMMMEEEEd"),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select a due date';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Day, Month Date',
                                      labelStyle: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Baloo 2',
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 50.0, top: 10, bottom: 3),
                        child: Text(
                          "Priority",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 50.0, top: 1, bottom: 8),
                        child: Row(
                          children: [
                            MainButton(
                              text: 'High',
                              color: const Color(0xFFE64E6D).withOpacity(
                                  selectedPriority == 'high' ? 1 : 0.7),
                              onPressed: () => selectPriority('high'),
                            ),
                            const SizedBox(width: 10),
                            MainButton(
                              text: 'Medium',
                              color: const Color(0xFFF8C631).withOpacity(
                                  selectedPriority == 'medium' ? 1 : 0.7),
                              onPressed: () => selectPriority('medium'),
                            ),
                            const SizedBox(width: 10),
                            MainButton(
                              text: 'Low',
                              color: const Color(0xFF9747FF).withOpacity(
                                  selectedPriority == 'low' ? 1 : 0.7),
                              onPressed: () => selectPriority('low'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 50.0, top: 12, bottom: 8),
                        child: Row(
                          children: [
                            const Text(
                              "Reminder",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            const Spacer(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 40.0, top: 8),
                              child: SizedBox(
                                width: 45,
                                height: 15,
                                child: Switch(
                                  value: reminderEnabled,
                                  onChanged: (bool value) {
                                    setState(() => reminderEnabled = value);
                                  },
                                  activeColor: Theme.of(context).lightPurple,
                                  activeTrackColor:
                                      Theme.of(context).lightPurple,
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor: Colors.grey[300],
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  thumbColor:
                                      WidgetStateProperty.all(Colors.white),
                                  trackOutlineColor:
                                      WidgetStateProperty.resolveWith<Color?>(
                                    (Set<WidgetState> states) =>
                                        Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 20),
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.saveAndValidate() ??
                                  false) {
                                final newTask = Task(
                                  id: DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                  title: taskTitle.text,
                                  dueDate: _formKey.currentState!.value['date'],
                                  priority: selectedPriority,
                                );
                                widget.addTask(newTask);
                                Navigator.pop(context);

                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      Navigator.of(context).pop();
                                    });
                                    return AlertDialog(
                                      content: SizedBox(
                                        height: 180,
                                        width: 290,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .lightPurple,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  '✓',
                                                  style: TextStyle(
                                                    fontSize: 34,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            const Text(
                                              'Task created successfully!',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                final errors = _formKey.currentState?.errors;
                                final errorMessages = [
                                  if (errors?['title'] != null)
                                    errors!['title']!,
                                  if (errors?['date'] != null) errors!['date']!,
                                ];
                                if (errorMessages.isNotEmpty) {
                                  _showErrorDialog(errorMessages.join('\n'));
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).lightPurple,
                              foregroundColor: Colors.white,
                              shape: const CircleBorder(),
                              padding: EdgeInsets.zero,
                              alignment: Alignment.center,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 34,
                              weight: 900,
                              color: Colors.white,
                            ),
                          ),
                        ),
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
