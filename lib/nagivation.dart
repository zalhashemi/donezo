// In your navigation.dart file
import 'package:donezo/Components/main_button.dart';
import 'package:flutter/material.dart';
import 'package:donezo/Pages/home_page.dart';
import 'package:donezo/Pages/calendar_page.dart';
import 'package:donezo/theme.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'Components/textbox.dart';
import 'package:intl/intl.dart';

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
            iconSize: 30, // 25px icons
            selectedFontSize: 14, // 12px font
            unselectedFontSize: 14, // 12px font
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
    final TextEditingController taskTitle = TextEditingController();
    final TextEditingController taskDescription = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Remove default background
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width, // Full width
      ),
      builder: (context) => Container(
        width: double.infinity, // Take full width
        decoration: const BoxDecoration(
          color: Color.fromRGBO(70, 30, 85, 1), // Your primary color
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          // Allows content to scroll if needed
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Will expand with content
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
                          padding:
                              EdgeInsets.only(left: 50.0, top: 8, bottom: 2),
                          child: Text(
                            "Due Date",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 50.0, top: 0, bottom: 3),
                          child: Container(
                            height: 45,
                            width: 300,
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 25,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: FormBuilderDateTimePicker(
                                      name: 'date',
                                      inputType: InputType.date,
                                      format: DateFormat("MM/dd/yyyy"),
                                      decoration: InputDecoration(
                                        labelText: 'Month/Day/Year',
                                        labelStyle: TextStyle(
                                          fontSize: 18,
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
                          )),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding:
                              EdgeInsets.only(left: 50.0, top: 8, bottom: 3),
                          child: Text(
                            "Priority",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )),
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
                                color: Color.fromRGBO(230, 78, 109, 1),
                                onPressed: () {}),
                            SizedBox(width: 10),
                            MainButton(
                                text: 'Medium',
                                color: Color.fromRGBO(248, 198, 49, 1),
                                onPressed: () {}),
                            SizedBox(width: 10),
                            MainButton(
                                text: 'Low',
                                color: Color.fromRGBO(151, 71, 255, 1),
                                onPressed: () {}),
                          ],
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding:
                              EdgeInsets.only(left: 50.0, top: 8, bottom: 8),
                          child: Text(
                            "Category",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding:
                              EdgeInsets.only(left: 50.0, top: 8, bottom: 8),
                          child: Text(
                            "Reminder",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          )),
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
