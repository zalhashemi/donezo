import 'package:donezo/Models/task.dart';
import 'package:donezo/Pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomePage Widget Tests', () {
    late List<Task> mockTasks;
    late Task task1;
    late Task task2;
    late Task task3;

    setUp(() {
      task1 = Task(
        title: 'Buy groceries',
        description: 'Milk, Bread, Eggs',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        priority: 'high',
        completed: false,
        id: '1',
      );

      task2 = Task(
        title: 'Submit report',
        description: 'Project status report',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        priority: 'medium',
        completed: false,
        id: '2',
      );

      task3 = Task(
        title: 'Workout',
        description: 'Gym at 7 PM',
        dueDate: DateTime.now(),
        priority: 'low',
        completed: true,
        id: '3',
      );

      mockTasks = [task1, task2, task3];
    });

    testWidgets('renders user greeting and sections',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: HomePage(
          tasks: mockTasks,
          onTaskDeleted: (_) {},
          onTaskChecked: (_) {},
          userName: 'Islam Ali',
          userEmail: 'islam@example.com',
        ),
      ));

      await tester.pumpAndSettle();

      // ✅ تأكد من وجود الترحيب بالاسم الأول
      expect(find.text('Hello, Islam'), findsOneWidget);

      // ✅ تأكد من وجود عنوان المهام المعلقة
      expect(find.text('Pending Tasks'), findsOneWidget);

      // ✅ تأكد من وجود عنوان المهام المكتملة
      expect(find.text('Completed Tasks'), findsOneWidget);

      // ✅ تأكد من وجود عنوان مهمة واحدة على الأقل
      expect(find.text('Buy groceries'), findsOneWidget);
      expect(find.text('Submit report'), findsOneWidget);
      expect(find.text('Workout'), findsOneWidget);
    });

    testWidgets('logout confirmation dialog appears on tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: HomePage(
          tasks: mockTasks,
          onTaskDeleted: (_) {},
          onTaskChecked: (_) {},
          userName: 'Islam Ali',
          userEmail: 'islam@example.com',
        ),
      ));

      await tester.pumpAndSettle();

      // ✅ اضغط على زر تسجيل الخروج
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      // ✅ تأكد من ظهور مربع التأكيد
      expect(find.text('Logout Confirmation'), findsOneWidget);
      expect(find.text('Are you sure you want to logout of Donezo?'),
          findsOneWidget);

      // ✅ أزرار التأكيد موجودة
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });
  });
}
