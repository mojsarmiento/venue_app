import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:venue_app/models/venue.dart';

class VenueRepository {
  final String baseUrl = 'http://10.0.2.2/database'; // Change to your XAMPP server path

  Future<void> addVenue(Venue venue) async {
    final url = Uri.parse('$baseUrl/add_venue.php'); // Backend API to handle adding a venue

    // Convert the venue data into JSON format
    final response = await http.post(
      url,
      body: jsonEncode({
        'name': venue.name,
        'location': venue.location,
        'images': venue.images,
        'price_per_hour': venue.pricePerHour.toString(),
        'availability': venue.availability,
        'category': venue.category,
        'additional_details': venue.additionalDetails,
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add venue: ${response.body}');
    }
  }

  Future<List<Venue>> fetchVenues() async {
    final url = Uri.parse('$baseUrl/fetch_venues.php'); // Adjust this to your API endpoint
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((venueData) => Venue.fromJson(venueData)).toList(); // Assuming Venue has a fromJson method
    } else {
      throw Exception('Failed to fetch venues: ${response.body}');
    }
  }

  Future<void> deleteVenue(String venueId) async {
    final url = Uri.parse('$baseUrl/delete_venue.php'); // Adjust this to your API endpoint

    final response = await http.post(
      url,
      body: jsonEncode({'id': venueId}),
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

  Future<void> updateVenue(Venue venue) async {
  final url = Uri.parse('$baseUrl/update_venue.php'); // Adjust this to your API endpoint for updating venues

  // Convert the updated venue data into JSON format
  try {
    final response = await http.put(
      url,
      body: jsonEncode({
        'venue_id': venue.venueId,
        'name': venue.name,
        'location': venue.location,
        'images': venue.images.join(', '), // Convert list to string
        'price_per_hour': venue.pricePerHour.toString(),
        'availability': venue.availability,
        'category': venue.category,
        'additional_details': venue.additionalDetails,
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
      throw Exception('Failed to update venue: ${response.body}');
    }
  } catch (error) {
    print('Error occurred while updating venue: $error'); // Log any errors
    throw error; // Rethrow the error after logging it
  }
}

Future<void> uploadPermit(File businessPermit) async {
    // Prepare the request
    final uri = Uri.parse('$baseUrl/upload_permit.php'); // Replace with your upload endpoint
    final request = http.MultipartRequest('POST', uri);

    // Add the file to the request
    request.files.add(await http.MultipartFile.fromPath(
      'business_permit', // The field name for your file
      businessPermit.path,
    ));

    // Send the request
    final response = await request.send();

    // Check the response status
    if (response.statusCode != 200) {
      throw Exception('Failed to upload business permit. Status code: ${response.statusCode}');
    }
  }
}

