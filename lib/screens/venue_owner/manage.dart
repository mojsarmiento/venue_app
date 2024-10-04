import 'package:flutter/material.dart';
import 'package:venue_app/screens/venue_owner/update_venue.dart';
import 'package:venue_app/models/venue.dart'; // Import the Venue class from models

class ManageVenuesPage extends StatefulWidget {
  final List<Venue> venues; // Use the correct Venue type from the imported model

  const ManageVenuesPage({super.key, required this.venues});

  @override
  _ManageVenuesPageState createState() => _ManageVenuesPageState();
}

class _ManageVenuesPageState extends State<ManageVenuesPage> {
  late List<Venue> _venues; // Late initialization for _venues

  @override
  void initState() {
    super.initState();
    _venues = widget.venues; // Initialize _venues with the passed venues
  }

  void _deleteVenue(int index) {
    setState(() {
      _venues.removeAt(index);
    });
  }

  void _updateVenue(int index) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => UpdateVenuePage(
        venue: _venues[index],
        onUpdate: (updatedVenue) {
          setState(() {
            _venues[index] = updatedVenue;
          });
          Navigator.pop(context); // This should take you back to ManageVenuesPage
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
      body: ListView.builder(
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
                'Location: ${venue.location}\nPrice per Hour: \$${venue.pricePerHour}',
                style: const TextStyle(color: Colors.black54),
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
                    onPressed: () => _deleteVenue(index),
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



