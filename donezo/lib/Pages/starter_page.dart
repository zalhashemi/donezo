import 'package:donezo/Components/main_button.dart';
import 'package:donezo/Pages/login_page.dart';
import 'package:donezo/Pages/signup_page.dart';
import 'package:donezo/theme.dart';
import 'package:flutter/material.dart';

// This is the first page users see when they open the Donezo app
class StarterPage extends StatelessWidget {
  const StarterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the app's theme

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // Apply a vertical gradient background
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF22162B),
              Color(0xFF451F55),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Shrink column to fit children
            children: [
              // App welcome message
              const Text(
                'Welcome to\ndonezo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 0.8,
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),

              // Display the logo/image
              Image.asset(
                'lib/Images/dino.png',
                width: 140,
                height: 140,
              ),
              const SizedBox(height: 70),

              // "Login" button
              MainButton(
                text: 'Login',
                width: 250,
                fontSize: 20,
                color: theme.ourYellow,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),

              // "Create Account" button
              MainButton(
                text: 'Create Account',
                width: 250,
                fontSize: 20,
                color: theme.colorScheme.tertiary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SignupPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
