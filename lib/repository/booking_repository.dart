import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:venue_app/models/booking.dart';

class BookingRepository {
  final String baseUrl = 'http://192.168.0.47/database'; // Replace with your actual URL

  // Fetch bookings
  Future<List<Booking>> getBookings() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/fetch_booking.php'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((booking) => Booking.fromJson(booking)).toList();
      } else {
        // Log the response body for debugging
        print('Error fetching bookings: ${response.body}');
        throw Exception('Failed to load bookings');
      }
    } catch (e) {
      // Handle exceptions and print them for debugging
      print('Exception while fetching bookings: $e');
      throw Exception('Failed to load bookings: $e');
    }
  }

  Future<void> deleteBookings(String id) async {
    final url = Uri.parse('http://192.168.0.47/database/delete_booking.php'); // Adjust this to your API endpoint

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

  // Create a booking
  Future<void> createBooking(Booking booking) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/booking.php'),
        headers: {
          'Content-Type': 'application/json', // Specify that the content type is JSON
        },
        body: json.encode(booking.toJson()), // Encode the booking data as JSON
      );

      if (response.statusCode != 200) {
        // Log the response body for debugging
        print('Error creating booking: ${response.body}');
        throw Exception('Failed to create booking: ${response.body}');
      }
    } catch (e) {
      // Handle exceptions and print them for debugging
      print('Exception while creating booking: $e');
      throw Exception('Failed to create booking: $e');
    }
  }

  // Fetch total bookings
  Future<int> fetchTotalBookings() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/booking_count.php'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Check if 'count' exists and is not null
        if (data.containsKey('count')) {
          return int.tryParse(data['count'].toString()) ?? 0; // Return 0 if parsing fails
        } else {
          throw Exception('Count key not found in response');
        }
      } else {
        throw Exception('Failed to fetch total bookings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching total bookings: $e');
    }
  }
}
