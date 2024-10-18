import 'dart:io'; // Import for File
import 'package:flutter/material.dart';
import 'package:venue_app/models/venue.dart';
import 'package:venue_app/screens/user/venue_details_screen.dart';
import 'package:venue_app/services/venue_service.dart';

class VenueCatalogScreen extends StatefulWidget {
  const VenueCatalogScreen({super.key});

  @override
  _VenueCatalogScreenState createState() => _VenueCatalogScreenState();
}

class _VenueCatalogScreenState extends State<VenueCatalogScreen> {
  String searchQuery = ''; // Search query state
  String selectedCategory = 'All'; // Selected category filter
  List<Venue> venues = []; // List of venues fetched from your model
  bool isLoading = true; // Loading state

  // Define the list of categories (include all your database enum values here)
  final List<String> categories = [
    'All',         // Include All option for no filter
    'Conference',  // Replace with actual categories from your database
    'Wedding',
    'Parties',
    'Corporate',
    'Outdoor',
    'Indoor',
    'Sports',
  ];

  @override
  void initState() {
    super.initState();
    _fetchVenues(); // Fetch venues when the screen initializes
  }

  Future<void> _fetchVenues() async {
    try {
      venues = await VenueService.fetchAll(); // Fetch venues using the API method
    } catch (e) {
      // Handle error
      print('Error fetching venues: $e');
    } finally {
      setState(() {
        isLoading = false; // Update loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Apply search and category filters
    List<Venue> filteredVenues = venues.where((venue) {
      return venue.name.toLowerCase().contains(searchQuery) &&
          (selectedCategory == 'All' || venue.category == selectedCategory);
    }).toList();

    return Scaffold(
      body: isLoading // Show loading indicator while fetching
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator( // Add pull-to-refresh functionality
              onRefresh: _fetchVenues,
              child: Column(
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
                    child: filteredVenues.isEmpty // Check if there are no results
                        ? const Center(child: Text('No venues found.')) // Show no results message
                        : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: filteredVenues.length,
                            itemBuilder: (context, index) {
                              final venue = filteredVenues[index];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VenueDetailsScreen(
                                        name: venue.name,
                                        location: venue.location,
                                        images: venue.images,
                                        pricePerHour: venue.pricePerHour,
                                        availability: venue.availability,
                                        category: venue.category,
                                        additionalDetails: venue.additionalDetails,
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
                                        child: Image.file(
                                          File(venue.images.isNotEmpty
                                              ? venue.images.first
                                              : 'assets/images/venuetest.jpg'),
                                          width: double.infinity,
                                          height: 150,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/venuetest.jpg',
                                              width: double.infinity,
                                              height: 150,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          venue.name,
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
                                          venue.location,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                                        child: Text(
                                          '₱${venue.pricePerHour.toStringAsFixed(2)} per hour',
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',  // Ensure 'Poppins' is used
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
                                              venue.getAverageRating().toStringAsFixed(1),
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
                            },
                          ),
                  ),
                ],
              ),
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
          content: SingleChildScrollView( // Enable scrolling if there are many categories
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: categories.map((category) {
                return ListTile(
                  title: Text(category),
                  leading: Radio(
                    value: category,
                    groupValue: selectedCategory,
                    onChanged: (String? value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}








