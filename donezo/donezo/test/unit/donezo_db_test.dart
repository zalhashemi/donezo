import 'package:donezo/Data/database.dart';
import 'package:donezo/Models/task.dart';
import 'package:donezo/Models/user.dart';
import 'package:flutter_test/flutter_test.dart';
// تأكد من المسار الصحيح
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

void main() {
  late DonezoDB db;
  late User testUser;
  late Task testTask;

  setUp(() async {
    await setUpTestHive();
    Hive.registerAdapter(UserAdapter()); // تأكد من وجود الـ Adapter
    Hive.registerAdapter(TaskAdapter());
    db = DonezoDB();
    await db.init();

    testUser =
        User(id: '1', name: 'Test', email: 'test@test.com', password: '1234');
    testTask = Task(
      title: 'Buy groceries',
      description: 'Milk, Bread, Eggs',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: 'high',
      completed: false,
      id: '1',
    );
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  test('Create user and retrieve it', () async {
    final success = await db.createUser(testUser);
    expect(success, isTrue);

    final users = db.getUsers();
    expect(users.length, 1);
    expect(users.first.email, equals('test@test.com'));
  });

  test('Fail to create user with existing email', () async {
    await db.createUser(testUser);
    final secondTry = await db.createUser(testUser);
    expect(secondTry, isFalse);
  });

  test('Set and get current user', () async {
    await db.createUser(testUser);
    await db.setCurrentUser(testUser);

    final currentUser = db.getCurrentUser();
    expect(currentUser?.id, equals('1'));
  });

  test('Add and get task for current user', () async {
    await db.createUser(testUser);
    await db.setCurrentUser(testUser);
    await db.addTask(testTask);

    final tasks = await db.getCurrentUserTasks();
    expect(tasks.length, 1);
    expect(tasks.first.title, equals('Test Task'));
  });

  test('Logout clears current user', () async {
    await db.createUser(testUser);
    await db.setCurrentUser(testUser);
    db.logout();
    final user = db.getCurrentUser();
    expect(user?.id, equals('')); // Default user with empty id
  });
}
