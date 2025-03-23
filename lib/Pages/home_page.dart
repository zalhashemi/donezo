import 'package:flutter/material.dart';
import 'package:donezo/theme.dart';
import 'package:donezo/nagivation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Main Content')), // Add your main content here
    );
  }
}
