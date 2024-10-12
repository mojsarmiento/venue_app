import 'package:flutter/material.dart';
import 'package:venue_app/repository/venue_repository.dart';
import 'package:venue_app/splashscreen.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc
import 'package:venue_app/bloc/venue_bloc.dart'; // Import VenueBloc

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Venue Reservation App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => VenueBloc(venueRepository: VenueRepository()),
        child: const SplashScreen(), // Use SplashScreen as before
      ),
    );
  }
}



