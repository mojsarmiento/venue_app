import 'dart:io';
import 'package:flutter/material.dart';
import 'package:venue_app/models/venue.dart';
import 'package:venue_app/repository/venue_repository.dart';
import 'package:venue_app/screens/venue_owner/update_venue.dart';

class ManageVenuesPage extends StatefulWidget {
  const ManageVenuesPage({super.key, required List venues});

  @override
  _ManageVenuesPageState createState() => _ManageVenuesPageState();
}

class _ManageVenuesPageState extends State<ManageVenuesPage> {
  List<Venue> _venues = [];
  final VenueRepository _venueRepository = VenueRepository();
  bool _isLoading = true;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _fetchVenues();
    _pageController.addListener(() {
      setState(() {
      });
    });
  }

  Future<void> _fetchVenues() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final venues = await _venueRepository.fetchVenues();
      setState(() {
        _venues = venues;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching venues: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteVenue(int index) async {
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
      final venueId = _venues[index].venueId;

      try {
        await _venueRepository.deleteVenue(venueId);
        setState(() {
          _venues.removeAt(index);
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
    final updatedVenue = await Navigator.push<Venue?>(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateVenuePage(
          venue: _venues[index],
          onUpdate: (updatedVenue) {
            return updatedVenue;
          },
        ),
      ),
    );

    if (updatedVenue != null) {
      setState(() {
        _venues[index] = updatedVenue;
      });
    }
  }

  void _viewVenueDetails(int index) {
    final venue = _venues[index];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  venue.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF00008B)),
                ),
                const SizedBox(height: 10),
                Text('Location: ${venue.location}'),
                const SizedBox(height: 10),
                Text('Price per Hour: ₱${venue.pricePerHour.toStringAsFixed(2)}'),
                const SizedBox(height: 10),

                // Image slider using PageView with Dots
                Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: venue.images.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                File(venue.images[index]),
                                fit: BoxFit.cover,
                                width: double.maxFinite,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/venuetest.jpg',
                                    fit: BoxFit.cover,
                                    width: double.maxFinite,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),

                const SizedBox(height: 10),
                Text('Additional Details: ${venue.additionalDetails}'),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close', style: TextStyle(color: Color(0xFF00008B)),),
                ),
              ],
            ),
          ),
        );
      },
    );
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchVenues,
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _venues.isEmpty
              ? const Center(child: Text("No venues available."))
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
                          child: Image.file(
                            File(venue.images.isNotEmpty ? venue.images.first : 'assets/images/venuetest.jpg'),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/venuetest.jpg',
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
                          style: const TextStyle(color: Colors.black54, fontFamily: 'Poppins'),
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'edit', child: Text('Edit')),
                            const PopupMenuItem(value: 'delete', child: Text('Delete')),
                            const PopupMenuItem(value: 'view', child: Text('View')),
                          ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              _updateVenue(index);
                            } else if (value == 'delete') {
                              _deleteVenue(index);
                            } else if (value == 'view') {
                              _viewVenueDetails(index);
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
