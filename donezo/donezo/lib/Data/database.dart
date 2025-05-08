import 'package:hive_flutter/hive_flutter.dart';
import 'package:donezo/Models/task.dart';
import 'package:donezo/Models/user.dart';

// This is a singleton class that manages the database for the Donezo app
// It uses Hive as the database and provides methods to interact with it
// It allows the user to create, read, update, and delete tasks and users
class DonezoDB {
  // This is a singleton instance of the DonezoDB class
  // It ensures that only one instance of the class is created and used throughout the app
  static final DonezoDB _instance = DonezoDB._internal();
  factory DonezoDB() => _instance;
  DonezoDB._internal();

// This is a private variable that holds the main box of the database
  // It is used to store the current user and the list of users
  late Box _mainBox;
  User? _currentUser;
  final String _taskBoxPrefix = 'user_tasks_';

// This is a private variable that holds the current user
  // It is used to identify the user and their tasks in the database
  // It is set when the user logs in or creates a new account
  Future<void> init() async {
    await Hive.openBox('donezo_main_box');
    _mainBox = Hive.box('donezo_main_box');
  }

  // This method is used to get the task box for the current user
  // It uses the user ID to create a unique box name for each user
  Future<Box<Task>> getTaskBox() async {
    if (_currentUser == null) throw Exception("No logged in user");
    final boxName = '$_taskBoxPrefix${_currentUser!.id}';
    return await Hive.openBox<Task>(boxName);
  }

  // This method is used to get the current user from the database
  // It retrieves the user ID from the main box and uses it to find the user in the list of users
  User? getCurrentUser() {
    final userId = _mainBox.get('currentUserId');
    if (userId == null) return null;
    return _mainBox
        .get('users', defaultValue: <User>[])
        .cast<User>()
        .firstWhere(
          (u) => u.id == userId,
          orElse: () => User(
            id: '',
            name: '',
            email: '',
            password: '',
          ),
        );
  }

  // This method is used to set the current user in the database
  // It takes a user object as a parameter and saves it in the main box
  Future<void> setCurrentUser(User user) async {
    _currentUser = user;
    await _mainBox.put('currentUserId', user.id);
    await getTaskBox();
  }

  // This method is used to get the tasks for the current user
  // It retrieves the task box for the user and returns a list of tasks
  Future<List<Task>> getCurrentUserTasks() async {
    final box = await getTaskBox();
    return box.values.cast<Task>().toList();
  }

  // This method is used to add a new task for the current user
  // It takes a task object as a parameter and saves it in the task box
  Future<void> addTask(Task task) async {
    final box = await getTaskBox();
    await box.put(task.id, task); // Use put instead of add
  }

  // This method is used to update an existing task for the current user
  // It takes a task object as a parameter and saves it in the task box
  // It uses the save method of the task object to update it in the database
  Future<void> updateTask(Task task) async {
    final box = await getTaskBox();
    await task.save();
  }

  // This method is used to delete a task for the current user
  // It takes a task object as a parameter and deletes it from the task box
  // It uses the delete method of the task object to remove it from the database
  Future<void> deleteTask(Task task) async {
    final box = await getTaskBox();
    await task.delete();
  }

  // This method is used to get the list of users from the database
  // It retrieves the list of users from the main box and returns it as a list of user objects
  // It uses the cast method to convert the dynamic list to a list of user objects
  List<User> getUsers() =>
      _mainBox.get('users', defaultValue: <User>[]).cast<User>();

  // This method is used to save the list of users in the database
  // It takes a list of user objects as a parameter and saves it in the main box
  Future<void> saveUsers(List<User> users) async =>
      await _mainBox.put('users', users);

  // This method is used to log in a user
  // It takes an email and a password as parameters and checks if they match any user in the database
  Future<bool> createUser(User newUser) async {
    final users = getUsers();
    if (users.any((u) => u.email == newUser.email)) return false;
    users.add(newUser);
    await saveUsers(users);
    return true;
  }

  // This method is used to log out a user
  void logout() {
    _currentUser = null;
    _mainBox.delete('currentUserId');
  }
}
