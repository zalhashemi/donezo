import 'package:donezo/Components/progress_tile.dart';
import 'package:donezo/Models/task.dart';
import 'package:donezo/Pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomePage Widget Test', () {
    late List<Task> sampleTasks;

    setUp(() {
      sampleTasks = [
        Task(
          title: 'High Priority Task',
          description: 'Urgent',
          completed: false,
          dueDate: DateTime.now(),
          priority: 'high',
          id: 'task1',
        ),
        Task(
          title: 'Completed Task',
          description: 'Done',
          completed: true,
          dueDate: DateTime.now(),
          priority: 'low',
          id: 'task2',
        ),
      ];
    });

    Widget createHomePage() {
      return MaterialApp(
        home: HomePage(
          tasks: sampleTasks,
          userName: 'Islam Mohamed',
          userEmail: 'islam@test.com',
          onTaskDeleted: (task) {},
          onTaskChecked: (task) {},
        ),
      );
    }

    testWidgets('displays greeting with user name',
        (WidgetTester tester) async {
      await tester.pumpWidget(createHomePage());
      expect(find.text('Hello, Islam'), findsOneWidget);
    });

    testWidgets('displays ProgressTile widget', (WidgetTester tester) async {
      await tester.pumpWidget(createHomePage());
      expect(find.byType(ProgressTile), findsOneWidget);
    });

    testWidgets('displays task sections correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createHomePage());
      expect(find.text('Pending Tasks'), findsOneWidget);
      expect(find.text('Completed Tasks'), findsOneWidget);
    });

    testWidgets('displays message when no tasks', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: HomePage(
          tasks: [],
          userName: 'Test User',
          userEmail: 'test@test.com',
          onTaskDeleted: (_) {},
          onTaskChecked: (_) {},
        ),
      ));
      await tester.pump();
      expect(find.text('You have no pending tasks!'), findsOneWidget);
      expect(find.text('No completed tasks yet!'), findsOneWidget);
    });

    testWidgets('logout dialog appears on icon tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(createHomePage());

      // Tap on logout button
      final logoutIcon = find.byIcon(Icons.logout);
      expect(logoutIcon, findsOneWidget);
      await tester.tap(logoutIcon);
      await tester.pumpAndSettle();

      // Verify dialog content
      expect(find.text('Logout Confirmation'), findsOneWidget);
      expect(find.text('Are you sure you want to logout of Donezo?'),
          findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });
  });
}
