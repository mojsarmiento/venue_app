import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Define the Venue class with updated fields
class Venue {
  Venue({
    required this.name,
    required this.location,
    required this.images,
    required this.pricePerHour,
    required this.availability,
    required this.suitableFor,
    required this.additionalDetails,
  });

  String name;
  String location;
  List<String> images; // Updated to handle a list of image paths
  double pricePerHour;
  String availability;
  String suitableFor;
  String additionalDetails;
}

class AdminUpdateVenuePage extends StatefulWidget {
  final Venue venue;
  final Function(Venue) onUpdate;

  const AdminUpdateVenuePage({required this.venue, required this.onUpdate, super.key});

  @override
  _AdminUpdateVenuePageState createState() => _AdminUpdateVenuePageState();
}

class _AdminUpdateVenuePageState extends State<AdminUpdateVenuePage> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _pricePerHourController;
  late TextEditingController _availabilityController;
  late TextEditingController _suitableForController;
  late TextEditingController _additionalDetailsController;

  final ImagePicker _picker = ImagePicker();
  List<String> _images = []; // This will store the image paths

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.venue.name);
    _locationController = TextEditingController(text: widget.venue.location);
    _pricePerHourController = TextEditingController(text: widget.venue.pricePerHour.toString());
    _availabilityController = TextEditingController(text: widget.venue.availability);
    _suitableForController = TextEditingController(text: widget.venue.suitableFor);
    _additionalDetailsController = TextEditingController(text: widget.venue.additionalDetails);
    _images = List<String>.from(widget.venue.images);
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(pickedFile.path); // Add the new image path to the list
      });
    }
  }

  void _updateVenue() {
    if (_nameController.text.isNotEmpty && _locationController.text.isNotEmpty) {
      final updatedVenue = Venue(
        name: _nameController.text,
        location: _locationController.text,
        images: _images, // Updated images list
        pricePerHour: double.parse(_pricePerHourController.text),
        availability: _availabilityController.text,
        suitableFor: _suitableForController.text,
        additionalDetails: _additionalDetailsController.text,
      );
      widget.onUpdate(updatedVenue);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Update Venue'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00008B), Color(0xFF5D3FD3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        automaticallyImplyLeading: true, foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Venue Name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pricePerHourController,
              decoration: const InputDecoration(labelText: 'Price per Hour'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _availabilityController,
              decoration: const InputDecoration(labelText: 'Availability'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _suitableForController,
              decoration: const InputDecoration(labelText: 'Suitable For'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _additionalDetailsController,
              decoration: const InputDecoration(labelText: 'Additional Details'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00008B),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: const Text('Select Image',
              style: TextStyle(
                color: Colors.white,
              ) ,),
            ),
            const SizedBox(height: 16),
            _images.isNotEmpty
                ? Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _images.map((imagePath) {
                      return Image.file(
                        File(imagePath),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                  )
                : const Text('No images selected'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _updateVenue,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00008B),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: const Text('Update Venue',
              style: TextStyle(
                color: Colors.white
              ),),
            ),
          ],
        ),
      ),
    );
  }
}



