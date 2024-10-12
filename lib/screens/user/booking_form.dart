import 'package:flutter/material.dart';
import 'package:venue_app/widgets/custom_button.dart';
import 'bookings.dart';

class BookingFormScreen extends StatefulWidget {
  final String venueName;
  final String location;
  final double pricePerHour;

  const BookingFormScreen({
    super.key,
    required this.venueName,
    required this.location,
    required this.pricePerHour,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BookingFormScreenState createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  double _totalPrice = 0.0;
  double _downpayment = 0.0;
  bool _isPaymentSuccessful = false;

  void _calculatePrice() {
    double hours = double.tryParse(_hoursController.text) ?? 0.0;
    // ignore: unnecessary_type_check
    double pricePerHour = widget.pricePerHour is double
    ? widget.pricePerHour
    : double.tryParse(widget.pricePerHour.toString()) ?? 0.0;

    setState(() {
      _totalPrice = hours * pricePerHour;
      _downpayment = _totalPrice * 0.5;
    });
  }

  void _processPayment() {
    if (_formKey.currentState?.validate() ?? false) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isPaymentSuccessful = true;
        });
      });
    }
  }

  void _submitBooking() {
    if (_formKey.currentState?.validate() ?? false) {
      final booking = {
        'venue': widget.venueName,
        'date': _selectedDate?.toLocal().toString().split(' ')[0] ?? 'Unknown Date',
        'time': _selectedTime?.format(context) ?? 'Unknown Time',
        'location': widget.location,
        'status': 'Pending',
        'totalPrice': '₱$_totalPrice',
        'downpayment': '₱$_downpayment',
        'hours': _hoursController.text,
      };

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Booking submitted successfully!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'View My Bookings',
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingsPage(newBooking: booking, bookings: const [],),
                ),
              );
            },
          ),
        ),
      );

      _fullNameController.clear();
      _emailController.clear();
      _phoneNumberController.clear();
      _hoursController.clear();
      setState(() {
        _totalPrice = 0.0;
        _downpayment = 0.0;
        _isPaymentSuccessful = false;
        _selectedDate = null;
        _selectedTime = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booking Form',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
              Text(
                'Price: ₱${widget.pricePerHour} per hour',
                style: const TextStyle(
                  fontSize: 16, 
                  fontFamily: 'Poppins',
                  color: Colors.black87),
              ),
              const SizedBox(height: 16),
              const Text(
                'Full Name:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00008B),
                ),
              ),
              const SizedBox(height: 8),
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
              const Text(
                'Email:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00008B),
                ),
              ),
              const SizedBox(height: 8),
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
              const Text(
                'Mobile Number:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00008B),
                ),
              ),
              const SizedBox(height: 8),
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
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate != null
                            ? '${_selectedDate!.toLocal()}'.split(' ')[0]
                            : 'Select Date',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null && pickedDate != _selectedDate) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ],
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
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedTime != null ? _selectedTime!.format(context) : 'Select Time',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.access_time),
                      onPressed: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime ?? TimeOfDay.now(),
                        );
                        if (pickedTime != null && pickedTime != _selectedTime) {
                          setState(() {
                            _selectedTime = pickedTime;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Number of Hours:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00008B),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _hoursController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter number of hours',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Number of hours is required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) {
                  _calculatePrice();
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Total Price: ₱$_totalPrice',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Text(
                'Downpayment (50%): ₱$_downpayment',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: _isPaymentSuccessful ? 'Submit Booking' : 'Pay Downpayment',
                backgroundColor: _isPaymentSuccessful ? const Color(0xFF00008B) : const Color(0xFF5D3FD3),
                textColor: Colors.white,
                onPressed: _isPaymentSuccessful ? _submitBooking : _processPayment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}














