import 'package:donezo/Models/task.dart';
import 'package:donezo/Pages/calendar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  group('CalendarPage Widget Tests', () {
    late List<Task> testTasks;

    setUp(() {
      testTasks = [
        Task(
          title: 'Task 1',
          description: 'This is Task 1',
          dueDate: DateTime.now(),
          completed: false,
          id: 'task1',
        ),
        Task(
          title: 'Task 2',
          description: 'This is Task 2',
          dueDate: DateTime.now(),
          completed: true,
          id: 'task2',
        ),
      ];
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: CalendarPage(
          tasks: testTasks,
          onTaskDeleted: (_) {},
          onTaskChecked: (_) {},
          userName: 'Test User',
          userEmail: 'test@example.com',
        ),
      );
    }

    testWidgets('displays CalendarPage with all main UI components',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(CalendarPage), findsOneWidget);
      expect(find.byType(TableCalendar), findsOneWidget);
      expect(find.text('All Tasks'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('shows tasks for selected day', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // يجب أن يظهر أحد المهام على الأقل
      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task 2'), findsOneWidget);
    });

    testWidgets('filters tasks correctly when "Pending" is selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pending'));
      await tester.pumpAndSettle();

      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task 2'), findsNothing);
    });

    testWidgets('filters tasks correctly when "Done" is selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(find.text('Task 2'), findsOneWidget);
      expect(find.text('Task 1'), findsNothing);
    });

    testWidgets('shows message when no tasks for selected day',
        (WidgetTester tester) async {
      // تاريخ مختلف لا يحتوي على أي مهام
      testTasks = [
        Task(
          title: 'Old Task',
          description: 'No tasks today',
          dueDate: DateTime(2000, 1, 1),
          completed: false,
          id: 'task-old',
        ),
      ];

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('No tasks for selected date'), findsOneWidget);
    });
  });
}
