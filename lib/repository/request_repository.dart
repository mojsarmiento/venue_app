// request_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:venue_app/models/request.dart';

class RequestRepository {
  Future<List<Request>> fetchRequests() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/database/fetch_requests.php'));

    if (response.statusCode == 200) {
      // Decode the JSON response directly to a List
      final List<dynamic> jsonResponse = json.decode(response.body);
      
      // Map the dynamic list to a List of Request objects
      return jsonResponse.map((request) => Request.fromJson(request)).toList();
    } else {
      throw Exception('Failed to load requests: ${response.statusCode}');
    }
  }

  Future<int> fetchTotalRequest() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2/database/request_count.php'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Check if 'count' exists and is not null
        if (data.containsKey('count')) {
          return int.tryParse(data['count'].toString()) ?? 0; // Return 0 if parsing fails
        } else {
          throw Exception('Count key not found in response');
        }
      } else {
        throw Exception('Failed to fetch total venues: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching total venues: $e');
    }
  }

  Future<void> deleteRequests(String id) async {
    final url = Uri.parse('http://10.0.2.2/database/delete_requests.php'); // Adjust this to your API endpoint

    final response = await http.post(
      url,
      body: jsonEncode({'id': id}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      // Optionally handle response here
      final responseBody = jsonDecode(response.body);
      if (responseBody['message'] != null) {
        print(responseBody['message']);
      }
    } else {
      throw Exception('Failed to delete venue: ${response.body}');
    }
  }

  Future<void> approveRequest(String id) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/database/approve_request.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to approve request');
    }
  }

  Future<void> rejectRequest(String id) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/database/reject_request.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reject request');
    }
  }

  // New method to mark a request as done
  Future<void> markAsDone(String id) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/database/mark_as_done.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark request as done');
    }
  }
}
