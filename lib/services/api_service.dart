import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = 'http://10.0.2.2/database'; // Base URL for your API

  // Method to call login API
  Future<ApiResponse> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login.php'); // Adjusted URL
    final response = await http.post(
      url,
      body: json.encode({
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        return ApiResponse(
          isSuccess: true,
          message: data['message'],
          userType: data['data']['user_type'], // Extract user type if necessary
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

  ApiResponse({required this.isSuccess, this.message, this.userType});
}
