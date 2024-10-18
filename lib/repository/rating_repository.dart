// lib/repositories/venue_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class RatingRepository {
  final String apiUrl = 'http://192.168.0.47/database/submit_rating.php'; // Update with your API URL

  Future<String> submitRating(String venueId, double rating) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'venue_id': venueId.toString(),
        'rating': rating.toString(),
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        return data['message'];
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception('Failed to submit rating');
    }
  }
}
