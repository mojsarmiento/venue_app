import 'package:flutter/material.dart';
import 'package:venue_app/screens/user/requests_page.dart';
import 'package:venue_app/widgets/custom_button2.dart'; // Import the RequestsPage

class RequestVisitFormScreen extends StatefulWidget {
  final String venueName;
  final String location; // Add venueLocation parameter

  const RequestVisitFormScreen({
    super.key,
    required this.venueName,
    required this.location, // Initialize venueLocation
  });

  @override
  // ignore: library_private_types_in_public_api
  _RequestVisitFormScreenState createState() => _RequestVisitFormScreenState();
}

class _RequestVisitFormScreenState extends State<RequestVisitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _pickTime() async {
  TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: const TimeOfDay(hour: 8, minute: 0), // Set the default time to 8 AM
  );

  if (pickedTime != null) {
    // Check if the selected time is within 8 AM to 4 PM
    if (pickedTime.hour >= 8 && pickedTime.hour < 16) {
      setState(() {
        _selectedTime = pickedTime;
      });
      } else {
        // Show an error if the time is outside the allowed range
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a time between 8 AM and 4 PM.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  // Mock submit request function
  void _submitRequest() {
  if (_formKey.currentState!.validate() &&
      _selectedDate != null &&
      _selectedTime != null) {
    // Collect form data
    final requestData = {
      'venue': widget.venueName,
      'location': widget.location,
      'date': '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
      'time': _selectedTime!.format(context),
      'status': 'Pending', // Set initial status
    };

    // Show SnackBar with success message and action button
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Request submitted successfully!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'View My Requests',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to RequestsPage
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RequestsPage(
                  newRequest: requestData,
                ),
              ),
            );
          },
        ),
      ),
    );

    // Clear form fields
    _fullNameController.clear();
    _emailController.clear();
    _phoneNumberController.clear();
    setState(() {
      _selectedDate = null;
      _selectedTime = null;
    });
    } else {
      // Show error message if validation fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all fields correctly.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Request Visit',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00008B), Color(0xFF5D3FD3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Venue: ${widget.venueName}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00008B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Location: ${widget.location}',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Full Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[a-zA-Z]{2,}$').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mobile Number is required';
                  } else if (value.length != 11) {
                    return 'Mobile Number must be at 11 digits';
                  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Enter a valid mobile number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Preffered Date:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00008B),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'Enter date'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Preffered Time:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00008B),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickTime,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedTime == null
                            ? 'Enter time'
                            : _selectedTime!.format(context),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.access_time),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomButtonIn(
                text: 'Submit Request', 
                onPressed: _submitRequest
              ),
            ],
          ),
        ),
      ),
    );
  }
}









