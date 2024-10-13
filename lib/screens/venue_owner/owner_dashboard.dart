import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venue_app/bloc/venue_bloc.dart';
import 'package:venue_app/bloc/venue_event.dart';
import 'package:venue_app/bloc/venue_state.dart';
import 'package:venue_app/repository/venue_repository.dart';
import 'package:venue_app/screens/venue_owner/manage.dart'; // Import your ManageVenuesPage

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final venueRepository = VenueRepository(); // Base URL set in the repository
        return VenueBloc(venueRepository: venueRepository)..add(FetchTotalVenues()); // Trigger fetch on initialization
      },
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
                        const SizedBox(height: 16), // Add space between cards
                        _buildStatCard(
                          context,
                          icon: Icons.message,
                          title: 'Total Request Visits',
                          value: '5', // Replace with actual request visits count from your state
                        ),
                        const SizedBox(height: 16), // Add space between cards
                        _buildStatCard(
                          context,
                          icon: Icons.monetization_on,
                          title: 'Total Earnings',
                          value: '₱30,000', // Replace with actual earnings data
                        ),
                        const SizedBox(height: 16), // Add space between cards
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
        onTap: onTap, // Add onTap callback
        child: ListTile(
          leading: Icon(icon, color: const Color(0xFF00008B)),
          title: Text(title),
          subtitle: Text(value),
        ),
      ),
    );
  }
}



