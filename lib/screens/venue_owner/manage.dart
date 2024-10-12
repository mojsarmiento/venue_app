import 'package:flutter/material.dart';
import 'package:venue_app/models/venue.dart'; // Import the Venue class from models
import 'package:venue_app/repository/venue_repository.dart'; // Import the repository
import 'package:venue_app/screens/venue_owner/update_venue.dart'; // Import the Update Venue Page

class ManageVenuesPage extends StatefulWidget {
  const ManageVenuesPage({super.key, required List venues});

  @override
  _ManageVenuesPageState createState() => _ManageVenuesPageState();
}

class _ManageVenuesPageState extends State<ManageVenuesPage> {
  List<Venue> _venues = []; // Initialize _venues as an empty list
  final VenueRepository _venueRepository = VenueRepository(); // Initialize the repository
  bool _isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    _fetchVenues(); // Fetch venues when the widget is initialized
  }

  Future<void> _fetchVenues() async {
    try {
      final venues = await _venueRepository.fetchVenues(); // Fetch venues from the repository
      setState(() {
        _venues = venues; // Update the state with the fetched venues
        _isLoading = false; // Set loading to false after fetching
      });
    } catch (e) {
      // Handle any exceptions (e.g., show an error message)
      print("Error fetching venues: $e");
      setState(() {
        _isLoading = false; // Stop loading on error
      });
    }
  }

  Future<void> _deleteVenue(int index) async {
    // Show confirmation dialog
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this venue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      final venueId = _venues[index].venueId; // Assuming you have a property for venue ID

      try {
        await _venueRepository.deleteVenue(venueId); // Call the delete method in the repository
        setState(() {
          _venues.removeAt(index); // Remove venue from the list if deletion is successful
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Venue deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete venue: $e')),
        );
      }
    }
  }

  void _updateVenue(int index) async {
    // Navigate to the UpdateVenuePage
    final updatedVenue = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return UpdateVenuePage(
            venue: _venues[index],
            onUpdate: (updatedVenue) {
              // This function can be used to pass back the updated venue
              return updatedVenue; // Return the updated venue
            },
          );
        },
      ),
    );

    if (updatedVenue != null) {
      setState(() {
        _venues[index] = updatedVenue; // Update the venue in the list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Manage Your Venues',
          style: TextStyle(
            color: Color(0xFF00008B),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : _venues.isEmpty
              ? Center(child: Text("No venues available.")) // Show message if no venues
              : ListView.builder(
                  itemCount: _venues.length,
                  itemBuilder: (context, index) {
                    final venue = _venues[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8.0),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            venue.images.isNotEmpty
                                ? venue.images.first
                                : 'assets/images/venuetest.jpg', // Placeholder image
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/venuetest.jpg', // Fallback image
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        title: Text(venue.name),
                        subtitle: Text(
                          'Location: ${venue.location}\nPrice per Hour: ₱${venue.pricePerHour.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.black54,
                          fontFamily: 'Poppins'),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _updateVenue(index),
                              color: Colors.blue,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _deleteVenue(index); // Confirm deletion and remove the venue
                              },
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}



