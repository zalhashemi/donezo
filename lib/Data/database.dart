import 'package:hive_flutter/hive_flutter.dart';
import 'package:donezo/Models/task.dart';
import 'package:donezo/Models/user.dart';

class DonezoDB {
  static final DonezoDB _instance = DonezoDB._internal();
  factory DonezoDB() => _instance;
  DonezoDB._internal();

  late Box _mainBox;
  User? _currentUser;
  final String _taskBoxPrefix = 'user_tasks_';

  Future<void> init() async {
    await Hive.openBox('donezo_main_box');
    _mainBox = Hive.box('donezo_main_box');
  }

  Future<Box<Task>> getTaskBox() async {
    if (_currentUser == null) {
      throw Exception("No logged in user"); // Keep this as safety
    }
    final boxName = '$_taskBoxPrefix${_currentUser!.id}';
    return await Hive.openBox<Task>(boxName);
  }

  User? getCurrentUser() {
    final userId = _mainBox.get('currentUserId');
    if (userId == null) return null;
    return _mainBox
        .get('users', defaultValue: <User>[])
        .cast<User>()
        .firstWhere(
          (u) => u.id == userId,
          orElse: () =>
              User(id: '', name: '', email: '', password: '', userType: ''),
        );
  }

  Future<void> setCurrentUser(User user) async {
    _currentUser = user;
    await _mainBox.put('currentUserId', user.id);
    await getTaskBox();
  }

  Future<List<Task>> getCurrentUserTasks() async {
    final box = await getTaskBox();
    return box.values.toList();
  }

  Future<void> addTask(Task task) async {
    final box = await getTaskBox();
    await box.add(task);
  }

  Future<void> updateTask(Task task) async {
    final box = await getTaskBox();

    // Ensure the task has a valid integer key
    if (task.key is int) {
      await box.put(task.key, task);
    } else {
      throw Exception("Task has invalid key for update: ${task.key}");
    }
  }

  Future<void> deleteTask(Task task) async {
    final box = await getTaskBox();
    await task.delete();
  }

  List<User> getUsers() =>
      _mainBox.get('users', defaultValue: <User>[]).cast<User>();

  Future<void> saveUsers(List<User> users) async =>
      await _mainBox.put('users', users);

  Future<bool> createUser(User newUser) async {
    final users = getUsers();
    if (users.any((u) => u.email == newUser.email)) return false;
    users.add(newUser);
    await saveUsers(users);
    return true;
  }

  void logout() {
    _currentUser = null;
    _mainBox.delete('currentUserId');
  }
}
