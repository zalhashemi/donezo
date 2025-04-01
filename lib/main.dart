import 'package:donezo/Data/database.dart';
import 'package:donezo/Models/task.dart';
import 'package:donezo/Models/user.dart';
import 'package:donezo/Navigation/nagivation.dart';
import 'package:donezo/Pages/home_page.dart';
import 'package:donezo/Pages/login_page.dart';
import 'package:donezo/Pages/starter_page.dart';

import 'package:donezo/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter()); // Make sure this is registered
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox('donezo_main_box');
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
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DonezoDB().init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final currentUser = DonezoDB().getCurrentUser();
          return currentUser != null
              ? const NavigationPage()
              : const StarterPage();
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
