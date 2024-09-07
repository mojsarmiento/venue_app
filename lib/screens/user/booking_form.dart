import 'package:flutter/material.dart';

class BookingFormScreen extends StatefulWidget {
  final String venueName;
  final String pricePerHour;

  const BookingFormScreen({
    super.key,
    required this.venueName,
    required this.pricePerHour,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BookingFormScreenState createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();

  double _totalPrice = 0.0;
  double _downpayment = 0.0;
  bool _isPaymentSuccessful = false;

  void _calculatePrice() {
    double hours = double.tryParse(_hoursController.text) ?? 0.0;
    double pricePerHour = double.tryParse(widget.pricePerHour) ?? 0.0;
    setState(() {
      _totalPrice = hours * pricePerHour;
      _downpayment = _totalPrice * 0.5;
    });
  }

  void _processPayment() {
    // Implement your payment logic here
    // Simulating successful payment
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isPaymentSuccessful = true;
      });
    });
  }

  void _submitBooking() {
  // Create a booking map with the necessary details
  final booking = {
    'venue': widget.venueName,
    'date': _dateController.text,
    'time': _timeController.text,
    'status': 'Pending', // Default status or update as needed
    'totalPrice': '₱$_totalPrice',
    'downpayment': '₱$_downpayment',
    'hours': _hoursController.text,
  };

  // Pass booking details back to the previous screen
  Navigator.pop(context, booking);
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
            const SizedBox(height: 16),
            Text(
              'Price: ₱${widget.pricePerHour} per hour',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
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
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your full name',
              ),
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
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your email',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Phone Number:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00008B),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your phone number',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Date:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00008B),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter date',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    _dateController.text =
                        "${pickedDate.toLocal()}".split(' ')[0];
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Time:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00008B),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _timeController,
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter time',
                prefixIcon: Icon(Icons.access_time),
              ),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    _timeController.text = pickedTime.format(context);
                  });
                }
              },
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
            TextField(
              controller: _hoursController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter number of hours',
              ),
              onChanged: (value) => _calculatePrice(),
            ),
            const SizedBox(height: 16),
            Text(
              'Total Price: ₱$_totalPrice',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Downpayment (50%): ₱$_downpayment',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Remember no cancellations of bookings!',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isPaymentSuccessful
                  ? _submitBooking
                  : _processPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isPaymentSuccessful
                    ? const Color(0xFF00008B)
                    : const Color(0xFF5D3FD3),
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 24),
              ),
              child: Text(
                _isPaymentSuccessful
                    ? 'Submit Booking'
                    : 'Pay Downpayment',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}








