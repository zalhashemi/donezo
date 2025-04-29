import 'package:donezo/Components/main_button.dart';
import 'package:donezo/Data/database.dart';
import 'package:donezo/Models/user.dart';
import 'package:donezo/Navigation/nagivation.dart';
import 'package:donezo/Pages/signup_page.dart';
import 'package:donezo/theme.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  final DonezoDB _db = DonezoDB();
  bool _obscurePassword = true;

  int _failedLoginAttempts = 0;
  bool _isLocked = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_isLocked) {
      _showErrorDialog('Too many failed attempts. Please try again later.');
      return;
    }

    if (_loginFormKey.currentState!.validate()) {
      await _db.init();
      final users = _db.getUsers();
      final user = users.firstWhere(
        (u) =>
            u.email == _emailController.text.trim() &&
            u.password == _passwordController.text,
        orElse: () => User(id: '', name: '', email: '', password: ''),
      );

      if (user.id.isNotEmpty) {
        _db.setCurrentUser(user);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NavigationPage()),
        );
      } else {
        _failedLoginAttempts++;
        if (_failedLoginAttempts >= 5) {
          setState(() {
            _isLocked = true;
          });
          Future.delayed(const Duration(minutes: 2), () {
            setState(() {
              _isLocked = false;
              _failedLoginAttempts = 0;
            });
          });
        }
        _showErrorDialog('Invalid email or password. Please try again.');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            'Login Failed',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
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
          child: Form(
            key: _loginFormKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/Images/dino.png',
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'donezo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(40)),
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
                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email is required';
                            }
                            final emailRegex =
                                RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                            if (!emailRegex.hasMatch(value.trim())) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            errorStyle: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Baloo2',
                            ),
                            hintText: 'Email',
                            hintStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Baloo2',
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: Theme.of(context).ourGrey,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            errorStyle: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Baloo2',
                            ),
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Baloo2',
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: Theme.of(context).ourGrey,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey[600],
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Fixed container and button placement
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 330,
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
                              onPressed: _handleLogin,
                              width: 330,
                              height: 45,
                              fontSize: 22,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 80),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupPage(),
                              ),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Don\'t have an account? ',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Sign up now!',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
