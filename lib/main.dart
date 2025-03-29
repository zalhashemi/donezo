import 'package:donezo/Navigation/nagivation.dart';
import 'package:donezo/Pages/home_page.dart';
import 'package:donezo/Pages/starter_page.dart';

import 'package:donezo/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donezo',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: const NavigationPage(),
    );
  }
}
