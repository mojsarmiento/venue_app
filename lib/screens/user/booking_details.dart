import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:venue_app/models/booking.dart';
import 'package:venue_app/widgets/custom_button2.dart';

class BookingDetailsScreen extends StatefulWidget {
  final Booking booking;

  const BookingDetailsScreen({
    super.key,
    required this.booking, required Booking bookingDetails,
  });

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  double _userRating = 0.0;
  bool _isRatingSubmitted = false;

  void _handleRatingUpdate(double rating) {
    setState(() {
      _userRating = rating;
    });
  }

  void _submitRating() {
    setState(() {
      _isRatingSubmitted = true;
    });
    // Handle rating submission logic here (e.g., send to backend)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rating submitted!')),
    );
  }

  String _getStatusMessage(String status) {
    switch (status) {
      case 'Approved':
        return 'Your booking has been approved! Please arrive on time.';
      case 'Pending':
        return 'Your booking is pending approval. We will notify you soon.';
      case 'Rejected':
        return 'Unfortunately, your booking has been rejected.';
      case 'Done':
        return 'Thank you for using our service! We hope to see you again.';
      default:
        return 'Status not recognized. Please check your booking.';
    }
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_PH',
      symbol: '₱',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    // Placeholder images for carousel
    final List<String> placeholderImages = [
      'assets/images/venuetest.jpg',
      'assets/images/venuetest.jpg',
      'assets/images/venuetest.jpg',
    ];

    // Extract the status from the booking
    final String status = widget.booking.status;

    // Determine the status color and text
    Color statusColor;
    String statusText;
    Icon statusIcon;

    switch (status) {
      case 'Approved':
        statusColor = Colors.green;
        statusText = 'Confirmed';
        statusIcon = const Icon(Icons.check_circle, color: Colors.green);
        break;
      case 'Pending':
        statusColor = Colors.orange;
        statusText = 'Pending';
        statusIcon = const Icon(Icons.access_time, color: Colors.orange);
        break;
      case 'Rejected':
        statusColor = Colors.red;
        statusText = 'Cancelled';
        statusIcon = const Icon(Icons.cancel, color: Colors.red);
        break;
      case 'Done':
        statusColor = Colors.blue;
        statusText = 'Done';
        statusIcon = const Icon(Icons.done_all, color: Colors.blue);
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown';
        statusIcon = const Icon(Icons.help, color: Colors.grey);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Carousel for venue images
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 200,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1.0,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                        ),
                        items: placeholderImages.map((imagePath) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    imagePath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(Icons.error, color: Colors.red),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Venue: ${widget.booking.venueName}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00008B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Location: ${widget.booking.location}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Date: ${widget.booking.date}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Time: ${DateFormat.jm().format(DateFormat("HH:mm").parse(widget.booking.time))}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hours: ${widget.booking.hours}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Price: ${_formatCurrency(widget.booking.totalPrice)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Downpayment: ${_formatCurrency(widget.booking.downpayment)}',
                        style: const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      const SizedBox(height: 16),

                      // Status Section
                      Row(
                        children: [
                          statusIcon,
                          const SizedBox(width: 8),
                          Text(
                            'Status: $statusText',
                            style: TextStyle(
                              fontSize: 18,
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Status Message
                      Text(
                        _getStatusMessage(status),
                        style: const TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 24),

                      // Show rating bar and submit button only if the booking status is 'Confirmed'
                      if (status == 'Confirmed') ...[
                        const Text(
                          'Rate this Venue:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        RatingBar.builder(
                          initialRating: _userRating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            if (!_isRatingSubmitted) {
                              _handleRatingUpdate(rating);
                            }
                          },
                          ignoreGestures: _isRatingSubmitted, // Prevent further interaction
                        ),
                        const SizedBox(height: 16),
                        CustomButtonIn(
                          text: _isRatingSubmitted ? 'Rating Submitted' : 'Submit Rating',
                          onPressed: _submitRating,
                          backgroundColor: _isRatingSubmitted ? Colors.grey : const Color(0xFF00008B),
                        ),
                        if (_isRatingSubmitted)
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Thank you for your rating!',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




















