import 'package:donezo/Components/main_button.dart';
import 'package:donezo/Data/database.dart';
import 'package:donezo/Models/user.dart';
import 'package:donezo/theme.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../Navigation/nagivation.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DonezoDB _db = DonezoDB();
  final Uuid _uuid = const Uuid();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _handleSignup() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showErrorDialog('All fields are required');
      return;
    }

    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(_nameController.text)) {
      _showErrorDialog('Name can only contain letters');
      return;
    }

    if (_nameController.text.trimLeft().isEmpty) {
      _showErrorDialog('Name cannot begin with a space');
      return;
    }

    if (!_emailController.text.contains('@')) {
      _showErrorDialog('Invalid email format');
      return;
    }

    if (_passwordController.text.length < 8) {
      _showErrorDialog('Password must be at least 8 characters');
      return;
    }

    if (!RegExp(r'[0-9]').hasMatch(_passwordController.text)) {
      _showErrorDialog('Password must contain at least one number');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog('Passwords do not match');
      return;
    }

    final newUser = User(
      id: _uuid.v4(),
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    await _db.init();
    final existingUser = _db.getUsers().any((u) => u.email == newUser.email);

    if (existingUser) {
      _showErrorDialog('Email already registered');
      return;
    }

    await _db.createUser(newUser);
    _db.setCurrentUser(newUser);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NavigationPage()),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Signup Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF22162B), Color(0xFF451F55)],
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
              top: 150,
              child: Container(
                height: 720,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 36,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Join the donezo family',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Baloo2',
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 20),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      key: const Key('fullNameField'),
                                      controller: _nameController,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 15),
                                        errorStyle: const TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Baloo2',
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        hintText: 'Full Name',
                                        hintStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Baloo2',
                                          color: Colors.grey,
                                        ),
                                        labelStyle:
                                            TextStyle(color: Colors.grey[600]),
                                        filled: true,
                                        fillColor: Theme.of(context).ourGrey,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      key: const Key('emailField'),
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 15),
                                        errorStyle: const TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Baloo2',
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        hintText: 'Email',
                                        hintStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Baloo2',
                                          color: Colors.grey,
                                        ),
                                        labelStyle:
                                            TextStyle(color: Colors.grey[600]),
                                        filled: true,
                                        fillColor: Theme.of(context).ourGrey,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      key: const Key('passwordField'),
                                      controller: _passwordController,
                                      obscureText: _obscurePassword,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 15),
                                        errorStyle: const TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Baloo2',
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        hintText: 'Password',
                                        hintStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Baloo2',
                                          color: Colors.grey,
                                        ),
                                        labelStyle:
                                            TextStyle(color: Colors.grey[600]),
                                        filled: true,
                                        fillColor: Theme.of(context).ourGrey,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.grey[600],
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword =
                                                  !_obscurePassword;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      key: const Key('confirmPasswordField'),
                                      controller: _confirmPasswordController,
                                      obscureText: _obscureConfirmPassword,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 15),
                                        errorStyle: const TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Baloo2',
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        hintText: 'Confirm Password',
                                        hintStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Baloo2',
                                          color: Colors.grey,
                                        ),
                                        labelStyle:
                                            TextStyle(color: Colors.grey[600]),
                                        filled: true,
                                        fillColor: Theme.of(context).ourGrey,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureConfirmPassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.grey[600],
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureConfirmPassword =
                                                  !_obscureConfirmPassword;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40),
                              Container(
                                width: 330,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  gradient: const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFF461E55),
                                      Color(0xFF906DB0)
                                    ],
                                  ),
                                ),
                                child: MainButton(
                                  text: 'Sign Up',
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _handleSignup();
                                    }
                                  },
                                  width: 330,
                                  height: 45,
                                  fontSize: 22,
                                  color: Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
