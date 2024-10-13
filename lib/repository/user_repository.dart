import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:venue_app/models/user.dart';

class UserRepository {
  final String baseUrl = 'http://10.0.2.2/database'; // Your local server

  // Fetch user count excluding admin users
  Future<int> fetchUserCount() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/fetch_users.php'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        // Filter out Admin users
        final List<User> users = jsonData.map((user) => User.fromJson(user)).toList();
        final int userCount = users.where((user) => user.userType != 'admin').length; // Count non-admin users
        return userCount;
      } else {
        throw Exception('Failed to fetch users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user count: $e');
    }
  }

  // Fetch all users
  Future<List<User>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/fetch_users.php'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((user) => User.fromJson(user)).toList();
      } else {
        throw Exception('Failed to fetch users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  // Delete user by ID
  Future<void> deleteUser(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/delete_user.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'id': userId}), // Send the user ID in the body
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }

  Future<void> updateUser(User user) async {
    final url = Uri.parse('$baseUrl/update_user.php'); // Adjust this to your API endpoint for updating users

    // Convert the updated user data into JSON format
    try {
      final response = await http.put(
        url,
        body: jsonEncode({
          'user_id': user.userId, // Assuming userId is a property of User
          'full_name': user.fullName,
          'email': user.email,
          'user_type': user.userType,
        }),
        headers: {"Content-Type": "application/json"},
      );

      print('Response status: ${response.statusCode}'); // Log the status code
      print('Response body: ${response.body}'); // Log the response body

      // Check if response is valid JSON
      if (response.statusCode == 200) {
        try {
          final responseBody = jsonDecode(response.body);
          if (responseBody is Map<String, dynamic>) {
            // Check for the message key in the response
            if (responseBody.containsKey("message")) {
              print(responseBody["message"]); // Log the message from the response
            }
          }
        } catch (e) {
          print('Error decoding response: $e');
          throw Exception('Failed to decode response');
        }
      } else {
        throw Exception('Failed to update user: ${response.body}');
      }
    } catch (error) {
      print('Error occurred while updating user: $error'); // Log any errors
      throw error; // Rethrow the error after logging it
    }
  }
}
