import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddVenuePage extends StatefulWidget {
  const AddVenuePage({super.key});

  @override
  _AddVenuePageState createState() => _AddVenuePageState();
}

class _AddVenuePageState extends State<AddVenuePage> {
  final List<Venue> _venues = []; // List to store venues

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _pricePerHourController = TextEditingController();
  final _availabilityController = TextEditingController();
  final _suitableForController = TextEditingController();
  final _additionalDetailsController = TextEditingController();
  
  final List<File> _images = []; // List to store selected images

  final ImagePicker _picker = ImagePicker();

  void _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    setState(() {
      _images.addAll(images.map((e) => File(e.path)).toList());
    });
    }

  void _addVenue() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _venues.add(
          Venue(
            name: _nameController.text,
            location: _locationController.text,
            images: _images.map((file) => file.path).toList(),
            pricePerHour: double.parse(_pricePerHourController.text),
            availability: _availabilityController.text,
            suitableFor: _suitableForController.text,
            additionalDetails: _additionalDetailsController.text,
          ),
        );
        _nameController.clear();
        _locationController.clear();
        _pricePerHourController.clear();
        _availabilityController.clear();
        _suitableForController.clear();
        _additionalDetailsController.clear();
        _images.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                decoration: const InputDecoration(labelText: 'Suitable For'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter suitable for' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _additionalDetailsController,
                decoration: const InputDecoration(labelText: 'Additional Details'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter additional details' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _addVenue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00008B),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: const Text('Add Venue', style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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



