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

class _CalendarPageState extends State<CalendarPage>
    with SingleTickerProviderStateMixin {
  final DonezoDB _db = DonezoDB();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedFilter = 'All Tasks';
  final List<String> _filters = ['All Tasks', 'Pending', 'Done'];

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
            top: 60,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello 👋",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 4),
              ],
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white, size: 30),
              onPressed: () => _showLogoutDialog(context),
            ),
          ),
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildWeekNavigator(context),
                  _buildCalendar(),
                  _buildFilterChips(),
                  const Divider(height: 0.5),
                  Expanded(child: _buildTaskList(filteredTasks)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekNavigator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 30),
            onPressed: () => setState(() {
              _focusedDay = _focusedDay.subtract(const Duration(days: 7));
            }),
          ),
          Text(
            _getWeekRangeText(),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).lilac,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 30),
            onPressed: () => setState(() {
              _focusedDay = _focusedDay.add(const Duration(days: 7));
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onFormatChanged: (format) {
        setState(() => _calendarFormat = format);
      },
      onPageChanged: (focusedDay) => _focusedDay = focusedDay,
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, _) {
          final isSelected = isSameDay(_selectedDay, day);
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color:
                  isSelected ? Theme.of(context).lilac.withOpacity(0.2) : null,
              border: isSelected
                  ? Border.all(color: Theme.of(context).lilac, width: 2)
                  : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${day.day}',
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).lilac
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          );
        },
        headerTitleBuilder: (context, _) => const SizedBox(),
        dowBuilder: (context, day) => Center(
          child: Text(
            _getDayAbbreviation(day.weekday),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        headerPadding: EdgeInsets.zero,
        leftChevronVisible: false,
        rightChevronVisible: false,
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: SizedBox(
        height: 36,
        width: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_filters.length, (index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => _selectedFilter = filter);
                    },
                    selectedColor: Theme.of(context).lilac,
                    backgroundColor: Theme.of(context).ourGrey,
                    labelStyle: TextStyle(
                      color:
                          isSelected ? Colors.white : Theme.of(context).lilac,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          'No tasks for selected date',
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: ListView.builder(
        key: ValueKey(_selectedDay.toString() + _selectedFilter),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TaskTile(
              key: ValueKey(task.key),
              task: task,
              onDelete: () => widget.onTaskDeleted(task),
              onCheck: (task) => widget.onTaskChecked(task),
            ),
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Center(child: Text("Logout Confirmation")),
        content: const Text("Are you sure you want to logout of Donezo?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                _db.logout();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginPage()));
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  String _getDayAbbreviation(int day) {
    return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day - 1];
  }

  String _getWeekRangeText() {
    final start = _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1));
    final end = start.add(const Duration(days: 6));
    return '${start.day}/${start.month} - ${end.day}/${end.month}';
  }
}
