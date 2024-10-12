// lib/repositories/registration_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrationRepository {
  final String apiUrl = 'http://10.0.2.2/database/register_user.php'; // Replace with your API endpoint

  Future<bool> registerUser(String fullName, String email, String password, List<String> userTypes) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'full_name': fullName,
          'email': email,
          'password': password,
          'user_types': userTypes,
        }),
      );

      if (response.statusCode == 200) {
        return true; // Registration successful
      } else {
        // Handle errors based on response
        return false;
      }
    } catch (e) {
      print("Error during registration: $e");
      return false;
    }
  }
}
