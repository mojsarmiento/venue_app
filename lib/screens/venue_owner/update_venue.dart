import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:venue_app/models/venue.dart';
import 'package:venue_app/models/venue_category.dart';
import 'package:venue_app/repository/venue_repository.dart';
import 'package:venue_app/widgets/custom_button2.dart';

class UpdateVenuePage extends StatefulWidget {
  final Venue venue;

  const UpdateVenuePage({
    super.key,
    required this.venue, required Function(dynamic updatedVenue) onUpdate,
  });

  @override
  _UpdateVenuePageState createState() => _UpdateVenuePageState();
}

class _UpdateVenuePageState extends State<UpdateVenuePage> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _priceController;
  late TextEditingController _availabilityController;
  late VenueCategory _selectedCategory;
  late TextEditingController _additionalDetailsController;

  List<XFile>? _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.venue.name);
    _locationController = TextEditingController(text: widget.venue.location);
    _priceController = TextEditingController(text: widget.venue.pricePerHour.toString());
    _availabilityController = TextEditingController(text: widget.venue.availability);
    _additionalDetailsController = TextEditingController(text: widget.venue.additionalDetails);

    // Ensure that the category is valid
    _selectedCategory = VenueCategoryExtension.fromString(widget.venue.category);
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null && images.isNotEmpty) {
        setState(() {
          _selectedImages = images;
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
    // Validate selected category
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a valid category')),
      );
      return;
    }

    try {
      Venue updatedVenue = Venue(
        venueId: widget.venue.venueId,
        name: _nameController.text,
        location: _locationController.text,
        images: _selectedImages!.map((image) => image.path).toList(),
        pricePerHour: double.parse(_priceController.text),
        availability: _availabilityController.text,
        category: _selectedCategory.name,
        additionalDetails: _additionalDetailsController.text,
        ratings: widget.venue.ratings,
      );

      await VenueRepository().updateVenue(updatedVenue);
      Navigator.pop(context, updatedVenue);
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
    _additionalDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00008B),
        title: const Text('Update Venue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Venue Name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              CustomButtonIn(
                onPressed: _pickImages,
                text: 'Select Images',
              ),
              const SizedBox(height: 10),
              if (_selectedImages != null && _selectedImages!.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  children: _selectedImages!.map((image) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(image.path),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 16),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price per Hour', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _availabilityController,
                decoration: const InputDecoration(labelText: 'Availability', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<VenueCategory>(
                value: _selectedCategory,
                onChanged: (VenueCategory? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: VenueCategory.values.map((VenueCategory category) {
                  return DropdownMenuItem<VenueCategory>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _additionalDetailsController,
                decoration: const InputDecoration(labelText: 'Additional Details', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              CustomButtonIn(
                onPressed: _saveVenue,
                text: 'Update Venue',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
