import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import for Bloc
import 'package:intl/intl.dart';
import 'package:venue_app/bloc/booking_bloc.dart';
import 'package:venue_app/bloc/booking_event.dart';
import 'package:venue_app/bloc/booking_state.dart';
import 'package:venue_app/models/booking.dart';
import 'package:venue_app/widgets/custom_button2.dart';
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

  bool _isDownpaymentSuccessful = false; // Track downpayment success

  void _calculatePrice() {
    double hours = double.tryParse(_hoursController.text) ?? 0.0;
    setState(() {
      _totalPrice = hours * widget.pricePerHour;
      _downpayment = _totalPrice * 0.5;
    });
  }

  void _showDownpaymentDialog() {
  // Ensure all required fields are filled before proceeding
  if (_fullNameController.text.isEmpty ||
      _emailController.text.isEmpty ||
      _phoneNumberController.text.isEmpty ||
      _hoursController.text.isEmpty ||
      _selectedDate == null ||
      _selectedTime == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill in all required fields before proceeding.'),
      ),
    );
    return;
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Downpayment Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total Price: ₱${_totalPrice.toStringAsFixed(2)}\n'
              'Downpayment (50%): ₱${_downpayment.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              _processDownpayment(); // Process the downpayment
            },
            child: const Text('Pay Downpayment'),
          ),
        ],
      );
    },
  );
}


  void _processDownpayment() {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Simulate payment processing with a delay
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop(); // Dismiss loading dialog
      setState(() {
        _isDownpaymentSuccessful = true; // Mark downpayment as successful
      });
      _showSuccessMessage(); // Show success message
    });
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Downpayment Successful!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _submitBooking() async {
    if (_formKey.currentState?.validate() ?? false) {
      final booking = Booking(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Generate a unique ID for the booking
        fullName: _fullNameController.text,
        email: _emailController.text,
        phoneNumber: _phoneNumberController.text,
        venueName: widget.venueName,
        location: widget.location,
        date: _selectedDate?.toLocal().toString().split(' ')[0] ?? 'Unknown Date',
        time: _selectedTime?.format(context) ?? 'Unknown Time',
        hours: _hoursController.text,
        totalPrice: _totalPrice,
        downpayment: _downpayment,
        status: 'Pending',
      );

      // Emit an event to the Bloc to create a booking
      context.read<BookingBloc>().add(AddBooking(booking));

      // Listen for the state changes
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
                  builder: (context) => BookingsPage(newBooking: booking.toMap(), bookings: const []),
                ),
              );
            },
          ),
        ),
      );

      // Clear the form fields
      _fullNameController.clear();
      _emailController.clear();
      _phoneNumberController.clear();
      _hoursController.clear();
      setState(() {
        _totalPrice = 0.0;
        _downpayment = 0.0;
        _isDownpaymentSuccessful = false; // Reset downpayment status
        _selectedDate = null;
        _selectedTime = null;
      });
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Processing..."),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingLoading) {
          _showLoadingDialog(context); // Show loading dialog on booking loading state
        } else if (state is BookingLoaded) {
          // Handle successful booking state
          Navigator.of(context).pop(); // Dismiss loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Booking submitted successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: Scaffold(
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
                  'Price: ₱${widget.pricePerHour.toStringAsFixed(2)} per hour',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your full name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your email' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your phone number' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _hoursController,
                  decoration: const InputDecoration(labelText: 'Number of Hours', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _calculatePrice(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of hours';
                    }
                    final hours = double.tryParse(value);
                    if (hours == null || hours <= 0) {
                      return 'Please enter a valid number of hours';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(right: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Selected Date',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedDate != null
                                  ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                                  : 'Not selected',
                              style: TextStyle(
                                fontSize: 14,
                                color: _selectedDate != null ? Colors.black : Colors.red,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () => _selectDate(context),
                              child: const Text('Select Date', style: TextStyle(color: Color(0xFF00008B) ),),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(left: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Selected Time',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedTime != null
                                  ? _selectedTime!.format(context)
                                  : 'Not selected',
                              style: TextStyle(
                                fontSize: 14,
                                color: _selectedTime != null ? Colors.black : Colors.red,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () => _selectTime(context),
                              child: const Text('Select Time',style: TextStyle(color: Color(0xFF00008B) )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

                const SizedBox(height: 16),
                Text(
                  'Total Price: ₱${_totalPrice.toStringAsFixed(2)}\n'
                  'Downpayment (50%): ₱${_downpayment.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: const Color(0xFF5D3FD3)),
                  onPressed: _isDownpaymentSuccessful ? null : _showDownpaymentDialog,
                  child: const Text('Pay Downpayment', style: TextStyle(color: Colors.white ),),
                ),
                const SizedBox(height: 16),
                if (_isDownpaymentSuccessful) // Show the submit button only if downpayment is successful
                  CustomButtonIn(
                    text: 'Submit Booking',
                    onPressed: _submitBooking, // Pass the callback
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
