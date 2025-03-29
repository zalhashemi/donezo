import 'package:donezo/Components/main_button.dart';
import 'package:donezo/Pages/home_page.dart';
import 'package:donezo/Pages/signup_page.dart';
import 'package:donezo/theme.dart';
import 'package:flutter/material.dart';
import 'package:donezo/Components/textbox.dart';
import 'package:donezo/Navigation/nagivation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Add controllers for email and password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
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
          ),
          Positioned(
            left: 20,
            top: 40,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            left: 120,
            top: 80,
            child: Image.asset(
              'lib/Images/dino.png',
              width: 50,
              height: 50,
            ),
          ),
          const Positioned(
            left: 180,
            top: 85,
            child: Text(
              'donezo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 700,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 36,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Enter your details',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Baloo2',
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextBox(
                    labelText: 'Email',
                    controller: _emailController,
                    height: 90,
                    borderColor: Colors.transparent,
                    labelColor: Colors.grey[600],
                    fillColor: Theme.of(context).ourGrey,
                  ),
                  TextBox(
                    labelText: 'Password',
                    controller: _passwordController,
                    height: 90,
                    borderColor: Colors.transparent,
                    labelColor: Colors.grey[600],
                    fillColor: Theme.of(context).ourGrey,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 330,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF461E55),
                          Color(0xFF906DB0),
                        ],
                      ),
                    ),
                    child: MainButton(
                      text: 'Login',
                      onPressed: () {},
                      width: 330,
                      height: 45,
                      fontSize: 22,
                      color: Colors.transparent,
                    ),
                  ),
                  // SizedBox(height: 10),
                  // Text(
                  //   'Forgot Password?',
                  //   style: TextStyle(
                  //     fontSize: 15,
                  //     fontWeight: FontWeight.w500,
                  //     fontFamily: 'Baloo2',
                  //     color: Theme.of(context).colorScheme.primary,
                  //   ),
                  // ),
                  SizedBox(height: 170),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupPage()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Don\'t have an account? ',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: 'Sign up now!',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
