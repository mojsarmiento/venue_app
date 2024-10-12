import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:venue_app/bloc/permit_bloc.dart';
import 'package:venue_app/repository/venue_repository.dart';
import 'package:venue_app/screens/venue_owner/venue_owner_home.dart'; // Import your venue owner home page here

class BeAVenueOwnerPage extends StatelessWidget {
  const BeAVenueOwnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BeAVenueOwnerBloc(
        venueRepository: VenueRepository(), // Assuming this is needed for your bloc
      ),
      child: const BeAVenueOwnerForm(),
    );
  }
}

class BeAVenueOwnerForm extends StatefulWidget {
  const BeAVenueOwnerForm({Key? key}) : super(key: key);

  @override
  _BeAVenueOwnerFormState createState() => _BeAVenueOwnerFormState();
}

class _BeAVenueOwnerFormState extends State<BeAVenueOwnerForm> {
  final _formKey = GlobalKey<FormState>();
  File? _businessPermit;

  @override
  void initState() {
    super.initState();
// Request permissions when the form is loaded
  }

  // Function to pick an image from the gallery
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _businessPermit = File(pickedFile.path);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  // Function to handle form submission
  void _submitRequest(BuildContext context) {
    if (_businessPermit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload your business permit')),
      );
      return;
    }

    // Dispatch the upload permit event
    context.read<BeAVenueOwnerBloc>().add(UploadPermitEvent(_businessPermit!));
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
        child: BlocListener<BeAVenueOwnerBloc, BeAVenueOwnerState>(
          listener: (context, state) {
            if (state is BeAVenueOwnerSubmitted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              // Navigate to Venue Owner Home Page after the process is completed
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const VenueOwnerScreen()),
              );
            } else if (state is BeAVenueOwnerError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
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
                  onPressed: () => _submitRequest(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00008B),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


