import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venue_app/bloc/request_bloc.dart';
import 'package:venue_app/bloc/request_event.dart';
import 'package:venue_app/bloc/request_state.dart'; // Import RequestState
import 'package:venue_app/bloc/venue_bloc.dart';
import 'package:venue_app/bloc/venue_event.dart';
import 'package:venue_app/bloc/venue_state.dart';
import 'package:venue_app/repository/request_repository.dart';
import 'package:venue_app/repository/venue_repository.dart';
import 'package:venue_app/screens/venue_owner/manage.dart';
import 'package:venue_app/screens/venue_owner/owner_bookings.dart'; // Import your ManageVenuesPage

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final venueRepository = VenueRepository();
            return VenueBloc(venueRepository: venueRepository)
              ..add(FetchTotalVenues()); // Fetch total venues on initialization
          },
        ),
        BlocProvider(
          create: (context) {
            final requestRepository = RequestRepository(); // Initialize your request repository
            return RequestBloc(requestRepository: requestRepository)
              ..add(FetchTotalRequest()); // Fetch total requests on initialization
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Overview',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00008B),
                ),
              ),
              const SizedBox(height: 16),
              
              // Fetch and display total venues
              BlocBuilder<VenueBloc, VenueState>(
                builder: (context, state) {
                  if (state is VenueLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is VenueTotalLoaded) {
                    return Column(
                      children: [
                        _buildStatCard(
                          context,
                          icon: Icons.book_online,
                          title: 'Total Bookings',
                          value: '15', // Replace with actual bookings count from your state
                        ),
                        const SizedBox(height: 16),
                         // Fetch and display total requests
                        BlocBuilder<RequestBloc, RequestState>(
                          builder: (context, state) {
                            if (state is RequestLoading) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (state is RequestTotalLoaded) {
                              return _buildStatCard(
                                context,
                                icon: Icons.message,
                                title: 'Total Request Visits',
                                value: state.totalRequest.toString(), 
                                onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const OwnerBookingsPage(),
                                ));
                              },// Display total requests
                              );
                            } else if (state is RequestError) {
                              return Center(child: Text(state.message));
                            }
                            return Container(); // Return empty container if in initial state
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildStatCard(
                          context,
                          icon: Icons.monetization_on,
                          title: 'Total Earnings',
                          value: '₱30,000', // Replace with actual earnings data
                        ),
                        const SizedBox(height: 16),
                        _buildStatCard(
                          context,
                          icon: Icons.house,
                          title: 'Total Venues',
                          value: state.totalVenues.toString(), // Display total venues
                          onTap: () {
                            // Navigate to Manage Venues Page when tapped
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ManageVenuesPage(venues: [],),
                            ));
                          },
                        ),
                      ],
                    );
                  } else if (state is VenueError) {
                    return Center(child: Text(state.message));
                  }
                  return Container(); // Return empty container if in initial state
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card _buildStatCard(BuildContext context, {required IconData icon, required String title, required String value, VoidCallback? onTap}) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap, // Add onTap callback if provided
        child: ListTile(
          leading: Icon(icon, color: const Color(0xFF00008B)),
          title: Text(title),
          subtitle: Text(value),
        ),
      ),
    );
  }
}




