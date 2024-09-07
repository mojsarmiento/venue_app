import 'package:flutter/material.dart';
import 'package:venue_app/screens/admin/admin_update_venues.dart';

class AdminManageVenuesPage extends StatefulWidget {
  const AdminManageVenuesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminManageVenuesPageState createState() => _AdminManageVenuesPageState();
}

class _AdminManageVenuesPageState extends State<AdminManageVenuesPage> {
  final List<Venue> _venues = [
    // Example venues; replace with actual data from your backend
    Venue(
      name: 'Venue 1',
      location: 'Location 1',
      images: ['assets/images/venuetest.jpg'],
      pricePerHour: 100,
      availability: 'Available',
      suitableFor: 'Parties',
      additionalDetails: 'Additional details for Venue 1',
    ),
    Venue(
      name: 'Venue 2',
      location: 'Location 2',
      images: ['assets/images/venuetest.jpg'],
      pricePerHour: 150,
      availability: 'Available',
      suitableFor: 'Meetings',
      additionalDetails: 'Additional details for Venue 2',
    ),
  ];

  void deleteVenue(int index) {
    setState(() {
      _venues.removeAt(index);
    });
  }

    void updateVenue(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminUpdateVenuePage(
          venue: _venues[index],
          onUpdate: (updatedVenue) {
            setState(() {
              _venues[index] = updatedVenue;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Manage Venues',
          style: TextStyle(
            color: Color(0xFF00008B),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: _venues.length,
        itemBuilder: (context, index) {
          final venue = _venues[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(8.0),
              leading: Image.asset(
                venue.images.isNotEmpty ? venue.images.first : 'assets/images/venuetest.jpg',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              title: Text(venue.name),
              subtitle: Text('Location: ${venue.location}\nPrice per Hour: ₱${venue.pricePerHour}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: (){}, //update a venue 
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteVenue(index),
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
