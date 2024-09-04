import 'package:flutter/material.dart';
import 'package:venue_app/screens/user/venue_details_screen.dart';

class VenueCatalogScreen extends StatelessWidget {
  const VenueCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: const <Widget>[
        VenueCard(
          name: 'Test Venue 1',
          location: 'Location 1',
          images: ['assets/images/venuetest.jpg', 'assets/images/venuetest.jpg'],
          pricePerHour: '100',
          availability: 'Available on request',
          suitableFor: 'Birthdays, Weddings, Meetings',
          additionalDetails: 'Complete amenities with maximum of 100 people.',
        ),
        VenueCard(
          name: 'Test Venue 2',
          location: 'Location 2',
          images: ['assets/images/venuetest.jpg', 'assets/images/venuetest.jpg'],
          pricePerHour: '150',
          availability: 'Available on request',
          suitableFor: 'Birthdays, Weddings, Meetings',
          additionalDetails: 'Complete amenities with maximum of 100 people.',
        ),
        VenueCard(
          name: 'Test Venue 3',
          location: 'Location 3',
          images: ['assets/images/venuetest.jpg', 'assets/images/venuetest.jpg'],
          pricePerHour: '200',
          availability: 'Available on request',
          suitableFor: 'Birthdays, Weddings, Meetings',
          additionalDetails: 'Complete amenities with maximum of 100 people.',
        ),
      ],
    );
  }
}

class VenueCard extends StatelessWidget {
  final String name;
  final String location;
  final List<String> images; // List of images
  final String pricePerHour;
  final String availability;
  final String suitableFor;
  final String additionalDetails;

  const VenueCard({
    super.key,
    required this.name,
    required this.location,
    required this.images, // List of images
    required this.pricePerHour,
    required this.availability,
    required this.suitableFor,
    required this.additionalDetails,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VenueDetailsScreen(
              name: name,
              location: location,
              images: images, // Pass the list of images
              pricePerHour: pricePerHour,
              availability: availability,
              suitableFor: suitableFor,
              additionalDetails: additionalDetails,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the first image as a single image
            Image.asset(
              images.isNotEmpty ? images.first : 'assets/images/venuetest.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150, // Set height as needed
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00008B),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: Text(
                location,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Text(
                '₱$pricePerHour per hour', // Display price per hour
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF00008B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





