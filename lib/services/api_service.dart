import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2/database/login.php'; // Base URL for your API

  // Method to call login API
  Future<ApiResponse> login(String email, String password) async {
  final url = Uri.parse(baseUrl);
  final response = await http.post(
    url,
    body: json.encode({
      'email': email,
      'password': password,
    }),
    headers: {'Content-Type': 'application/json'},
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}'); // Debug: Print response body

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['success']) {
        // Save user data in SharedPreferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('full_name', data['data']['full_name'] ?? ''); // Handle potential null
        await prefs.setString('user_id', data['data']['user_id'] ?? ''); // Handle potential null

        return ApiResponse(
          isSuccess: true,
          message: data['message'],
          userType: data['data']['user_type'], // Extract user type if necessary
          fullName: data['data']['full_name'] ?? '', // Handle potential null
          userId: data['data']['user_id'] ?? '', // Handle potential null
        );
      } else {
        return ApiResponse(isSuccess: false, message: data['message']);
      }
    } else {
      return ApiResponse(isSuccess: false, message: 'Server error.');
    }
  }

}

class ApiResponse {
  final bool isSuccess;
  final String? message;
  final String? userType;
  final String? fullName;
  final String? userId; // Add userId field

  ApiResponse({
    required this.isSuccess,
    this.message,
    this.userType,
    this.fullName, // Include fullName in the constructor
    this.userId, // Include userId in the constructor
  });
}
