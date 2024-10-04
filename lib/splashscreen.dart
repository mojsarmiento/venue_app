import 'dart:async';
import 'package:flutter/material.dart';
import 'package:venue_app/guide_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Define the animation
    _animation = CurvedAnimation(parent: _controller!, curve: Curves.easeInOut);

    // Start the animation
    _controller!.forward();

    // Navigate to the next screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GuideScreen()), // Replace with your home screen
      );
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00008B), // Dark blue
              Color(0xFF5D3FD3), // Purple
            ],
            begin: Alignment.topCenter, // Gradient starts at the top left
            end: Alignment.bottomCenter, // Gradient ends at the bottom right
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _animation!,
            child: Image.asset(
              'assets/images/venue_vista_logo.png', // Your logo image path
              width: 400, // Adjust the width if needed
              height: 400, // Adjust the height if needed
            ),
          ),
        ),
      ),
    );
  }
}


