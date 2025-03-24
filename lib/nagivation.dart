import 'package:donezo/Components/dropdown.dart';
import 'package:donezo/Components/main_button.dart';
import 'package:flutter/material.dart';
import 'package:donezo/Pages/home_page.dart';
import 'package:donezo/Pages/calendar_page.dart';
import 'package:donezo/theme.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'Components/textbox.dart';
import 'package:intl/intl.dart';

//Navigation bar

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int selectedPageIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    CalendarPage(),
  ];

  void onItemTapped(int index) {
    if (index == 1) {
      CreateTaskBottomSheet.show(context);
      return;
    }

    setState(() {
      selectedPageIndex = index == 2 ? 1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedPageIndex,
        children: pages,
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
                icon: Icon(Icons.home_rounded),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle, size: 50),
                label: "Add Task",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined),
                label: "Calendar",
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
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
      ),
      builder: (context) => const _CreateTaskBottomSheetContent(),
    );
  }
}

class _CreateTaskBottomSheetContent extends StatefulWidget {
  const _CreateTaskBottomSheetContent();

  @override
  _CreateTaskBottomSheetContentState createState() =>
      _CreateTaskBottomSheetContentState();
}

class _CreateTaskBottomSheetContentState
    extends State<_CreateTaskBottomSheetContent> {
  bool reminderEnabled = false;
  bool isHighPriority = false;
  bool isMediumPriority = false;
  bool isLowPriority = false;

  void selectPriority(String priority) {
    setState(() {
      isHighPriority = priority == 'high';
      isMediumPriority = priority == 'medium';
      isLowPriority = priority == 'low';
    });
  } 

  final TextEditingController taskTitle = TextEditingController();
  final TextEditingController taskDescription = TextEditingController();

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
                  child: TextBox(
                    labelText: 'Task Title',
                    controller: taskTitle,
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
                    padding: EdgeInsets.only(left: 50.0, top: 10, bottom: 2),
                    child: Text(
                      "Due Date",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 50.0, top: 0, bottom: 3),
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
                                decoration: InputDecoration(
                                  labelText: 'Day, Month Date',
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 50.0, top: 10, bottom: 3),
                    child: Text(
                      "Priority",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 50.0, top: 1, bottom: 8),
                    child: Row(
                      children: [
                        MainButton(
                          text: 'High',
                          color: const Color.fromRGBO(230, 78, 109, 1)
                              .withOpacity(isHighPriority ? 1 : 0.7),
                          onPressed: () => selectPriority('high'),
                        ),
                        const SizedBox(width: 10),
                        MainButton(
                          text: 'Medium',
                          color: const Color.fromRGBO(248, 198, 49, 1)
                              .withOpacity(isMediumPriority ? 1 : 0.7),
                          onPressed: () => selectPriority('medium'),
                        ),
                        const SizedBox(width: 10),
                        MainButton(
                          text: 'Low',
                          color: const Color.fromRGBO(151, 71, 255, 1)
                              .withOpacity(isLowPriority ? 1 : 0.7),
                          onPressed: () => selectPriority('low'),
                        ),
                      ],
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 50.0, top: 10, bottom: 8),
                    child: Text(
                      "Category",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 50.0, top: 0, bottom: 10),
                    child: Dropdown(
                      hintText: 'Select category',
                      categories: [
                        'Work',
                        'Academic',
                        'Fitness',
                        'Groceries',
                        'Chores'
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 50.0, top: 12, bottom: 8),
                    child: Row(
                      children: [
                        const Text(
                          "Reminder",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 40.0,
                            top: 8,
                          ),
                          child: SizedBox(
                            width: 45,
                            height: 15,
                            child: Switch(
                              value: reminderEnabled,
                              onChanged: (bool value) {
                                setState(() {
                                  reminderEnabled = value;
                                });
                              },
                              activeColor: Theme.of(context).lightPurple,
                              activeTrackColor: Theme.of(context).lightPurple,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.grey[300],
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              thumbColor: WidgetStateProperty.all(Colors.white),
                              trackOutlineColor:
                                  WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) => Colors.transparent,
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
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            useRootNavigator: true,
                            builder: (context) {
                              Future.delayed(const Duration(seconds: 2), () {
                                Navigator.of(context).pop();
                              });
                              return AlertDialog(
                                content: SizedBox(
                                  height: 180,
                                  width: 290,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).lightPurple,
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
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                contentPadding: const EdgeInsets.all(20),
                                insetPadding: EdgeInsets.zero,
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).lightPurple,
                          foregroundColor: Colors.white,
                          shape: const CircleBorder(),
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                        ),
                        child: const Text(
                          '✓',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
