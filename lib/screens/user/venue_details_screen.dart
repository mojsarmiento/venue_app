import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'booking_form.dart';
import 'request_visit_form.dart';

class VenueDetailsScreen extends StatelessWidget {
  final String name;
  final String location;
  final List<String> images;
  final String pricePerHour;
  final String availability;
  final String category;
  final String additionalDetails;

  const VenueDetailsScreen({
    super.key,
    required this.name,
    required this.location,
    required this.images,
    required this.pricePerHour,
    required this.availability,
    required this.category,
    required this.additionalDetails,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = availability.toLowerCase() != 'not available';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Venue Details',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
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
        child: ListView(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 250,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
              ),
              items: images.map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20), // Adjust radius here
                        child: Image.asset(
                          image,
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
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00008B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              location,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Availability:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00008B),
              ),
            ),
            Text(
              availability,
              style: TextStyle(
                fontSize: 16,
                color: isAvailable ? Colors.black87 : Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Category:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00008B),
              ),
            ),
            Text(
              category,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Additional Details:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00008B),
              ),
            ),
            Text(
              additionalDetails,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pricing:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00008B),
              ),
            ),
            Text(
              '₱$pricePerHour per hour',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            if (isAvailable) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestVisitFormScreen(
                        venueName: name, location: location,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5D3FD3),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: const Text(
                  'Request Visit',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingFormScreen(
                        venueName: name,
                        pricePerHour: pricePerHour,
                        location: location,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00008B),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: const Text(
                  'Book Now',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}









