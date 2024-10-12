import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:venue_app/models/venue.dart';
import 'package:venue_app/repository/venue_repository.dart';

class UpdateVenuePage extends StatefulWidget {
  final Venue venue;

  const UpdateVenuePage({super.key, required this.venue, required Function(dynamic updatedVenue) onUpdate});

  @override
  _UpdateVenuePageState createState() => _UpdateVenuePageState();
}

class _UpdateVenuePageState extends State<UpdateVenuePage> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _priceController; // For price per hour
  late TextEditingController _availabilityController; // For availability
  late TextEditingController _categoryController; // For category
  late TextEditingController _additionalDetailsController; // For additional details

  List<XFile>? _selectedImages = []; // List for selected images
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.venue.name);
    _locationController = TextEditingController(text: widget.venue.location);
    _priceController = TextEditingController(text: widget.venue.pricePerHour.toString());
    _availabilityController = TextEditingController(text: widget.venue.availability);
    _categoryController = TextEditingController(text: widget.venue.category);
    _additionalDetailsController = TextEditingController(text: widget.venue.additionalDetails);
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null && images.isNotEmpty) {
        setState(() {
          _selectedImages = images; // Update the selected images
        });
      }
    } catch (e) {
      print('Error picking images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick images: $e')),
      );
    }
  }

  Future<void> _saveVenue() async {
    try {
      Venue updatedVenue = Venue(
        venueId: widget.venue.venueId,
        name: _nameController.text,
        location: _locationController.text,
        images: _selectedImages!.map((image) => image.path).toList(), // Get the path from XFile
        pricePerHour: double.parse(_priceController.text),
        availability: _availabilityController.text,
        category: _categoryController.text,
        additionalDetails: _additionalDetailsController.text,
        ratings: widget.venue.ratings, // Keep the old ratings value
      );

      await VenueRepository().updateVenue(updatedVenue);
      Navigator.pop(context, updatedVenue); // Return the updated venue
    } catch (e) {
      print('Error updating venue: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update venue: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _availabilityController.dispose();
    _categoryController.dispose();
    _additionalDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Venue'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Venue Name'),
              ),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImages,
                child: const Text('Select Images'),
              ),
              const SizedBox(height: 10),
              if (_selectedImages != null && _selectedImages!.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  children: _selectedImages!.map((image) {
                    return Image.file(
                      File(image.path),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    );
                  }).toList(),
                ),
              const SizedBox(height: 10),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price per Hour'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _availabilityController,
                decoration: const InputDecoration(labelText: 'Availability'),
              ),
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: _additionalDetailsController,
                decoration: const InputDecoration(labelText: 'Additional Details'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveVenue,
                child: const Text('Update Venue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

