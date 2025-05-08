import 'package:donezo/Models/task.dart';
import 'package:donezo/Pages/calendar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalendarPage Widget Tests', () {
    // إعداد بيانات وهمية
    final testTask1 = Task(
      title: 'Task 1',
      dueDate: DateTime.now(),
      completed: false,
      id: '1',
    );

    final testTask2 = Task(
      title: 'Task 2',
      dueDate: DateTime.now(),
      completed: true,
      id: '2',
    );

    late List<Task> tasks;

    setUp(() {
      tasks = [testTask1, testTask2];
    });

    testWidgets('CalendarPage renders tasks and filters correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CalendarPage(
          tasks: tasks,
          onTaskDeleted: (_) {},
          onTaskChecked: (_) {},
          userName: 'Test User',
          userEmail: 'test@email.com',
        ),
      ));

      // التحقق من وجود الفلاتر
      expect(find.text('All Tasks'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);

      // التحقق من وجود المهام
      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task 2'), findsOneWidget);

      // تغيير الفلتر إلى "Pending"
      await tester.tap(find.text('Pending'));
      await tester.pumpAndSettle();

      // يجب أن تظهر فقط المهام غير المكتملة
      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task 2'), findsNothing);
    });

    testWidgets('Logout dialog appears when tapping logout button',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CalendarPage(
          tasks: tasks,
          onTaskDeleted: (_) {},
          onTaskChecked: (_) {},
          userName: 'Test User',
          userEmail: 'test@email.com',
        ),
      ));

      // الضغط على زر تسجيل الخروج
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      // التأكد من عرض نافذة التأكيد
      expect(find.text('Logout Confirmation'), findsOneWidget);
      expect(find.text('Are you sure you want to logout of Donezo?'),
          findsOneWidget);
    });
  });
}
