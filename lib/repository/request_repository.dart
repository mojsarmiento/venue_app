// request_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:venue_app/models/request.dart';

class RequestRepository {
  Future<List<Request>> fetchRequests() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/database/fetch_requests.php'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      
      // Check if the API response has a key for requests and that it returns a list
      if (jsonResponse['requests'] != null) {
        final List<dynamic> requestsJson = jsonResponse['requests'];
        return requestsJson.map((request) => Request.fromJson(request)).toList();
      } else {
        throw Exception('No requests found in response');
      }
    } else {
      throw Exception('Failed to load requests: ${response.statusCode}');
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
}
