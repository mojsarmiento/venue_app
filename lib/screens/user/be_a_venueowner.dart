import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:venue_app/screens/venue_owner/venue_owner_home.dart'; // Import your venue owner home page here

class BeAVenueOwnerPage extends StatefulWidget {
  const BeAVenueOwnerPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BeAVenueOwnerPageState createState() => _BeAVenueOwnerPageState();
}

class _BeAVenueOwnerPageState extends State<BeAVenueOwnerPage> {
  final _formKey = GlobalKey<FormState>();
  File? _businessPermit;
  bool _isSubmitting = false; // To track the submission state
  bool _isPending = false; // To track if the process is pending

  // Function to pick an image from the gallery
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _businessPermit = File(pickedFile.path);
      });
    }
  }

  // Function to mock the submission process
  Future<void> _submitRequest() async {
    if (_businessPermit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload your business permit')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true; // Start the submission process
      _isPending = false;   // Reset pending status
    });

    // Simulate a network request delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSubmitting = false; // End the submission process
      _isPending = true;     // Set pending status
    });

    // Show a Snackbar with submission message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form submitted for approval. Your request is pending.')),
    );

    // Navigate to the Venue Owner Home Page after the process is completed
    await Future.delayed(const Duration(seconds: 2)); // Additional delay before navigating
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const VenueOwnerScreen()), // Replace with your home page widget
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Become a Venue Owner',
          style: TextStyle(color: Color(0xFF00008B), fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF00008B)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'To become a venue owner, please upload your business permit:',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Upload Business Permit:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00008B),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  ),
                  child: const Text(
                    'Pick Business Permit Photo',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 15),
                if (_businessPermit != null) ...[
                  Text(
                    'Business Permit Photo Selected: ${_businessPermit!.path.split('/').last}',
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitRequest, // Disable button while submitting
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00008B),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
                const SizedBox(height: 20),
                if (_isPending)
                  const Text(
                    'Your request is pending approval by the admin.',
                    style: TextStyle(fontSize: 16, color: Colors.orange),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




