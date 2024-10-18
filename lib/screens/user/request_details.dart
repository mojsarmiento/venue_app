import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io'; // Import the dart:io library
import 'package:intl/intl.dart'; // Import the intl package

class RequestVisitDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> requestVisitDetails; // Updated type here
  final List<File> venueImages; // Change to List<File>

  const RequestVisitDetailsScreen({
    super.key,
    required this.requestVisitDetails,
    required this.venueImages, // Add this to the constructor
  });

  @override
  Widget build(BuildContext context) {
    final String status = requestVisitDetails['status'] ?? 'Unknown';

    // Determine the status color, text, icon, and message
    Color statusColor;
    String statusText;
    Icon statusIcon;
    String statusMessage;

    switch (status) {
      case 'Approved':
        statusColor = Colors.green;
        statusText = 'Approved';
        statusIcon = const Icon(Icons.check_circle, color: Colors.green);
        statusMessage = 'Please arrive on time for your visit.'; // Message for approved
        break;
      case 'Pending':
        statusColor = Colors.orange;
        statusText = 'Pending';
        statusIcon = const Icon(Icons.access_time, color: Colors.orange);
        statusMessage = 'Please wait for approval.'; // Message for pending
        break;
      case 'Rejected':
        statusColor = Colors.red;
        statusText = 'Rejected';
        statusIcon = const Icon(Icons.cancel, color: Colors.red);
        statusMessage = 'Your request was rejected due to unavailability or other reasons.'; // Message for rejected
        break;
      case 'Done':
        statusColor = Colors.blue;
        statusText = 'Done';
        statusIcon = const Icon(Icons.check_circle, color: Colors.blue);
        statusMessage = 'Thank you for visiting!'; // Message for done status
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown';
        statusIcon = const Icon(Icons.help, color: Colors.grey);
        statusMessage = 'Status is unknown. Please contact support.'; // Message for unknown status
    }

    // Formatting the time
    String formatTime(String time) {
      try {
        DateTime dateTime = DateFormat("HH:mm").parse(time); // Adjust the format if necessary
        return DateFormat.jm().format(dateTime); // Format to AM/PM
      } catch (e) {
        return time; // Return original time if parsing fails
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Visit Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00008B), Color(0xFF5D3FD3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0), // Border radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CarouselSlider for local images
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 200, // Height of the carousel
                        aspectRatio: 16 / 9,
                        viewportFraction: 1.0,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      ),
                      items: venueImages.map((file) { // Iterate over the list of File objects
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  file, // Use Image.file to display the local file
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(Icons.error, color: Colors.red),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(), // Convert the map to a list
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Venue Name with null safety check
                  Text(
                    'Venue: ${requestVisitDetails['venue_name'] ?? 'Unknown Venue'}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00008B),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Venue Location with null safety check
                  Text(
                    'Location: ${requestVisitDetails['location'] ?? 'Unknown Location'}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Visit Date with null safety check
                  Text(
                    'Date: ${requestVisitDetails['request_date'] ?? 'Unknown Date'}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Visit Time with null safety check and AM/PM formatting
                  Text(
                    'Time: ${formatTime(requestVisitDetails['request_time'] ?? 'Unknown Time')}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Status Section
                  Row(
                    children: [
                      statusIcon,
                      const SizedBox(width: 8),
                      Text(
                        'Status: $statusText',
                        style: TextStyle(
                          fontSize: 18,
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Status Message Section
                  Text(
                    statusMessage,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


