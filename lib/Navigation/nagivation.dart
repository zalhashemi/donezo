import 'package:donezo/Components/main_button.dart';
import 'package:donezo/Data/database.dart';
import 'package:donezo/Models/task.dart';
import 'package:donezo/Pages/calendar_page.dart';
import 'package:donezo/Pages/home_page.dart';
import 'package:donezo/Pages/org_home_page.dart';
import 'package:donezo/Pages/starter_page.dart';
import 'package:donezo/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int selectedPageIndex = 0;
  late final DonezoDB _db;
  Box<Task>? _taskBox;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _db = DonezoDB();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    try {
      await _db.init();
      final user = _db.getCurrentUser();

      if (user == null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StarterPage()),
          );
        }
        return;
      }

      _taskBox = await _db.getTaskBox();
      _taskBox?.watch().listen((_) => setState(() {}));
    } catch (e) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StarterPage()),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void onItemTapped(int index) {
    if (index == 1) {
      CreateTaskBottomSheet.show(context, addTask);
      return;
    }
    setState(() => selectedPageIndex = index == 2 ? 1 : index);
  }

  List<Widget> get pages {
    if (_isLoading || _taskBox == null) {
      return [const Center(child: CircularProgressIndicator())];
    }
    final currentUser = _db.getCurrentUser();
    return [
      currentUser != null && currentUser.userType == 'Organization'
          ? OrgHomePage(
              tasks: _taskBox!.values.toList(),
              onTaskDeleted: _handleTaskDeleted,
              onTaskChecked: _handleTaskChecked,
              userEmail: currentUser.email,
              userName: currentUser.name,
            )
          : HomePage(
              tasks: _taskBox!.values.toList(),
              onTaskDeleted: _handleTaskDeleted,
              onTaskChecked: _handleTaskChecked,
              userEmail: currentUser?.email ?? 'user@email.com',
              userName: currentUser?.name ?? 'User',
            ),
      CalendarPage(
        onTaskDeleted: _handleTaskDeleted,
        tasks: _taskBox!.values.toList(),
        onTaskChecked: _handleTaskChecked,
        userEmail: currentUser?.email ?? 'user@email.com',
        userName: currentUser?.name ?? 'User',
      ),
    ];
  }

  void _handleTaskDeleted(Task task) => _db.deleteTask(task);

  void _handleTaskChecked(Task task) {
    _db.updateTask(task);
  }

  void addTask(Task newTask) => _db.addTask(newTask);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: selectedPageIndex,
              children: pages,
            ),
      bottomNavigationBar: Container(
        height: 90,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          color: CustomColors.ourYellow,
        ),
        child: SalomonBottomBar(
          currentIndex: selectedPageIndex == 1 ? 2 : selectedPageIndex,
          onTap: onItemTapped,
          backgroundColor: Colors.transparent,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          unselectedItemColor: Theme.of(context).colorScheme.primary,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          curve: Curves.easeInOut,
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: const Icon(Icons.home_rounded, size: 30),
              title: const Text("Home"),
              selectedColor: Colors.deepPurple,
            ),

            /// Add Task (center, custom FAB-style)
            SalomonBottomBarItem(
              icon: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.add, size: 25, color: Colors.deepPurple),
              ),
              title: const Text("New"),
              selectedColor: Colors.purpleAccent,
            ),

            /// Calendar
            SalomonBottomBarItem(
              icon: const Icon(Icons.calendar_month_outlined, size: 30),
              title: const Text("Calendar"),
              selectedColor: Colors.indigo,
            ),
          ],
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

  void selectPriority(String priority) {
    setState(() => selectedPriority = priority);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Color.fromRGBO(70, 30, 85, 1),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          size: 25, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 40),
                    const Text(
                      'Create New Task',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Baloo',
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 330,
                      child: FormBuilderTextField(
                        name: 'title',
                        controller: taskTitle,
                        validator: (value) {
                          if (value?.isEmpty ?? true)
                            return 'Please enter a task title';
                          return null;
                        },
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Baloo2',
                            color: Colors.grey,
                          ),
                          hintText: 'Task Title',
                          errorStyle: TextStyle(
                            color: Colors.redAccent, // لون نص الخطأ
                            fontSize: 13, // حجم النص
                            fontWeight: FontWeight.w500, // الوزن
                            fontFamily: 'Baloo2', // خط مخصص (اختياري)
                          ),
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
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 50.0, top: 10, bottom: 2),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
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
                              child: SizedBox(
                                width: 330,
                                child: FormBuilderDateTimePicker(
                                  firstDate: DateTime.now(),
                                  name: 'date',
                                  inputType: InputType.date,
                                  format: DateFormat("MMMMEEEEd"),
                                  validator: (value) {
                                    if (value == null)
                                      return 'Please select a due date';
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Select Due Date",
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Baloo2',
                                      color: Colors.grey,
                                    ),
                                    errorStyle: TextStyle(
                                      color: Colors.redAccent, // لون نص الخطأ
                                      fontSize: 13, // حجم النص
                                      fontWeight: FontWeight.w500, // الوزن
                                      fontFamily: 'Baloo2', // خط مخصص (اختياري)
                                    ),
                                    labelStyle: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Baloo 2',
                                      fontWeight: FontWeight.w400,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 10, bottom: 3),
                      child: Text(
                        "Priority",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 20),
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState?.saveAndValidate() ??
                                false) {
                              final newTask = Task(
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
                                      () => Navigator.of(context).pop());
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
                                              color:
                                                  Theme.of(context).lightPurple,
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
                                if (errors?['title'] != null) errors!['title']!,
                                if (errors?['date'] != null) errors!['date']!,
                              ];
                              if (errorMessages.isNotEmpty) {}
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
            ],
          ),
        ),
      ),
    );
  }
}
