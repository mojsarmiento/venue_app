import 'package:flutter/material.dart';
import 'package:venue_app/bloc/request_bloc.dart';
import 'package:venue_app/bloc/booking_bloc.dart';
import 'package:venue_app/repository/request_repository.dart';
import 'package:venue_app/repository/venue_repository.dart';
import 'package:venue_app/repository/user_repository.dart';
import 'package:venue_app/repository/booking_repository.dart';
import 'package:venue_app/splashscreen.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venue_app/bloc/venue_bloc.dart';
import 'package:venue_app/bloc/user_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart'; // Import Stripe package

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set your Stripe publishable key (you can find it in your Stripe Dashboard)
  Stripe.publishableKey = 'pk_test_51Og4l4HmrYAdyFeAFkl5FXT66xD9KIIRTWfSLYLOKqeYyUb7XwyLowbBR5Bo6BGZQrgk2ERqbZZDPoE0C0jYeoi800HmNA5K6V'; // Replace with your actual Stripe Publishable Key

  // Optionally, set the Apple and Google Pay configurations if needed (for mobile apps)
  // Stripe.merchantIdentifier = 'your_merchant_id'; // For Apple Pay
  // Stripe.urlScheme = 'your_app_url_scheme'; // For mobile apps deep linking (optional)

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => VenueBloc(venueRepository: VenueRepository()),
        ),
        BlocProvider(
          create: (context) => UserBloc(userRepository: UserRepository()),
        ),
        BlocProvider(
          create: (context) => RequestBloc(requestRepository: RequestRepository()),
        ),
        BlocProvider(
          create: (context) => BookingBloc(bookingRepository: BookingRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Venue Reservation App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          textTheme: GoogleFonts.poppinsTextTheme(),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
