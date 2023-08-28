import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedRole = 'Candidate'; // Default role selection

  Future<void> logIn(BuildContext context, String role) async {
    final email = emailController.text;
    final password = passwordController.text;

    try {
      final url = Uri.parse('http://192.168.42.10:5000/api/auth/login');
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'role': role, // Include the role in the request body
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        // Login successful, handle token or navigate to another screen
        print('Login successful. Token: $token');

        // Navigate to the job list screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/job_list', // Replace with the actual named route for the job list screen
          (route) => false, // Remove all previous routes from the stack
        );
      } else {
        final errorMessage = json.decode(response.body)['message'];
        // Login failed, handle error
        print('Login failed. Error: $errorMessage');
      }
    } catch (error) {
      // Handle any other errors
      print('An error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedRole,
              onChanged: (String? value) {
                selectedRole = value!;
              },
              items: ['Candidate', 'Recruiter']
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      ))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await logIn(context,
                    selectedRole); // Pass the context and selected role to the logIn method
              },
              child: Text('Log In'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
