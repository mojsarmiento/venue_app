import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BookingDetailsScreen extends StatelessWidget {
  final Map<String, String> booking;

  const BookingDetailsScreen({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    // Placeholder images for carousel
    final List<String> placeholderImages = [
      'assets/images/venuetest.jpg',
      'assets/images/venuetest.jpg',
      'assets/images/venuetest.jpg',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Carousel for venue images
                CarouselSlider(
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
                const SizedBox(height: 16),
                Text(
                  'Venue: ${booking['venue']}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00008B),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Date: ${booking['date']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Time: ${booking['time']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Hours: ${booking['hours']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total Price: ${booking['totalPrice']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Downpayment: ${booking['downpayment']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Status: ${booking['status']}',
                  style: TextStyle(
                    fontSize: 18,
                    color: booking['status'] == 'Confirmed'
                        ? Colors.green
                        : booking['status'] == 'Pending'
                            ? Colors.orange
                            : Colors.red,
                  ),
                ),
                const SizedBox(height: 32),
                if (booking['status'] == 'Pending')
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Cancel Booking'),
                          content: const Text('Are you sure you want to cancel this booking?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Implement actual cancellation logic here
                                Navigator.pop(context); // Close the dialog
                                Navigator.pop(context); // Go back to the previous page
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF00008B),
                    ),
                    child: const Text('Cancel Booking'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}








