import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venue_app/bloc/user_bloc.dart';
import 'package:venue_app/bloc/user_event.dart';
import 'package:venue_app/bloc/user_state.dart';
import 'package:venue_app/bloc/venue_bloc.dart';
import 'package:venue_app/bloc/venue_event.dart';
import 'package:venue_app/bloc/venue_state.dart';
import 'package:venue_app/repository/user_repository.dart';
import 'package:venue_app/repository/venue_repository.dart';
import 'package:venue_app/screens/admin/admin_users.dart';
import 'package:venue_app/screens/admin/admin_venues.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch the user count when the widget is built
    BlocProvider.of<UserBloc>(context).add(FetchUserCountEvent());
  }

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
            final userRepository = UserRepository(); // Initialize your user repository
            return UserBloc(userRepository: userRepository)
              ..add(FetchUserCountEvent()); // Fetch user count on initialization
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
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

                // Total Bookings
                BlocBuilder<VenueBloc, VenueState>(builder: (context, state) {
                  if (state is VenueLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is VenueTotalLoaded) {
                    return _buildStatCard(
                      context,
                      icon: Icons.book_online,
                      title: 'Total Bookings',
                      value: '15', // Replace with actual bookings count from your state
                    );
                  } else if (state is VenueError) {
                    return Center(child: Text(state.message));
                  }
                  return Container();
                }),
                const SizedBox(height: 16),

                // Total Request Visits
                BlocBuilder<VenueBloc, VenueState>(builder: (context, state) {
                  if (state is VenueLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is VenueTotalLoaded) {
                    return _buildStatCard(
                      context,
                      icon: Icons.message,
                      title: 'Total Request Visits',
                      value: '5', // Replace with actual request visits count from your state
                    );
                  } else if (state is VenueError) {
                    return Center(child: Text(state.message));
                  }
                  return Container();
                }),
                const SizedBox(height: 16),

                // Total Earnings
                _buildStatCard(
                  context,
                  icon: Icons.monetization_on,
                  title: 'Total Earnings',
                  value: '₱30,000', // Replace with actual earnings data
                ),
                const SizedBox(height: 16),

                // Total Venues
                BlocBuilder<VenueBloc, VenueState>(builder: (context, state) {
                  if (state is VenueLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is VenueTotalLoaded) {
                    return _buildStatCard(
                      context,
                      icon: Icons.house,
                      title: 'Total Venues',
                      value: state.totalVenues.toString(), // Display total venues
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AdminManageVenuesPage(venues: [])),
                        ); // Navigate to Manage Venues Page
                      },
                    );
                  } else if (state is VenueError) {
                    return Center(child: Text(state.message));
                  }
                  return Container();
                }),
                const SizedBox(height: 16),

                // Total Users
                BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                  if (state is UserLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is UserCountLoaded) {
                    return _buildStatCard(
                      context,
                      icon: Icons.person,
                      title: 'Total Users',
                      value: state.userCount.toString(), // Use userCount from UserCountLoaded state
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const ManageUsersPage()),
                        ); // Navigate to Manage Users Page
                      },
                    );
                  } else if (state is UserError) {
                    return Center(child: Text(state.message));
                  }
                  return Container();
                }),
                const SizedBox(height: 16),

                // Total Venue Owner Applications (Placeholder)
                _buildStatCard(
                  context,
                  icon: Icons.monetization_on,
                  title: 'Total Venue Owner Applications',
                  value: '3', // Replace with actual earnings data
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card _buildStatCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String value,
      void Function()? onTap}) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          leading: Icon(icon, color: const Color(0xFF00008B)),
          title: Text(title),
          subtitle: Text(value),
        ),
      ),
    );
  }
}

