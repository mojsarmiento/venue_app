import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:venue_app/bloc/booking_bloc.dart'; // Ensure correct import
import 'package:venue_app/bloc/booking_event.dart';
import 'package:venue_app/bloc/booking_state.dart';
import 'package:venue_app/models/booking.dart'; // Import your Booking model
import 'package:venue_app/repository/booking_repository.dart';
import 'package:venue_app/screens/user/booking_details.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key, required newBooking, required List bookings});

  @override
  _BookingsPageState createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  final BookingRepository _bookingRepository = BookingRepository(); // Initialize the repository

  @override
  void initState() {
    super.initState();
    // Fetch bookings when the page is initialized
    context.read<BookingBloc>().add(FetchBookings());
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
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            if (state is BookingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BookingError) {
              return Center(child: Text(state.error));
            } else if (state is BookingLoaded) {
              final List<Booking> bookings = state.bookings;

              return bookings.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.builder(
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookings[index];

                        return Dismissible(
                          key: Key(booking.venueName), // Using venueName as unique key
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await _confirmDelete(context);
                          },
                          onDismissed: (direction) {
                            // Handle deletion
                            _deleteBooking(context, booking, bookings, index);
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: _buildBookingCard(context, booking),
                        );
                      },
                    );
            }
            return Container(); // Ensure to return an empty container if the state is not handled
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No Bookings Yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return (await showDialog(
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
        )) ?? false;
  }

  // Updated _deleteBooking method to call the repository and remove from list
  void _deleteBooking(BuildContext context, Booking booking, List<Booking> bookings, int index) async {
    try {
      await _bookingRepository.deleteBookings(booking.id); // Call repository to delete the booking

      setState(() {
        bookings.removeAt(index); // Update the list after successful deletion
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${booking.venueName} booking deleted"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete booking: ${e.toString()}"),
        ),
      );
    }
  }

  Widget _buildBookingCard(BuildContext context, Booking booking) {
    return Card(
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
                bookingDetails: booking, booking: booking, // Pass booking details
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
                    backgroundColor: _getStatusColor(booking.status).withOpacity(0.2), // Background color
                    child: Icon(
                      Icons.event,
                      size: 30,
                      color: _getStatusColor(booking.status), // Icon color
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.venueName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00008B),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Location: ${booking.location}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Date: ${booking.date}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        // Format the time to display in AM/PM
                        Text(
                          'Time: ${_formatTime(booking.time)}', 
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status), // Status color
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    booking.status, // Dynamic status
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to return a color based on the status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange; // Orange for pending
      case 'approved':
        return Colors.green; // Green for confirmed
      case 'rejected':
        return Colors.red; 
      case 'done':
        return Colors.blue;// Red for canceled
      default:
        return Colors.grey; // Default color
    }
  }

  // Method to format time to AM/PM
  String _formatTime(String time) {
    try {
      final DateFormat inputFormat = DateFormat("HH:mm"); // Input format of the time
      final DateFormat outputFormat = DateFormat("h:mm a"); // Output format (AM/PM)
      final DateTime dateTime = inputFormat.parse(time);
      return outputFormat.format(dateTime);
    } catch (e) {
      return time; // Return original if formatting fails
    }
  }
}
