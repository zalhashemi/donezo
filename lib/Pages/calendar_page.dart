import 'package:donezo/Components/task_tile.dart';
import 'package:donezo/Data/database.dart';
import 'package:donezo/Models/task.dart';
import 'package:donezo/Pages/login_page.dart';
import 'package:donezo/theme.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task) onTaskDeleted;
  final Function(Task) onTaskChecked;
  final String userName;
  final String userEmail;

  const CalendarPage({
    super.key,
    required this.tasks,
    required this.onTaskDeleted,
    required this.onTaskChecked,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final DonezoDB _db = DonezoDB();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedFilter = 'All Tasks';
  final Color _selectedColor = const Color(0xFF724D90);

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final tasksForSelectedDate = widget.tasks.where((task) {
      return _selectedDay != null &&
          task.dueDate.year == _selectedDay!.year &&
          task.dueDate.month == _selectedDay!.month &&
          task.dueDate.day == _selectedDay!.day;
    }).toList();

    final filteredTasks = _selectedFilter == 'Pending'
        ? tasksForSelectedDate.where((task) => !task.completed).toList()
        : _selectedFilter == 'Done'
            ? tasksForSelectedDate.where((task) => task.completed).toList()
            : tasksForSelectedDate;

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
                  Icon(Icons.person, color: Colors.white, size: 40),
                  Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: 100,
            child: Container(
              height: 700,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 10, left: 40, right: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.chevron_left,
                                color: Theme.of(context).lilac, size: 30),
                            onPressed: () => setState(() {
                              _focusedDay =
                                  _focusedDay.subtract(const Duration(days: 7));
                            }),
                          ),
                          Text(
                            _getWeekRangeText(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).lilac,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.chevron_right,
                                color: Theme.of(context).lilac, size: 30),
                            onPressed: () => setState(() {
                              _focusedDay =
                                  _focusedDay.add(const Duration(days: 7));
                            }),
                          ),
                        ],
                      ),
                    ),
                    TableCalendar(
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          final isSelected = isSameDay(_selectedDay, day);
                          return Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: isSelected
                                  ? Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      width: 2)
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                day.day.toString(),
                                style: TextStyle(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context).colorScheme.primary,
                                  fontFamily: 'Inter',
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          );
                        },
                        headerTitleBuilder: (context, day) => const SizedBox(),
                        dowBuilder: (context, day) {
                          return Center(
                            child: Text(
                              _getDayAbbreviation(day.weekday),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontFamily: 'Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        headerPadding: EdgeInsets.zero,
                        leftChevronVisible: false,
                        rightChevronVisible: false,
                      ),
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        dowTextFormatter: null,
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: .1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: ['All Tasks', 'Pending', 'Done']
                            .map((filter) => Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedFilter = filter;
                                        });
                                      },
                                      child: SizedBox(
                                        width: 105,
                                        height: 30,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: _selectedFilter == filter
                                                ? _selectedColor
                                                : Theme.of(context).ourGrey,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: _selectedFilter == filter
                                                  ? _selectedColor
                                                  : Colors.transparent,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              filter,
                                              style: TextStyle(
                                                color: _selectedFilter == filter
                                                    ? Colors.white
                                                    : _selectedColor,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    filteredTasks.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text(
                                'No tasks for selected date',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Column(
                              children: filteredTasks
                                  .map((task) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: TaskTile(
                                          key: ValueKey(task.key),
                                          task: task,
                                          onDelete: () =>
                                              widget.onTaskDeleted(task),
                                          onCheck: (task) =>
                                              widget.onTaskChecked(task),
                                        ),
                                      ))
                                  .toList(),
                            ),
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

  String _getDayAbbreviation(int day) {
    return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day - 1];
  }

  String _getWeekRangeText() {
    final startOfWeek =
        _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return '${_formatDate(startOfWeek)} - ${_formatDate(endOfWeek)}';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} ${_getMonthAbbreviation(date.month)}';
  }

  String _getMonthAbbreviation(int month) {
    return [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ][month - 1];
  }

  int _sortTasks(Task a, Task b) {
    const priorityOrder = {'high': 1, 'medium': 2, 'low': 3};
    final priorityCompare = priorityOrder[a.priority.toLowerCase()]!
        .compareTo(priorityOrder[b.priority.toLowerCase()]!);
    return priorityCompare != 0
        ? priorityCompare
        : a.dueDate.compareTo(b.dueDate);
  }
}
