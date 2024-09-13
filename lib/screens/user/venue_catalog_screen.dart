import 'package:flutter/material.dart';
import 'package:venue_app/screens/user/venue_details_screen.dart';

class VenueCatalogScreen extends StatefulWidget {
  const VenueCatalogScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VenueCatalogScreenState createState() => _VenueCatalogScreenState();
}

class _VenueCatalogScreenState extends State<VenueCatalogScreen> {
  String searchQuery = ''; // Search query state
  String selectedCategory = 'All'; // Selected category filter

  final List<Map<String, dynamic>> venues = [
    {
      'name': 'Venue 1',
      'location': 'Location 1',
      'images': ['assets/images/venuetest.jpg', 'assets/images/venuetest.jpg'],
      'pricePerHour': '1000',
      'availability': 'Available on request',
      'category': 'Weddings',
      'additionalDetails': 'Complete amenities with maximum of 100 people.',
      'ratings': [5, 4, 3], // Add ratings for Venue 1
    },
    {
      'name': 'Venue 2',
      'location': 'Location 2',
      'images': ['assets/images/venuetest.jpg', 'assets/images/venuetest.jpg'],
      'pricePerHour': '1500',
      'availability': 'Available on request',
      'category': 'Meetings',
      'additionalDetails': 'Complete amenities with maximum of 100 people.',
      'ratings': [4, 4, 5], // Add ratings for Venue 2
    },
    {
      'name': 'Venue 3',
      'location': 'Location 3',
      'images': ['assets/images/venuetest.jpg', 'assets/images/venuetest.jpg'],
      'pricePerHour': '2000',
      'availability': 'Not Available',
      'category': 'Parties',
      'additionalDetails': 'Complete amenities with maximum of 100 people.',
      'ratings': [5, 4, 2], // Add ratings for Venue 3
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 8),
          // Search bar with filter icon on the right
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search venues...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    _showFilterDialog(context); // Open filter dialog
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          // Venue list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: venues
                  .where((venue) {
                    final matchesSearch = venue['name']
                        .toLowerCase()
                        .contains(searchQuery);
                    final matchesCategory = selectedCategory == 'All' ||
                        venue['category'] == selectedCategory;
                    return matchesSearch && matchesCategory;
                  })
                  .map((venue) => VenueCard(
                        name: venue['name'],
                        location: venue['location'],
                        images: List<String>.from(venue['images']),
                        pricePerHour: venue['pricePerHour'],
                        availability: venue['availability'],
                        category: venue['category'],
                        additionalDetails: venue['additionalDetails'],
                        ratings: List<int>.from(venue['ratings']),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Filter dialog function
  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Venues'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('All'),
                leading: Radio(
                  value: 'All',
                  groupValue: selectedCategory,
                  onChanged: (String? value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ListTile(
                title: const Text('Weddings'),
                leading: Radio(
                  value: 'Weddings',
                  groupValue: selectedCategory,
                  onChanged: (String? value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ListTile(
                title: const Text('Parties'),
                leading: Radio(
                  value: 'Parties',
                  groupValue: selectedCategory,
                  onChanged: (String? value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ListTile(
                title: const Text('Meetings'),
                leading: Radio(
                  value: 'Meetings',
                  groupValue: selectedCategory,
                  onChanged: (String? value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class VenueCard extends StatelessWidget {
  final String name;
  final String location;
  final List<String> images;
  final String pricePerHour;
  final String availability;
  final String category;
  final String additionalDetails;
  final List<int> ratings; // Add ratings field

  const VenueCard({
    super.key,
    required this.name,
    required this.location,
    required this.images,
    required this.pricePerHour,
    required this.availability,
    required this.category,
    required this.additionalDetails,
    required this.ratings, // Include ratings in constructor
  });

  // Function to calculate the average rating
  double getAverageRating() {
    if (ratings.isEmpty) return 0.0;
    double sum = ratings.reduce((a, b) => a + b).toDouble();
    return sum / ratings.length;
  }

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
              images: images,
              pricePerHour: pricePerHour,
              availability: availability,
              category: category,
              additionalDetails: additionalDetails,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.asset(
                images.isNotEmpty ? images.first : 'assets/images/venuetest.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
              ),
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
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: Text(
                '₱$pricePerHour per hour',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF00008B),
                ),
              ),
            ),
            // Display the average rating
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    getAverageRating().toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}








