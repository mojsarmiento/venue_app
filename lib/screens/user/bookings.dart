import 'package:flutter/material.dart';
import 'package:venue_app/screens/user/booking_details.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BookingsPageState createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  final List<Map<String, String>> _bookings = [];

  @override
  void initState() {
    super.initState();
    // Initialize with some default bookings if needed
    _bookings.addAll([
      {
        'venue': 'Venue A',
        'date': 'Aug 20, 2024',
        'time': '10:00 AM - 12:00 PM',
        'status': 'Confirmed',
        'totalPrice': '₱0',
        'downpayment': '₱0',
        'hours': '0',
      },
      {
        'venue': 'Venue B',
        'date': 'Aug 21, 2024',
        'time': '1:00 PM - 3:00 PM',
        'status': 'Pending',
        'totalPrice': '₱0',
        'downpayment': '₱0',
        'hours': '0',
      },
      {
        'venue': 'Venue C',
        'date': 'Aug 22, 2024',
        'time': '2:00 PM - 4:00 PM',
        'status': 'Cancelled',
        'totalPrice': '₱0',
        'downpayment': '₱0',
        'hours': '0',
      },
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFF00008B),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _bookings.length,
          itemBuilder: (context, index) {
            final booking = _bookings[index];
            return Card(
              elevation: 4.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Icon(
                  Icons.event,
                  color: booking['status'] == 'Confirmed'
                      ? Colors.green
                      : booking['status'] == 'Pending'
                          ? Colors.orange
                          : Colors.red,
                ),
                title: Text(
                  booking['venue']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00008B),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4.0),
                    Text('Date: ${booking['date']}'),
                    Text('Time: ${booking['time']}'),
                    Text('Hours: ${booking['hours']}'),
                    Text('Total Price: ${booking['totalPrice']}'),
                    Text('Downpayment: ${booking['downpayment']}'),
                    const SizedBox(height: 4.0),
                    Text(
                      'Status: ${booking['status']}',
                      style: TextStyle(
                        color: booking['status'] == 'Confirmed'
                            ? Colors.green
                            : booking['status'] == 'Pending'
                                ? Colors.orange
                                : Colors.red,
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  color: Colors.black54,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingDetailsScreen(
                          booking: booking,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}



