import 'package:flutter/material.dart';
import 'package:venue_app/screens/user/booking_details.dart';

class BookingsPage extends StatefulWidget {
  final Map<String, String>? newBooking;

  const BookingsPage({super.key, this.newBooking});

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
        'venue': 'Venue 1',
        'location': 'Location A',
        'date': 'Aug 20, 2024',
        'time': '10:00 AM - 12:00 PM',
        'status': 'Confirmed',
        'totalPrice': '₱2000',
        'downpayment': '₱1000',
        'hours': '2',
      },
      {
        'venue': 'Venue 2',
        'location': 'Location B',
        'date': 'Aug 21, 2024',
        'time': '1:00 PM - 3:00 PM',
        'status': 'Pending',
        'totalPrice': '₱3000',
        'downpayment': '₱1500',
        'hours': '2',
      },
      {
        'venue': 'Venue 3',
        'location': 'Location C',
        'date': 'Aug 22, 2024',
        'time': '2:00 PM - 4:00 PM',
        'status': 'Cancelled',
        'totalPrice': '₱0',
        'downpayment': '₱0',
        'hours': '0',
      },
    ]);

    // Add the new booking if it exists
    if (widget.newBooking != null) {
      _bookings.add(widget.newBooking!);
    }
  }

  Future<bool> _confirmDelete() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this booking?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ?? false;
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
        child: _bookings.isEmpty
            ? const Center(
                child: Text(
                  'No Bookings Yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: _bookings.length,
                itemBuilder: (context, index) {
                  final booking = _bookings[index];

                  // Only allow deletion for confirmed or cancelled bookings
                  final canDelete = booking['status'] != 'Pending';

                  return Dismissible(
                    key: Key(booking['venue']!),
                    direction: canDelete
                        ? DismissDirection.endToStart
                        : DismissDirection.none, // Disable swipe for pending bookings
                    confirmDismiss: (direction) async {
                      if (canDelete) {
                        return await _confirmDelete();
                      }
                      return false; // Do not delete pending bookings
                    },
                    onDismissed: (direction) {
                      final deletedBooking = booking;
                      setState(() {
                        _bookings.removeAt(index);
                      });

                      // Show SnackBar with "Undo" option
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${deletedBooking['venue']} booking deleted"),
                          action: SnackBarAction(
                            label: "Undo",
                            onPressed: () {
                              setState(() {
                                _bookings.insert(index, deletedBooking);
                              });
                            },
                          ),
                        ),
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Card(
                      elevation: 6.0,
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingDetailsScreen(
                                booking: booking,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: booking['status'] == 'Confirmed'
                                        ? Colors.green.withOpacity(0.2)
                                        : booking['status'] == 'Pending'
                                            ? Colors.orange.withOpacity(0.2)
                                            : Colors.red.withOpacity(0.2),
                                    child: Icon(
                                      Icons.event,
                                      size: 30,
                                      color: booking['status'] == 'Confirmed'
                                          ? Colors.green
                                          : booking['status'] == 'Pending'
                                              ? Colors.orange
                                              : Colors.red,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          booking['venue']!,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF00008B),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Location: ${booking['location']}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Date: ${booking['date']}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Text(
                                'Time: ${booking['time']}',
                                style: const TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              Text(
                                'Hours: ${booking['hours']} hours',
                                style: const TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              Text(
                                'Total Price: ${booking['totalPrice']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Downpayment: ${booking['downpayment']}',
                                style: const TextStyle(fontSize: 16, color: Colors.black),
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: booking['status'] == 'Confirmed'
                                        ? Colors.green.withOpacity(0.2)
                                        : booking['status'] == 'Pending'
                                            ? Colors.orange.withOpacity(0.2)
                                            : Colors.red.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    booking['status']!,
                                    style: TextStyle(
                                      color: booking['status'] == 'Confirmed'
                                          ? Colors.green
                                          : booking['status'] == 'Pending'
                                              ? Colors.orange
                                              : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}









