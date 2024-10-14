import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class RequestVisitDetailsScreen extends StatelessWidget {
   final Map<String, dynamic> requestVisitDetails; // Update type here

  const RequestVisitDetailsScreen({super.key, required this.requestVisitDetails});

  @override
  Widget build(BuildContext context) {
    // Placeholder images for carousel
    final List<String> placeholderImages = [
      'assets/images/venuetest.jpg',
      'assets/images/venuetest.jpg',
      'assets/images/venuetest.jpg',
    ];

    // Extract the status from the requestVisitDetails map with null safety
    final String status = requestVisitDetails['status'] ?? 'Unknown';

    // Determine the status color, text, and icon
    Color statusColor;
    String statusText;
    Icon statusIcon;

    switch (status) {
      case 'Approved':
        statusColor = Colors.green;
        statusText = 'Approved';
        statusIcon = const Icon(Icons.check_circle, color: Colors.green);
        break;
      case 'Pending':
        statusColor = Colors.orange;
        statusText = 'Pending';
        statusIcon = const Icon(Icons.access_time, color: Colors.orange);
        break;
      case 'Rejected':
        statusColor = Colors.red;
        statusText = 'Rejected';
        statusIcon = const Icon(Icons.cancel, color: Colors.red);
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown';
        statusIcon = const Icon(Icons.help, color: Colors.grey);
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
                      items: placeholderImages.map((imagePath) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  imagePath,
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
                      }).toList(),
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

                  // Visit Time with null safety check
                  Text(
                    'Time: ${requestVisitDetails['request_time'] ?? 'Unknown Time'}',
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





