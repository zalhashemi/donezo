import 'package:donezo/Components/dropdown.dart';
import 'package:donezo/Components/main_button.dart';
import 'package:donezo/Pages/login_page.dart';
import 'package:donezo/Pages/signup_page.dart';
import 'package:donezo/theme.dart';
import 'package:flutter/material.dart';

class StarterPage extends StatefulWidget {
  const StarterPage({super.key});

  @override
  State<StarterPage> createState() => _StarterPageState();
}

class _StarterPageState extends State<StarterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
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
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Welcome to\n     donezo',
                style: TextStyle(
                  height: 0.8,
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              Image.asset(
                'lib/Images/dino.png',
                width: 140,
                height: 140,
              ),
              const SizedBox(height: 70),
              MainButton(
                  text: 'Login',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  width: 250,
                  fontSize: 20,
                  color: Theme.of(context).ourYellow),
              const SizedBox(height: 10),
              MainButton(
                  text: 'Create Account',
                  width: 250,
                  fontSize: 20,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupPage()),
                    );
                  },
                  color: Theme.of(context).colorScheme.tertiary),
            ],
          ),
        ),
      ),
    );
  }
}
