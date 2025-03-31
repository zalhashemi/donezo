import 'package:hive_flutter/hive_flutter.dart';
import 'package:donezo/Models/task.dart';
import 'package:donezo/Models/user.dart';

class DonezoDB {
  static final DonezoDB _instance = DonezoDB._internal();
  factory DonezoDB() => _instance;
  DonezoDB._internal();

  late Box _box;
  User? _currentUser;

  Future<void> init() async {
    await Hive.openBox('donezo_box');
    _box = Hive.box('donezo_box');
  }

  User? getCurrentUser() {
    final userId = _box.get('currentUserId');
    if (userId == null) return null;

    final users = getUsers();
    return users.firstWhere(
      (u) => u.id == userId,
      orElse: () =>
          User(id: '', name: '', email: '', password: '', userType: ''),
    );
  }

  void setCurrentUser(User user) {
    _currentUser = user;
    _box.put('currentUserId', user.id);
  }

  void logout() {
    _currentUser = null;
    _box.delete('currentUserId');
  }

  // User management
  List<User> getUsers() =>
      _box.get('users', defaultValue: <User>[]).cast<User>();

  Future<void> saveUsers(List<User> users) async =>
      await _box.put('users', users);

  Future<bool> createUser(User newUser) async {
    final users = getUsers();
    if (users.any((u) => u.email == newUser.email)) return false;
    users.add(newUser);
    await saveUsers(users);
    return true;
  }

  User? getUser(String email) => getUsers().firstWhere(
        (u) => u.email == email,
        orElse: () =>
            User(id: '', name: '', email: '', password: '', userType: ''),
      );

  // Task management
  List<Task> getCurrentUserTasks() => _box.get(
        'tasks_${_currentUser?.id}',
        defaultValue: <Task>[],
      ).cast<Task>();

  Future<void> saveCurrentUserTasks(List<Task> tasks) async =>
      await _box.put('tasks_${_currentUser?.id}', tasks);

  Future<void> addTask(Task task) async {
    final tasks = getCurrentUserTasks();
    tasks.add(task);
    await saveCurrentUserTasks(tasks);
  }

  Future<void> updateTask(Task task) async {
    final tasks = getCurrentUserTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await saveCurrentUserTasks(tasks);
    }
  }

  Future<void> deleteTask(String taskId) async {
    final tasks = getCurrentUserTasks();
    tasks.removeWhere((t) => t.id == taskId);
    await saveCurrentUserTasks(tasks);
  }

  List<Task> getTasks() {
    return _box.get('tasks', defaultValue: <Task>[]).cast<Task>();
  }
}
