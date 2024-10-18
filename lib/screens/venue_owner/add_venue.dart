import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:venue_app/bloc/venue_bloc.dart';
import 'package:venue_app/bloc/venue_event.dart';
import 'package:venue_app/bloc/venue_state.dart';
import 'package:venue_app/models/venue.dart';
import 'package:venue_app/models/venue_category.dart';
import 'package:venue_app/repository/venue_repository.dart';
import 'package:venue_app/widgets/custom_button2.dart';

class AddVenuePage extends StatefulWidget {
  const AddVenuePage({super.key, required List venues});

  @override
  _AddVenuePageState createState() => _AddVenuePageState();
}

class _AddVenuePageState extends State<AddVenuePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _pricePerHourController = TextEditingController();
  final _availabilityController = TextEditingController();
  final _additionalDetailsController = TextEditingController();

  VenueCategory? _selectedCategory; // State for selected category
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  void _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _images.addAll(images.map((e) => File(e.path)).toList());
      });
    }
  }

  void _addVenue(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final venue = Venue(
        venueId: UniqueKey().toString(),
        name: _nameController.text,
        location: _locationController.text,
        images: _images.map((file) => file.path).toList(),
        pricePerHour: double.tryParse(_pricePerHourController.text) ?? 0,
        availability: _availabilityController.text,
        category: _selectedCategory?.name ?? '', // Use selected category
        additionalDetails: _additionalDetailsController.text,
        ratings: [],
      );

      // Dispatch the AddVenueEvent to the VenueBloc
      context.read<VenueBloc>().add(AddVenueEvent(venue));

      // Clear form fields
      _nameController.clear();
      _locationController.clear();
      _pricePerHourController.clear();
      _availabilityController.clear();
      _additionalDetailsController.clear();
      _images.clear();
      _selectedCategory = null; // Reset selected category

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Venue added successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VenueBloc(venueRepository: VenueRepository()),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text(
                  'Add New Venue',
                  style: TextStyle(
                    fontSize: 28, // Slightly larger font size
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00008B),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Venue Name',
                    labelStyle: const TextStyle(color: Color(0xFF00008B)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter venue name' : null,
                ),
                const SizedBox(height: 16),
                // Location field
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    labelStyle: const TextStyle(color: Color(0xFF00008B)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter location' : null,
                ),
                const SizedBox(height: 16),
                // Image Picker
                Row(
                  children: [
                    CustomButtonIn(
                      onPressed: _pickImages,
                      text: 'Select Images',
                    ),
                    const SizedBox(width: 16),
                    Text('${_images.length} images selected'),
                  ],
                ),
                const SizedBox(height: 16),
                // Display selected images
                if (_images.isNotEmpty)
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _images[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 16),
                // Price per Hour
                TextFormField(
                  controller: _pricePerHourController,
                  decoration: InputDecoration(
                    labelText: 'Price per Hour',
                    labelStyle: const TextStyle(color: Color(0xFF00008B)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter price per hour' : null,
                ),
                const SizedBox(height: 16),
                // Availability field
                TextFormField(
                  controller: _availabilityController,
                  decoration: InputDecoration(
                    labelText: 'Availability',
                    labelStyle: const TextStyle(color: Color(0xFF00008B)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter availability' : null,
                ),
                const SizedBox(height: 16),
                // Category field (Dropdown)
                DropdownButtonFormField<VenueCategory>(
                  value: _selectedCategory,
                  onChanged: (VenueCategory? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: const TextStyle(color: Color(0xFF00008B)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: VenueCategory.values.map((VenueCategory category) {
                    return DropdownMenuItem<VenueCategory>(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  validator: (value) => value == null
                      ? 'Please select a category'
                      : null,
                ),
                const SizedBox(height: 16),
                // Additional Details field
                TextFormField(
                  controller: _additionalDetailsController,
                  decoration: InputDecoration(
                    labelText: 'Additional Details',
                    labelStyle: const TextStyle(color: Color(0xFF00008B)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter additional details' : null,
                ),
                const SizedBox(height: 24),
                // Submit button with state management
                BlocBuilder<VenueBloc, VenueState>(builder: (context, state) {
                  if (state is VenueLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is VenueError) {
                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => _addVenue(context),
                          child: const Text('Add Venue'),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    );
                  }
                  return CustomButtonIn(
                    onPressed: () => _addVenue(context),
                    text: 'Add Venue',
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
