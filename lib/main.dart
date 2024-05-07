import 'package:flutter/material.dart';
import 'package:tasks_app/db_provider/sqlite_manager.dart';
import 'package:tasks_app/screens/user_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: 'login',
      routes: {
        'login':(context) => UserScreen()
      },
    );
  }
}