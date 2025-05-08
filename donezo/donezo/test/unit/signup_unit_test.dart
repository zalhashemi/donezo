import 'package:donezo/Data/database.dart';
import 'package:donezo/Pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDonezoDB extends Mock implements DonezoDB {}

void main() {
  group('SignupPage', () {
    late MockDonezoDB mockDB;

    setUp(() {
      mockDB = MockDonezoDB();
    });

    Future<void> pumpSignupPage(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SignupPage(),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('Shows error if fields are empty', (WidgetTester tester) async {
      await pumpSignupPage(tester);

      final signupButton = find.text('Sign Up');
      expect(signupButton, findsOneWidget);

      await tester.tap(signupButton);
      await tester.pump();

      expect(find.text('All fields are required'), findsOneWidget);
    });

    testWidgets('Shows error for invalid name', (WidgetTester tester) async {
      await pumpSignupPage(tester);

      await tester.enterText(
        find.byWidgetPredicate((widget) =>
            widget is TextField && widget.decoration?.hintText == 'Full Name'),
        '1234',
      );
      await tester.enterText(
        find.byWidgetPredicate((widget) =>
            widget is TextField && widget.decoration?.hintText == 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.byWidgetPredicate((widget) =>
            widget is TextField && widget.decoration?.hintText == 'Password'),
        'Password1',
      );
      await tester.enterText(
        find.byWidgetPredicate((widget) =>
            widget is TextField &&
            widget.decoration?.hintText == 'Confirm Password'),
        'Password1',
      );

      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      expect(find.text('Name can only contain letters'), findsOneWidget);
    });

    testWidgets('Shows error for weak password', (WidgetTester tester) async {
      await pumpSignupPage(tester);
      await tester.enterText(
        find.byWidgetPredicate((widget) =>
            widget is TextField && widget.decoration?.hintText == 'Full Name'),
        'John Doe',
      );
      await tester.enterText(
        find.byWidgetPredicate((widget) =>
            widget is TextField && widget.decoration?.hintText == 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.byWidgetPredicate((widget) =>
            widget is TextField && widget.decoration?.hintText == 'Password'),
        'abc',
      );
      await tester.enterText(
        find.byWidgetPredicate((widget) =>
            widget is TextField &&
            widget.decoration?.hintText == 'Confirm Password'),
        'abc',
      );

      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      expect(
          find.text('Password must be at least 8 characters'), findsOneWidget);
    });

    testWidgets('Shows error if passwords do not match',
        (WidgetTester tester) async {
      await pumpSignupPage(tester);

      await tester.enterText(
        find.byWidgetPredicate((widget) =>
            widget is TextField && widget.decoration?.hintText == 'Full Name'),
        'John Doe',
      );
      await tester.enterText(
        find.byWidgetPredicate((widget) =>
            widget is TextField && widget.decoration?.hintText == 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.byWidgetPredicate((widget) =>
            widget is TextField && widget.decoration?.hintText == 'Password'),
        'Password1',
      );
      await tester.enterText(
        find.byWidgetPredicate((widget) =>
            widget is TextField &&
            widget.decoration?.hintText == 'Confirm Password'),
        'Password2',
      );

      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    // يمكنك لاحقًا إنشاء test خاص بـ MockDonezoDB للتحقق من التعامل مع المستخدم المسجل بالفعل
  });
}
