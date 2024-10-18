import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:venue_app/widgets/custom_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  void _sendResetLink() async {
    final response = await http.post(
      Uri.parse('http://192.168.0.47/database/forgot_password.php'),
      body: {'email': _emailController.text},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(responseData['message']);
      _showDialog('Success', responseData['message']); // Show success dialog
    } else {
      print('Failed to send reset link');
      _showDialog('Error', 'Failed to send reset link.'); // Show error dialog
    }
  }

  // Method to show alert dialog
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Adjust the UI when the keyboard appears
      body: SafeArea(
        child: SingleChildScrollView( // Allow scrolling
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height, // Make it full height
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00008B), Color(0xFF5D3FD3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
              child: Theme(
                data: ThemeData(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Enter your email below to receive your password reset instructions',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email, color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'Send Reset Link',
                      onPressed: _sendResetLink,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Go back to the login page
                      },
                      style: TextButton.styleFrom(foregroundColor: Colors.white),
                      child: const Text('Remembered your password? Log In'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

