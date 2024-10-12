import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:venue_app/bloc/venue_bloc.dart';
import 'package:venue_app/bloc/venue_event.dart';
import 'package:venue_app/bloc/venue_state.dart';
import 'package:venue_app/models/venue.dart';
import 'package:venue_app/repository/venue_repository.dart';

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
  final _suitableForController = TextEditingController();
  final _additionalDetailsController = TextEditingController();

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
        category: _suitableForController.text,
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
      _suitableForController.clear();
      _additionalDetailsController.clear();
      _images.clear();

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
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00008B),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Venue Name'),
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter venue name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter location' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickImages,
                      child: const Text('Select Images'),
                    ),
                    const SizedBox(width: 16),
                    Text('${_images.length} images selected'),
                  ],
                ),
                const SizedBox(height: 16),
                if (_images.isNotEmpty)
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.file(
                            _images[index],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pricePerHourController,
                  decoration: const InputDecoration(labelText: 'Price per Hour'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter price per hour' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _availabilityController,
                  decoration: const InputDecoration(labelText: 'Availability'),
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter availability' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _suitableForController,
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter suitable for' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _additionalDetailsController,
                  decoration: const InputDecoration(labelText: 'Additional Details'),
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter additional details' : null,
                ),
                const SizedBox(height: 24),
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
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    );
                  }
                  return ElevatedButton(
                    onPressed: () => _addVenue(context),
                    child: const Text('Add Venue'),
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



