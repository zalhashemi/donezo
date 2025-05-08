import 'package:donezo/Pages/login_page.dart';
import 'package:donezo/Pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'login_page_test.mocks.dart';

@GenerateMocks([NavigatorObserver])
void main() {
  late MockNavigatorObserver mockObserver;

  setUp(() {
    mockObserver = MockNavigatorObserver();
  });

  Future<void> _buildLoginPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const LoginPage(),
        navigatorObservers: [mockObserver],
      ),
    );
  }

  testWidgets('Displays email and password fields',
      (WidgetTester tester) async {
    await _buildLoginPage(tester);

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('Shows error when fields are empty', (WidgetTester tester) async {
    await _buildLoginPage(tester);

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('Shows error for invalid email format',
      (WidgetTester tester) async {
    await _buildLoginPage(tester);

    await tester.enterText(find.byType(TextFormField).first, 'invalidemail');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a valid email address'), findsOneWidget);
  });

  testWidgets('Navigates to SignupPage when tapped',
      (WidgetTester tester) async {
    await _buildLoginPage(tester);

    await tester.tap(find.textContaining('Sign up now!'));
    await tester.pumpAndSettle();

    expect(find.byType(SignupPage), findsOneWidget);
  });
}
