import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedRole = 'Candidate'; // Default role selection

  Future<void> signUp(BuildContext context) async {
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final email = emailController.text;
    final password = passwordController.text;

    try {
      final url = Uri.parse('http://192.168.42.10:5000/api/auth');
      final response = await http.post(
        url,
        body: json.encode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
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

        // Registration successful, handle token or navigate to another screen
        print('Registration successful. Token: $token');

        // Navigate to the job list screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/job_list', // Replace with the actual named route for the job list screen
          (route) => false, // Remove all previous routes from the stack
        );
      } else {
        final errorMessage = json.decode(response.body)['message'];
        // Registration failed, handle error
        print('Registration failed. Error: $errorMessage');
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
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
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
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await signUp; // Pass the context and selected role to the signUp method
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
