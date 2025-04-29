import 'package:donezo/Components/main_button.dart';
import 'package:donezo/Data/database.dart';
import 'package:donezo/Models/task.dart';
import 'package:donezo/Pages/calendar_page.dart';
import 'package:donezo/Pages/home_page.dart';
import 'package:donezo/Pages/starter_page.dart';
import 'package:donezo/noti_service.dart';
import 'package:donezo/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

// This is the main navigation page of the Donezo app
// It contains the bottom navigation bar and the pages for home and calendar
// It also handles the database initialization and task management

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
  // This method is called when the widget is first created
  // It initializes the database and the task box
  void initState() {
    super.initState();
    _db = DonezoDB();
    _initializeDatabase();
  }

  /// This method initializes the database and the task box
// It checks if the user is logged in and navigates to the appropriate page
  Future<void> _initializeDatabase() async {
    try {
      await _db.init();
      final user = _db.getCurrentUser();

      // Enhanced user validation
      if (user == null || user.id.isEmpty || user.email.isEmpty) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StarterPage()),
          );
        }
        return;
      }

      // Move notification initialization to AFTER UI loads
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final permissionStatus = await Permission.notification.request();
        if (permissionStatus.isGranted) {
          await NotiService().initialize();
        }
      });

      _taskBox = await _db.getTaskBox();
      _taskBox?.watch().listen((_) => setState(() {}));
    } catch (e) {
      print('Initialization error: $e');
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

  /// This method is called when an item in the bottom navigation bar is tapped
// It updates the selected page index and shows the create task bottom sheet if needed
  void onItemTapped(int index) {
    if (index == 1) {
      CreateTaskBottomSheet.show(context, addTask);
      return;
    }
    setState(() => selectedPageIndex = index == 2 ? 1 : index);
  }

  /// This method returns the list of pages to be displayed in the IndexedStack
// It checks if the task box is loaded and returns the appropriate pages based on the user type
  List<Widget> get pages {
    if (_isLoading || _taskBox == null) {
      return [const Center(child: CircularProgressIndicator())];
    }
    final currentUser = _db.getCurrentUser();
    return [
      //This checks if the current user is an organization and returns the appropriate home page
      HomePage(
        // This is the home page for regular users
        tasks: _taskBox!.values.toList(),
        onTaskDeleted: _handleTaskDeleted,
        onTaskChecked: _handleTaskChecked,
        userEmail: currentUser?.email ?? 'user@email.com',
        userName: currentUser?.name ?? 'User',
      ),
      CalendarPage(
        // This is the calendar page
        onTaskDeleted: _handleTaskDeleted,
        tasks: _taskBox!.values.toList(),
        onTaskChecked: _handleTaskChecked,
        userEmail: currentUser?.email ?? 'user@email.com',
        userName: currentUser?.name ?? 'User',
      ),
    ];
  }

  /// This method handles the task deletion event
  void _handleTaskDeleted(Task task) => _db.deleteTask(task);

  /// This method handles the task checked event
  void _handleTaskChecked(Task task) {
    _db.updateTask(task);
  }

  /// This method adds a new task to the database
  void addTask(Task newTask) {
    _db.addTask(newTask);
    NotiService().scheduleTaskReminders(
      taskId: newTask.id, // Make sure Task has ID
      title: newTask.title,
      description: newTask.description ?? '',
      dueDate: newTask.dueDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: IndexedStack(
                key: ValueKey<int>(selectedPageIndex),
                index: selectedPageIndex,
                children: pages,
              ),
            ),
      bottomNavigationBar: Container(
        height: 90,
        decoration: const BoxDecoration(
          color: CustomColors.ourYellow,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          child: BottomNavigationBar(
            currentIndex: selectedPageIndex,
            onTap: onItemTapped,
            backgroundColor: Colors.transparent,
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items: [
              _buildNavItem(
                context,
                icon: Icons.home_rounded,
                label: "Home",
                index: 0,
              ),
              BottomNavigationBarItem(
                icon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedScale(
                      duration: const Duration(milliseconds: 300),
                      scale: selectedPageIndex == 1 ? 1.05 : 1.0,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF906DB0), Color(0xFF461E55)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.add,
                            size: 24, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "New",
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Baloo 2',
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                label: '',
              ),
              _buildNavItem(
                context,
                icon: Icons.calendar_month_outlined,
                label: "Calendar",
                index: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(BuildContext context,
      {required IconData icon, required String label, required int index}) {
    final bool isSelected = selectedPageIndex == index;

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 50,
        padding: const EdgeInsets.only(bottom: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isSelected ? 30 : 28,
              color: isSelected
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                height: 1.0,
                fontWeight: FontWeight.w600,
                fontFamily: 'Baloo 2',
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.primary,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
      label: '',
    );
  }
}

class CreateTaskBottomSheet {
  static void show(BuildContext context, Function(Task) addTask) {
    showModalBottomSheet(
      // This method shows the create task bottom sheet
      // It takes the context and the addTask function as parameters
      // It uses the showModalBottomSheet method to display the bottom sheet
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
  // This is the state class for the create task bottom sheet
  // It contains the form key, text controllers, and other variables needed for the form
  final Uuid uuid = Uuid();
  final _formKey = GlobalKey<FormBuilderState>();
  bool reminderEnabled = false;
  String selectedPriority = 'medium';
  final TextEditingController taskTitle = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

// This method is called when the user selects a priority
// It updates the selected priority variable and calls setState to rebuild the widget
  void selectPriority(String priority) {
    setState(() => selectedPriority = priority);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // This is the main container for the create task bottom sheet
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Color.fromRGBO(70, 30, 85, 1),
          borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: FormBuilder(
          // This is the form builder widget that contains the form fields
          // It takes the form key and a child widget as parameters
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(25.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          size: 25, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 38),
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
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 330,
                      child: FormBuilderTextField(
                        name: 'description',
                        controller: descriptionController,
                        maxLines: 3,
                        maxLength: 150,
                        decoration: InputDecoration(
                          hintText: 'Task Description',
                          hintStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Baloo2',
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          counterStyle: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
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
                      padding: EdgeInsets.only(left: 40.0, top: 10, bottom: 3),
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
                          horizontal: 40, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          MainButton(
                            text: 'High',
                            color: const Color(0xFFE64E6D).withOpacity(
                                selectedPriority == 'high' ? 1 : 0.7),
                            onPressed: () => selectPriority('high'),
                          ),
                          const SizedBox(width: 5),
                          MainButton(
                            text: 'Medium',
                            color: const Color(0xFFF8C631).withOpacity(
                                selectedPriority == 'medium' ? 1 : 0.7),
                            onPressed: () => selectPriority('medium'),
                          ),
                          const SizedBox(width: 5),
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
                  Text(
                      'You will receive a reminder 24 hours before the due date',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Baloo 2',
                        color: Theme.of(context).ourWhite,
                      )),
                  SizedBox(
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
                                id: uuid.v4(), // Generate unique ID
                                title: taskTitle.text,
                                description: descriptionController.text,
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
                  SizedBox(
                    height: 10,
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
