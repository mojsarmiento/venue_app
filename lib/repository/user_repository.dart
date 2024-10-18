import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:venue_app/models/user.dart';

class UserRepository {
  final String baseUrl = 'http://192.168.0.47/database'; // Your local server

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

   // Fetch submitted photos
  Future<List<User>> fetchSubmittedUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/fetch_submitted_photos.php'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        // Print the response for debugging
        print(jsonData); // Check what you are receiving from the server

        if (jsonData['success'] == true && jsonData['data'] is List) {
          return (jsonData['data'] as List)
              .map((userData) => User.fromJson(userData))
              .toList();
        } else {
          throw Exception('Unexpected response structure: ${jsonData.toString()}');
        }
      } else {
        throw Exception('Failed to fetch submitted users: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching submitted users: $e');
    }
  }

  // Accept user application
// Accept user application and update role to 'venue_owner'
Future<Map<String, dynamic>> acceptUserApplication(String userId, String s) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/accept_user_application.php'),
      body: {'user_id': userId},
    );

    final result = jsonDecode(response.body);
    if (result['success']) {
      // Update user role to 'venue_owner' after acceptance
      bool roleUpdated = await updateUserRole(userId, 'venue_owner');
      return {'success': roleUpdated};
    } else {
      print(result['error']);
      return {'success': false, 'error': result['error']};
    }
  } catch (e) {
    return {'success': false, 'error': e.toString()};
  }
}

// Deny user application without changing the role
Future<Map<String, dynamic>> denyUserApplication(String userId) async {
  try {
    final denyResponse = await http.post(
      Uri.parse('$baseUrl/deny_user_submission.php'),
      body: {'user_id': userId},
    );

    return jsonDecode(denyResponse.body);
  } catch (e) {
    return {'success': false, 'error': e.toString()};
  }
}


// Update user role
Future<bool> updateUserRole(String userId, String newRole) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/update_user_role.php'),
      body: {
        'user_id': userId,
        'user_type': newRole, // Ensure consistent naming
      },
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['success'];
    } else {
      return false;
    }
  } catch (e) {
    print('Error updating user role: $e');
    return false;
  }
}
}
