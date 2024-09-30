import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:venue_app/screens/login.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({Key? key}) : super(key: key);

  @override
  _GuideScreenState createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    _buildPage(
      title: 'Welcome to Venue Reservation App!',
      content: 'Discover and book your perfect venue with ease!',
      image: 'assets/images/venuevista_intro.png', // Add your image path
    ),
    _buildPage(
      title: 'Browse Venues',
      content: 'Explore various venues available for booking.',
      image: 'assets/images/browse_venue.png', // Add your image path
    ),
    _buildPage(
      title: 'Book a Venue',
      content: 'Fill out the booking form to reserve your spot.',
      image: 'assets/images/book_venue.png', // Add your image path
    ),
    _buildPage(
      title: 'Manage Your Bookings',
      content: 'View and manage all your bookings in one place.',
      image: 'assets/images/manage_book.png', // Add your image path
    ),
  ];

  static Widget _buildPage({required String title, required String content, required String image}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: 500), // Adjust image height as necessary
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            content,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _finishGuide();
    }
  }

  void _finishGuide() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasOpened', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00008B), Color(0xFF5D3FD3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  children: _pages,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: _currentPage == index ? 12.0 : 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index ? Colors.white : Colors.white54,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _nextPage,
                child: Text(_currentPage == _pages.length - 1 ? 'Get Started!' : 'Next'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}




