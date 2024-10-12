import 'package:flutter/material.dart';
import 'package:venue_app/screens/user/booking_form.dart';
import 'package:venue_app/screens/user/request_visit_form.dart';
import 'package:venue_app/widgets/custom_button2.dart';

class VenueDetailsScreen extends StatefulWidget {
  final String name;
  final String location;
  final List<String> images;
  final double pricePerHour;
  final String availability;
  final String category;
  final String additionalDetails;
  

  const VenueDetailsScreen({
    super.key,
    required this.name,
    required this.location,
    required this.images,
    required this.pricePerHour,
    required this.availability,
    required this.category,
    required this.additionalDetails,
  });

  @override
  _VenueDetailsScreenState createState() => _VenueDetailsScreenState();
}

class _VenueDetailsScreenState extends State<VenueDetailsScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentIndex = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAvailable = widget.availability.toLowerCase() != 'not available';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Venue Details',
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
      body: Container(
        color: Colors.white, // Background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Carousel
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.images.length,
                itemBuilder: (BuildContext context, int index) {
                  final image = widget.images[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        image,
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
              ),
            ),
            const SizedBox(height: 8),
            // Page Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.images.length, (index) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_currentIndex == index ? 0.9 : 0.4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            // Venue Name
            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00008B),
              ),
            ),
            const SizedBox(height: 8),
            // Location
            Text(
              widget.location,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            // Availability
            const Text(
              'Availability:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00008B),
              ),
            ),
            Text(
              widget.availability,
              style: TextStyle(
                fontSize: 16,
                color: isAvailable ? Colors.black87 : Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            // Category
            const Text(
              'Category:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00008B),
              ),
            ),
            Text(
              widget.category,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Additional Details
            const Text(
              'Additional Details:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00008B),
              ),
            ),
            Text(
              widget.additionalDetails,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Pricing
            const Text(
              'Pricing:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00008B),
              ),
            ),
            Text(
                '₱${widget.pricePerHour.toStringAsFixed(2)} per hour',
                style: const TextStyle(
                fontFamily: 'Poppins',  // Ensure 'Poppins' is used
                fontSize: 16,
                color: Color(0xFF00008B),
              ),
            ),
            const SizedBox(height: 16),
            // Action Buttons
            if (isAvailable) ...[
              CustomButtonIn(
                text: 'Request Visit',
                backgroundColor: const Color(0xFF5D3FD3),
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestVisitFormScreen(
                        venueName: widget.name, location: widget.location,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              CustomButtonIn(
                text: 'Book Now',
                backgroundColor: const Color(0xFF00008B),
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingFormScreen(
                        venueName: widget.name,
                        pricePerHour: widget.pricePerHour,
                        location: widget.location, 
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}













