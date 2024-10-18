import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:venue_app/bloc/request_bloc.dart';
import 'package:venue_app/bloc/request_event.dart';
import 'package:venue_app/bloc/request_state.dart';
import 'package:venue_app/widgets/custom_button2.dart';

class RequestVisitFormScreen extends StatefulWidget {
  final String venueName;
  final String location;

  const RequestVisitFormScreen({
    super.key,
    required this.venueName,
    required this.location,
  });

  @override
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
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );

    if (pickedTime != null) {
      if (pickedTime.hour >= 8 && pickedTime.hour < 16) {
        setState(() {
          _selectedTime = pickedTime;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a time between 8 AM and 4 PM.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedTime != null) {
      
      // Combine selected date and time into one DateTime object
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      // Check if the selected date and time are before the current date and time
      if (selectedDateTime.isBefore(now)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a future date and time.'),
            backgroundColor: Colors.red,
          ),
        );
        return; // Stop the function here
      }

      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      String formattedTime = DateFormat('HH:mm:ss').format(DateTime(
        0,
        1,
        1,
        _selectedTime!.hour,
        _selectedTime!.minute,
      ));

      context.read<RequestBloc>().add(SubmitRequestEvent(
        venue: widget.venueName,
        location: widget.location,
        fullName: _fullNameController.text,
        email: _emailController.text,
        mobileNumber: _phoneNumberController.text,
        date: formattedDate,
        time: formattedTime,
      ));

      // Listen to RequestBloc states
      context.read<RequestBloc>().stream.listen((state) {
        if (state is RequestSubmitted) {
          // Show success Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message), // Assuming your RequestSubmitted has a message property
              backgroundColor: Colors.green,
            ),
          );

          // Clear text fields
          _fullNameController.clear();
          _emailController.clear();
          _phoneNumberController.clear();
          setState(() {
            _selectedDate = null;
            _selectedTime = null;
          });
        } else if (state is RequestError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all fields correctly.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Request Visit',
          style: TextStyle(color: Colors.white),
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
                'Preferred Date:',
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
                'Preferred Time:',
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
                onPressed: _submitRequest,
              ),
            ],
          ),
        ),
      ),
    );
  }
}







