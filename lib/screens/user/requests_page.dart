import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:venue_app/bloc/request_bloc.dart'; // Ensure correct import
import 'package:venue_app/bloc/request_event.dart';
import 'package:venue_app/bloc/request_state.dart';
import 'package:venue_app/models/request.dart'; // Import your Request model
import 'package:venue_app/repository/request_repository.dart';
import 'package:venue_app/screens/user/request_details.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  final RequestRepository _requestRepository = RequestRepository(); // Initialize the repository

  @override
  void initState() {
    super.initState();
    // Fetch requests when the page is initialized
    context.read<RequestBloc>().add(FetchRequests());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Requests',
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFF00008B),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<RequestBloc, RequestState>(
          builder: (context, state) {
            if (state is RequestSubmitting) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RequestError) {
              return Center(child: Text(state.message));
            } else if (state is RequestLoaded) {
              final List<Request> requests = state.requests;

              return requests.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final request = requests[index];

                        return Dismissible(
                          key: Key(request.venueName), // Using venueName as unique key
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await _confirmDelete(context);
                          },
                          onDismissed: (direction) {
                            // Handle deletion
                            _deleteRequest(context, request, requests, index);
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: _buildRequestCard(context, request),
                        );
                      },
                    );
            }
            return Container(); // Ensure to return an empty container if the state is not handled
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No Requests Yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm Deletion"),
              content: const Text("Are you sure you want to delete this request?"),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text("Delete"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        )) ?? false;
  }

  // Updated _deleteRequest method to call the repository and remove from list
  void _deleteRequest(BuildContext context, Request request, List<Request> requests, int index) async {
    try {
      await _requestRepository.deleteRequests(request.id); // Call repository to delete the request

      setState(() {
        requests.removeAt(index); // Update the list after successful deletion
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${request.venueName} request deleted"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete request: ${e.toString()}"),
        ),
      );
    }
  }

  Widget _buildRequestCard(BuildContext context, Request request) {
    return Card(
      elevation: 6.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RequestVisitDetailsScreen(
                requestVisitDetails: request.toJson(), venueImages:const [],
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: _getStatusColor(request.status).withOpacity(0.2), // Background color
                    child: Icon(
                      Icons.event,
                      size: 30,
                      color: _getStatusColor(request.status), // Icon color
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.venueName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00008B),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Location: ${request.location}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Date: ${request.requestDate}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        // Format the time to display in AM/PM
                        Text(
                          'Time: ${_formatTime(request.requestTime)}', 
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(request.status), // Status color
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    request.status, // Dynamic status
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to return a color based on the status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange; // Orange for pending
      case 'approved':
        return Colors.green; // Green for approved
      case 'rejected':
        return Colors.red; 
      case 'done':
        return Colors.blue;// Red for rejected
      default:
        return Colors.grey; // Default color
    }
  }

  // Method to format time to AM/PM
  String _formatTime(String time) {
    try {
      final DateFormat inputFormat = DateFormat("HH:mm"); // Input format of the time
      final DateFormat outputFormat = DateFormat("h:mm a"); // Output format (AM/PM)
      final DateTime dateTime = inputFormat.parse(time);
      return outputFormat.format(dateTime);
    } catch (e) {
      return time; // Return original if formatting fails
    }
  }
}



















