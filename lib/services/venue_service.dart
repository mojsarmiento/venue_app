import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:venue_app/models/venue.dart';

class VenueService {
  static Future<List<Venue>> fetchAll() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/database/fetch_venues.php'));

    print('Response status: ${response.statusCode}'); // Log the status code
    print('Response body: ${response.body}'); // Log the response body

    if (response.statusCode == 200) {
      try {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Venue.fromJson(json)).toList();
      } catch (e) {
        throw Exception('Failed to parse JSON: $e'); // Better error handling
      }
    } else {
      throw Exception('Failed to load venues: ${response.body}'); // Include body in exception
    }
  }
}
