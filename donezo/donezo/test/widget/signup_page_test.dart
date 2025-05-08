import 'package:donezo/Pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignupPage Widget Test', () {
    testWidgets('Should display all form fields and submit button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupPage(),
        ),
      );

      // التحقق من وجود حقول الإدخال
      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // التحقق من وجود العنوان
      expect(find.text('Get Started'), findsOneWidget);
      expect(find.text('Join the donezo family'), findsOneWidget);
    });

    testWidgets('Shows error when fields are empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupPage(),
        ),
      );

      final signupButton = find.text('Sign Up');
      await tester.tap(signupButton);
      await tester.pumpAndSettle();

      expect(find.text('All fields are required'), findsOneWidget);
    });

    testWidgets('Shows error on invalid email format',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupPage()));

      await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
      await tester.enterText(find.byType(TextFormField).at(1), 'invalidemail');
      await tester.enterText(find.byType(TextFormField).at(2), 'Password123!');
      await tester.enterText(find.byType(TextFormField).at(3), 'Password123!');

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('Invalid email format'), findsOneWidget);
    });

    testWidgets('Shows error on password mismatch',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupPage()));

      await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
      await tester.enterText(
          find.byType(TextFormField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(2), 'Password123!');
      await tester.enterText(find.byType(TextFormField).at(3), 'Different123!');

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });
  });
}
