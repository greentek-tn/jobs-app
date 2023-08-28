import 'package:flutter/material.dart';
import 'package:jobs/jobs.dart';
import 'package:jobs/login.dart';
import 'package:jobs/registre.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job app Malek',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: getToken() != null ? '/job_list' : '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/job_list': (context) => JobsList(),
      },
    );
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
