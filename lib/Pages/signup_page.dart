import 'package:donezo/Data/database.dart';
import 'package:donezo/Pages/org_home_page.dart';
import 'package:flutter/material.dart';
import 'package:donezo/Components/main_button.dart';
import 'package:donezo/theme.dart';
import 'package:donezo/Components/textbox.dart';
import 'package:donezo/Models/user.dart';
import 'package:donezo/Navigation/nagivation.dart';
import 'package:uuid/uuid.dart';

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

  String? _selectedUserType;
  String _organizationCode = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _handleSignup() async {
    // Field empty validation
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showErrorDialog('All fields are required');
      return;
    }

    // Name validation (letters only)
    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(_nameController.text)) {
      _showErrorDialog('Name can only contain letters');
      return;
    }
    if (_nameController.text.trimLeft().isEmpty) {
      _showErrorDialog('Name cannot begin with a space');
      return;
    }

    // Email validation
    if (!_emailController.text.contains('@')) {
      _showErrorDialog('Invalid email format');
      return;
    }

    // Password validation
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
      userType: _selectedUserType ?? 'Individual',
      organizationCode: _organizationCode.isNotEmpty ? _organizationCode : null,
    );

    await _db.init();
    final existingUser = _db.getUsers().any((u) => u.email == newUser.email);

    if (existingUser) {
      _showErrorDialog('Email already registered');
      return;
    }

    await _db.createUser(newUser);
    _db.setCurrentUser(newUser);

    // Navigate to OrgHomePage for organizations, otherwise to NavigationPage.
    if (newUser.userType == 'Organization') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NavigationPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NavigationPage()),
      );
    }
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

  Future<void> _showOrganizationCodeDialog() async {
    final codeController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text(
            'Organization Code',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          )),
          content: SizedBox(
            height: 100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextBox(
                  labelText: 'Enter organization code',
                  controller: codeController,
                  labelColor: Colors.grey[600],
                  fillColor: Theme.of(context).ourGrey,
                  borderColor: Colors.transparent,
                  width: 250,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                if (codeController.text == 'SWEN360') {
                  setState(() {
                    _organizationCode = codeController.text;
                    _selectedUserType = 'Organization';
                  });
                  Navigator.of(context).pop();
                } else {
                  _showErrorDialog('Please enter a valid organization code');
                }
              },
            ),
          ],
          insetPadding: const EdgeInsets.all(20),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
        );
      },
    );
  }

  Widget _buildUserTypeContainer(String type, IconData icon) {
    final isSelected = _selectedUserType == type;
    final isIndividual = type == 'Individual';

    return GestureDetector(
      onTap: () async {
        if (isIndividual) {
          setState(() => _selectedUserType = 'Individual');
        } else {
          await _showOrganizationCodeDialog();
        }
      },
      child: Container(
        height: 88,
        width: 155,
        decoration: BoxDecoration(
          color: isIndividual
              ? Theme.of(context).ourYellow
              : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                )
              : null,
        ),
        child: Stack(
          children: [
            Positioned(
              left: 50,
              top: 5,
              child: Icon(icon, size: 60),
            ),
            Positioned(
              left: isIndividual ? 42 : 30,
              top: 60,
              child: Text(
                type,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
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
    return Scaffold(
      body: Stack(
        children: [
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
              height: 720,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
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
                    TextBox(
                      labelText: 'Full Name',
                      controller: _nameController,
                      height: 90,
                      borderColor: Colors.transparent,
                      labelColor: Colors.grey[600],
                      fillColor: Theme.of(context).ourGrey,
                    ),
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
                      obscureText: _obscurePassword,
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
                      height: 90,
                      borderColor: Colors.transparent,
                      labelColor: Colors.grey[600],
                      fillColor: Theme.of(context).ourGrey,
                    ),
                    TextBox(
                      labelText: 'Confirm Password',
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[600],
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      height: 90,
                      borderColor: Colors.transparent,
                      labelColor: Colors.grey[600],
                      fillColor: Theme.of(context).ourGrey,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Row(
                        children: [
                          _buildUserTypeContainer('Individual', Icons.person),
                          const SizedBox(width: 20),
                          _buildUserTypeContainer(
                              'Organization', Icons.people_alt),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
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
                        text: 'Sign Up',
                        onPressed: _handleSignup,
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
    );
  }
}
