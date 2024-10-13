import 'package:flutter/material.dart';
import 'package:venue_app/repository/venue_repository.dart';
import 'package:venue_app/repository/user_repository.dart'; // Import UserRepository
import 'package:venue_app/splashscreen.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc
import 'package:venue_app/bloc/venue_bloc.dart'; // Import VenueBloc
import 'package:venue_app/bloc/user_bloc.dart'; // Import UserBloc

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider( // Use MultiBlocProvider to provide multiple blocs
      providers: [
        BlocProvider(
          create: (context) => VenueBloc(venueRepository: VenueRepository()),
        ),
        BlocProvider(
          create: (context) => UserBloc(userRepository: UserRepository()), // Provide UserBloc
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
        home: const SplashScreen(), // Use SplashScreen as before
      ),
    );
  }
}




